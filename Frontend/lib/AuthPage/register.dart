import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/AllPages/home_page.dart';
import 'package:frontend/AuthPage/login.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/AllPages/routes_page.dart';
import 'dart:convert';
import 'package:frontend/ultils/store.dart';

String? _fullName;
String? _phoneNumber;
String? _password;

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPage();
}

class _SendOtpPage extends State<SendOtpPage> {
  bool _filedEmail = false;
  TextEditingController email = TextEditingController();
  String? _message;
  @override
  void initState() {
    super.initState();
  }

  Future<String?> sendOtp(String email) async {
    debugPrint("Fetch send-otp");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'email': email, 'isRegister': '1'};

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/send-otp'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        // Successfully fetched data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(email: email),
          ),
        );
      } else {
        print('Failed with status code: ${response.statusCode}');
        EasyLoading.dismiss();
        return 'Email has been used';
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login",
              style: TextStyle(
                color: Colors.black,
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              showAlertDialog(context);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1),
              child: Column(children: [
                Text(
                  'Please enter the email address you used to create your account.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  decoration:
                      const InputDecoration(hintText: "Enter your email"),
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _message = null;
                      if (value.isNotEmpty) {
                        _filedEmail = true;
                      }
                      if (value.isEmpty) {
                        _filedEmail = false;
                        return;
                      }
                    });
                  },
                ),
                SizedBox(height: 10),
                Container(
                  height: 20,
                  child: Visibility(
                    visible: (_message != null),
                    child: Text(_message.toString(),
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (email.text == '') {
                            _message = 'Please fill in email';
                            setState(() {});
                            return;
                          }

                          if (!RegExp(
                                  r'^[a-zA-Z0-9_.+-]+(\+[a-zA-Z0-9_.+-]+)?@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(email.text)) {
                            _message = 'Invalid email!';
                            setState(() {});
                            return;
                          }
                          _message = await sendOtp(email.text);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        child: Text("Continue",
                            style: TextStyle(
                                color: (_filedEmail)
                                    ? Colors.white
                                    : Colors.amber[300],
                                fontSize: 16,
                                fontWeight: FontWeight.bold)))),
              ])),
        ]));
  }
}

class VerifyOtpPage extends StatefulWidget {
  String? email;
  VerifyOtpPage({this.email});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPage(email: email);
}

class _VerifyOtpPage extends State<VerifyOtpPage> {
  String? email;
  _VerifyOtpPage({this.email});

  bool _filedOtp = false;
  String? otp;
  String? _message;
  @override
  void initState() {
    super.initState();
  }

  Future<String?> verifyOtp(String email, String otp) async {
    debugPrint("Fetch verify-otp");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'email': email, 'otp': otp};

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/verify-otp'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        String token = jsonData['token'];
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InformPage(email: email, token: token),
          ),
        );
      } else {
        EasyLoading.dismiss();
        print('Failed with status code: ${response.statusCode}');
        return 'Invaid code';
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  Future<String?> sendOtp(String email) async {
    debugPrint("Fetch send-otp");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'email': email, 'isRegister': '1'};

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/send-otp'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        // Successfully fetched data
      } else {
        print('Failed with status code: ${response.statusCode}');
        EasyLoading.dismiss();
        return 'Email has been used';
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login",
              style: TextStyle(
                color: Colors.black,
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              showAlertDialog(context);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1),
              child: Column(children: [
                Text(
                  'Please enter the code we have send to your ' +
                      email.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(hintText: "Enter your code"),
                  autofocus: true,
                  onChanged: (value) {
                    otp = value;
                    _message = null;
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                Container(
                  height: 20,
                  child: Visibility(
                    visible: (_message != null),
                    child: Text(_message.toString(),
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (otp == null || otp == '') {
                            _message = 'Please fill in code';
                            setState(() {});
                            return;
                          }
                          _message =
                              await verifyOtp(email.toString(), otp.toString());
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        child: Text("Continue",
                            style: TextStyle(
                                color: (otp == null)
                                    ? const Color.fromARGB(255, 99, 97, 97)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)))),
                TextButton(
                  child: Text("Resend the code",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    await sendOtp(email.toString());
                  },
                )
              ])),
        ]));
  }
}

class InformPage extends StatefulWidget {
  String? email;
  String? token;
  InformPage({this.email, this.token});

  @override
  State<InformPage> createState() => _InformPage(email: email, token: token);
}

class _InformPage extends State<InformPage> {
  String? email;
  String? token;
  _InformPage({this.email, this.token});

  bool _filledFamilyName = false;
  bool _filedName = false;
  String _textMessage =
      "Please fill in your personal information to create an account";
  Color _colorMessage = Colors.black;
  int _selectedValue = 1;
  bool _filedPassword = false;
  bool _showPass = false;

  TextEditingController _familyName = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _pass = new TextEditingController();

