import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/AllPages/change_password.dart';
import 'package:frontend/AuthPage/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  String? gender = 'male';

  bool enableForm = false;
  bool shouldResetForm = true;

  User currentUser = new User();

  final storage = FirebaseStorage.instance.ref();

  XFile? image;
  XFile? pickedImage;
  String imagedUrl = "";
  UploadTask? uploadTask;

  bool uploaded = false;
  bool uploading = false;

  Future<void> getImage() async {
    try {
      if (image?.path != null) {
        clear();
      }
      final picker = ImagePicker();

      image = await picker.pickImage(source: ImageSource.gallery);

      debugPrint('Image: ${image?.path}');

      setState(() {
        pickedImage = image;
      });
    } catch (error) {
      print('Error get image: $error');
    }
  }

  Future<void> uploadImage() async {
    if (image == null) return;

    setState(() {
      uploading = true;
    });

    //image folder in cloud
    Reference cloudAvatarDirectory = storage.child("Avatar");

    // generate image file name
    String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

    //get file image extension (pne or jpg)
    String fileExtension = image!.path.split('.').last.toLowerCase();

    // image need uploaded reference
    Reference imageToUpload =
        cloudAvatarDirectory.child('$uniqueImageName.$fileExtension');

    try {
      // upload image using upload task

      setState(() {
        uploadTask = imageToUpload.putFile(File(image!.path));
      });

      final snapshot = await uploadTask!.whenComplete(() {});

      imagedUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imagedUrl = imagedUrl;
        currentUser.avatar = imagedUrl;
        uploaded = true;
      });

      debugPrint("Image url: ${imagedUrl}");
      Navigator.of(context).pop();
    } catch (error) {
      print('Error upload image: $error');
    }
  }

  void clear(){
    setState(() {
      uploaded = false;
      uploading = false;
      imagedUrl = "";
      pickedImage = null;
      image = null;
    });
  }

  void displayFullAvatar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.network(
            currentUser.avatar,
            fit: BoxFit.contain, // Chọn fit tùy theo yêu cầu của bạn
          ),
        );
      },
    );
  }

  Future<void> displayDialogChangeAvatar() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (pickedImage != null)
                          Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.blue[100],
                            child: Image.file(
                              File(pickedImage!.path),
                              fit: BoxFit.contain,
                            ),
                          ),

                        const SizedBox(height: 12,),

                        ElevatedButton(
                            onPressed: () {
                              getImage();
                              Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  pickedImage = pickedImage;
                                });
                              });
                            },
                            child: Text("Get Image")
                        ),
                        ElevatedButton(
                            onPressed: () {
                              uploadImage();
                              setState(() {
                              });
                            },
                            child: Text("Upload Image")
                        ),

                        if(uploading)
                          buildProgress(),

                        const SizedBox(height: 12,),

                      ]),
                );
              });
        });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });

  void successDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Notification'),
        content: Text(message ?? 'SUCCESS', style: TextStyle(color: Colors.green)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm')
          ),
        ],
      );
    });
  }

  void failDialog(message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notification'),
            content: Text(message ?? 'FAILED', style: TextStyle(color: Colors.red)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Confirm')
              ),
            ],
          );
        });
  }

  Future<void>? fetchUserInfo() async {
    debugPrint("Fetch api get user info");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final String? role = prefs.getString('role');
    final String? token = prefs.getString('token');
    final int? userId = prefs.getInt('userId');
    //final String? userName = prefs.getString('userName');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + token.toString()
    };

    Map<String, dynamic> postData = {'userId': userId};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/user/get-info'),
        headers: headers,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        final userInfo = jsonData['data'];

        currentUser = User(
            id: userInfo['id'],
            email: userInfo['email'],
            firstName: userInfo['firstName'],
            lastName: userInfo['lastName'],
            role: userInfo['role'],
            avatar: userInfo['avatar'],
            score: userInfo['score'],
            status: userInfo['status'],
            countBlock: userInfo['count_block'],
            isDelete: userInfo['is_delete'],
            gender: userInfo['gender'] ?? '',
            phoneNumber: userInfo['phoneNumber'] ?? '',
            createdAt: userInfo['createdAt'],
            updatedAt: userInfo['updatedAt']);

        idController.text = currentUser.id.toString();
        firstNameController.text = currentUser.firstName;
        lastNameController.text = currentUser.lastName;
        gender = currentUser.gender;
        phoneNumberController.text = currentUser.phoneNumber;
        emailController.text = currentUser.email;
        scoreController.text = currentUser.score.toString();
        roleController.text = currentUser.role;
        statusController.text = currentUser.status;

        shouldResetForm = false;
        debugPrint("Get user info successfully");
      } else {
        print('Fail with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error get info: $error');
    }
  }

  Future<void> updateUserInfo() async {
    debugPrint("Updating info");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + token.toString()
    };

    final now = DateTime.now();
    Map<String, dynamic> postData = {
      'id': currentUser.id,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'dob': '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      'phoneNumber': phoneNumberController.text,
      'gender': gender,
      'avatar': currentUser.avatar
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/user/update-info'),
        headers: headers,
        body: jsonEncode(postData),
      );

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response for update: ${response.body}');
      setState(() {
        shouldResetForm = true;
      });
      if (response.statusCode == 200) {
        successDialog(null);
      } else {
        failDialog('Fail: ${response.body}');
      }
    } catch (error) {
      print('Error update info: $error');
      failDialog('Error: $error');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    debugPrint("Fetch logout");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + token.toString()
    };

    Map<String, dynamic> postData = {};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/logout'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        debugPrint("Logout successfully");
      } else {
        print('Logout fail with status code: ${response.statusCode}');
        if (response.statusCode == 400) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage()));
        }
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error logout: $error');
    }
  }

  void changePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePassword(email: currentUser.email)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: shouldResetForm ? fetchUserInfo() : null,
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("User Information"),
                centerTitle: true,
                elevation: 0,
              ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hình ảnh avatar
                            Row(children: [
                              GestureDetector(
                                onTap: () {
                                  !enableForm
                                      ? displayFullAvatar()
                                      : displayDialogChangeAvatar();
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: ClipOval(
                                    child: Image.network(
                                      currentUser.avatar,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Text('Error loading image');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                '${currentUser.firstName} ${currentUser.lastName}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                            SizedBox(height: 16.0),
                            // Các trường thông tin
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'ID',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              controller: idController,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              controller: emailController,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Score',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              controller: scoreController,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Role',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              controller: roleController,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Status',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              controller: statusController,
                            ),
                            TextFormField(
                              readOnly: !enableForm,
                              controller: firstNameController,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            TextFormField(
                              readOnly: !enableForm,
                              controller: lastNameController,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            TextFormField(
                              readOnly: !enableForm,
                              controller: phoneNumberController,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // Chỉ cho phép nhập số
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Male'),
                                    value: 'male',
                                    groupValue: gender,
                                    onChanged: !enableForm
                                        ? null
                                        : (String? value) {
                                            setState(() {
                                              gender = value;
                                            });
                                          },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Female'),
                                    value: 'female',
                                    groupValue: gender,
                                    onChanged: !enableForm
                                        ? null
                                        : (String? value) {
                                            setState(() {
                                              gender = value;
                                            });
                                          },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Other'),
                                    value: 'other',
                                    groupValue: gender,
                                    onChanged: !enableForm
                                        ? null
                                        : (String? value) {
                                            setState(() {
                                              gender = value;
                                            });
                                          },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.0),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  !enableForm
                                      ? ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              enableForm = !enableForm;
                                            });
                                          },
                                          child: Text('Edit'),
                                        )
                                      : (Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  updateUserInfo();
                                                  enableForm = !enableForm;
                                                });
                                              },
                                              child: Text('Save'),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  firstNameController.text =
                                                      currentUser.firstName;
                                                  lastNameController.text =
                                                      currentUser.lastName;
                                                  gender = currentUser.gender;
                                                  phoneNumberController.text =
                                                      currentUser.phoneNumber;
                                                  enableForm = !enableForm;
                                                });
                                              },
                                              child: Text('Cancel'),
                                            ),
                                          ],
                                        )),
                                  const SizedBox(width: 10),
                                  if (!enableForm)
                                    ElevatedButton(
                                        onPressed: () async {
                                          changePassword();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber),
                                        child: const Text("Change Password",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    ),
                                  if (!enableForm)
                                    ElevatedButton(
                                        onPressed: () async {
                                          await logout();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber),
                                        child: const Text("Logout",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class User {
  final int? id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  String avatar;
  final int score;
  final String status;
  final int countBlock;
  final int isDelete;
  final String gender;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;

  User({
    this.id = 0,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.role = '',
    this.avatar = '',
    this.score = 0,
    this.status = '',
    this.countBlock = 0,
    this.isDelete = 0,
    this.gender = '',
    this.phoneNumber = '',
    this.createdAt = '',
    this.updatedAt = '',
  });
}
