import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/AuthPage/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/ultils/store.dart';
import 'package:frontend/const.dart' as constaint;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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

  User currentUser = User(
    id: AppStore.ID,
  );

  Future<void>? fetchUserInfo() async {
    debugPrint("Fetch api get user info");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + AppStore.TOKEN.toString()
    };

    Map<String, dynamic> postData = {'userId': currentUser.id};

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
      print('Error: $error');
    }
  }

  Future<void> updateUserInfo() async {
    debugPrint("Updating info");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + AppStore.TOKEN.toString()
    };

    final now = DateTime.now();
    Map<String, dynamic> postData = {
      'id': currentUser.id,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'dob': '${now.year}-${now.month}-${now.day}',
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
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> logout() async {
    debugPrint("Fetch logout");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + AppStore.TOKEN.toString()
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        debugPrint("Logout successfully");
      } else {
        print('Logout fail with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
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
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(currentUser.avatar),
                                radius: 50,
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
                              decoration:
                              InputDecoration(
                                labelText: 'ID',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              initialValue: currentUser.id.toString(),
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(fontSize: 18),
                              decoration:
                              InputDecoration(
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
                              decoration:
                              InputDecoration(
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
                              decoration:
                              InputDecoration(
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
                              decoration:
                              InputDecoration(
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
                              decoration:
                                  InputDecoration(
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
                              decoration:
                              InputDecoration(
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
                              decoration:
                              InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
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
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await logout();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      child: Text("Logout",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold))),
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
  final String avatar;
  final int score;
  final String status;
  final int countBlock;
  final int isDelete;
  final String gender;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
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