  Future<String?> signUp(
      String password, String firstName, String lastName, String role) async {
    debugPrint("Fetch sign-up");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + token.toString()
    };

    Map<String, dynamic> postData = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'role': role
    };

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/sign-up'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        EasyLoading.dismiss();
        print('Failed with status code: ${response.statusCode}');
        return 'Invaid code';
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Login",
              style: TextStyle(
                color: Colors.black,
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              showAlertDialog(context);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05, right: screenWidth * 0.05),
            child: Container(
                height: 45,
                child: Text(_textMessage,
                    maxLines: 2,
                    style: TextStyle(
                      color: _colorMessage,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center)),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 0),
                    width: screenWidth,
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth * 0.44,
                          child: Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0),
                              child: TextFormField(
                                controller: _familyName,
                                decoration: const InputDecoration(
                                  hintText: "First name",
                                  labelText: "First name",
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _filledFamilyName = true;
                                  } else {
                                    _filledFamilyName = false;
                                  }
                                },
                              )),
                        ),
                        Container(
                          width: screenWidth * 0.44,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.02),
                              child: TextFormField(
                                controller: _name,
                                decoration: const InputDecoration(
                                  hintText: "Last name",
                                  labelText: "Last name",
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _filedName = true;
                                  } else {
                                    _filedName = false;
                                  }
                                },
                              )),
                        ),
                      ],
                    )),
                Column(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.0,
                        left: screenWidth * 0.0,
                        right: screenWidth * 0.0),
                    child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          TextFormField(
                            controller: _pass,
                            obscureText: !_showPass,
                            obscuringCharacter: "•",
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  _filedPassword = true;
                                }
                                if (value.isEmpty) {
                                  _filedPassword = false;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: "Password", labelText: 'Password'),
                          ),
                          GestureDetector(
                            child: Text(
                                _filedPassword
                                    ? (_showPass ? "HIDE" : "SHOW")
                                    : "",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            onTap: onToggleChangePass,
                          )
                        ]),
                  ),
                ]),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Role',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 50),

                    // Ô radio thứ nhất
                    Radio(
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value as int;
                        });
                      },
                    ),
                    Text('Student'),
                    // Ô radio thứ hai
                    SizedBox(width: 15),
                    Radio(
                      value: 2,
                      groupValue: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value as int;
                        });
                      },
                    ),
                    Text('Teacher'),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    child: ElevatedButton(
                        onPressed: () async {
                          checkInput();
                          if (_colorMessage == Colors.red) return;
                          _fullName = _familyName.text.toString() +
                              " " +
                              _name.text.toString();
                          if (!_filedPassword) {
                            _textMessage = "Please enter a password\n";
                            _colorMessage = Colors.red;
                            return;
                          } else {
                            if (_pass.text.length < 6) {
                              _colorMessage = Colors.red;
                              _textMessage = "Password minimum 6 characters\n";
                              return;
                            } else {
                              print(_familyName.text +
                                  ' ' +
                                  _name.text +
                                  ' ' +
                                  _pass.text +
                                  ' ' +
                                  _selectedValue.toString());
                              String roleConvert;
                              if (_selectedValue == 1) {
                                roleConvert = "student";
                              } else {
                                roleConvert = "teacher";
                              }

                              await signUp(_pass.text, _familyName.text,
                                  _name.text, roleConvert);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        child: const Text("Create",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))))
              ],
            ),
          ),
        ]));
  }

  void checkInput() {
    setState(() {
      if (!_filedName && !_filledFamilyName) {
        _textMessage = "Please enter your first and last name";
        _colorMessage = Colors.red;
      } else if (!_filledFamilyName) {
        _textMessage = "Please enter your firs name";
        _colorMessage = Colors.red;
      } else if (!_filedName) {
        _textMessage = "Please enter your last name";
        _colorMessage = Colors.red;
      } else {
        _textMessage = "";
        _colorMessage = Colors.grey;
      }
    });
  }

  void onToggleChangePass() {
    setState(() {
      _showPass = !_showPass;
    });
  }
}

showAlertDialog(BuildContext context) {
  // Đóng bàn phím nếu nó đang mở
  FocusManager.instance.primaryFocus?.unfocus();

  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  Widget cancelButton = GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    },
    child: Padding(
      padding: EdgeInsets.only(top: 7),
      child: Text(
        "Stop creating account",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );
  Widget continueButton = GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: Padding(
      padding: EdgeInsets.only(top: 7),
      child: Text(
        "Continue creating account",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Do you want to stop creating an account?",
      style: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    content: Container(
      height: 120,
      width: screenWidth * 0.6,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "If you stop now, you will lose all of your progress to date.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(alignment: Alignment.bottomRight, child: continueButton),
          Container(alignment: Alignment.bottomRight, child: cancelButton),
          // cancelButton,
        ],
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
