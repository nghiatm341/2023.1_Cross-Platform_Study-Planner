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

class SendOtpForgetPasswordPage extends StatefulWidget {
  const SendOtpForgetPasswordPage({super.key});

  @override
  State<SendOtpForgetPasswordPage> createState() =>
      _SendOtpForgetPasswordPage();
}

class _SendOtpForgetPasswordPage extends State<SendOtpForgetPasswordPage> {
  bool _filedEmail = false;
  TextEditingController phone = TextEditingController();
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

    Map<String, dynamic> postData = {'email': email, 'isRegister': '0'};

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/send-otp'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpForgetPasswordPage(email: email),
          ),
        );
      } else {
        EasyLoading.dismiss();
        print('Failed with status code: ${response.statusCode}');
        return 'Email dose not exists';
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
                  'Please enter the email address you want to recover your password',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: phone,
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
                        _message = null;
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
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (phone.text == '') {
                            _message = 'Please fill in email';
                            setState(() {});
                            return;
                          }
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(phone.text)) {
                            _message = 'Invalid email!';
                            setState(() {});
                            return;
                          }
                          _message = await sendOtp(phone.text);
                          setState(() {});
                          print(
                              'Failed with status code' + _message.toString());
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

class VerifyOtpForgetPasswordPage extends StatefulWidget {
  String? email;
  VerifyOtpForgetPasswordPage({this.email});

  @override
  State<VerifyOtpForgetPasswordPage> createState() =>
      _VerifyOtpForgetPasswordPage(email: email);
}

class _VerifyOtpForgetPasswordPage extends State<VerifyOtpForgetPasswordPage> {
  String? email;
  _VerifyOtpForgetPasswordPage({this.email});

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
            builder: (context) =>
                ChangePasswordPage(email: email, token: token),
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

    Map<String, dynamic> postData = {'email': email, 'isRegister': '0'};

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/send-otp'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        print('Failed with status code: ${response.statusCode}');
        return 'Email dose not exists';
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
                    // if (value.isNotEmpty) {
                    //   setState(() {
                    //     _message == null;
                    //   });
                    // } else {
                    //   otp == null;
                    // }
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
                          print(otp);
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

class ChangePasswordPage extends StatefulWidget {
  String? email;
  String? token;
  ChangePasswordPage({this.email, this.token});

  @override
  State<ChangePasswordPage> createState() =>
      _ChangePasswordPage(email: email, token: token);
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  String? email;
  String? token;
  _ChangePasswordPage({this.email, this.token});

  String _textMessage =
      "Create a new password. You will use this password to maintain your account.";
  Color _colorMessage = Colors.black;
  // String _textMessage =
  //     "Tạo mật khẩu gồm tối thiểu 6 ký tự. Đó phải là mật khẩu mà người khác không đoán được.";
  bool _filedPassword = false;
  bool _showPass = false;
  TextEditingController _pass = new TextEditingController();

  Future<String?> changePassword(String password) async {
    debugPrint("Fetch sign-up");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + token.toString()
    };

    Map<String, dynamic> postData = {
      'email': email,
      'newPassword': password,
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/user/forget-password'),
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
      } else {
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05, right: screenWidth * 0.05),
            child: Container(
                height: 50,
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
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.0,
                    left: screenWidth * 0.0,
                    right: screenWidth * 0.0),
                child:
                    Stack(alignment: AlignmentDirectional.centerEnd, children: [
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
                        _filedPassword ? (_showPass ? "HIDE" : "SHOW") : "",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    onTap: onToggleChangePass,
                  )
                ]),
              )),
          Container(
              margin: const EdgeInsets.only(top: 15),
              height: screenHeight * 0.055,
              width: screenWidth * 0.9,
              child: ElevatedButton(
                  onPressed: () async {
                    // if (_colorMessage == Colors.red) return;
                    if (!_filedPassword) {
                      _textMessage = "Please enter a password\n";
                      _colorMessage = Colors.red;
                      setState(() {});
                      return;
                    } else {
                      if (_pass.text.length < 6) {
                        _colorMessage = Colors.red;
                        _textMessage = "Password minimum 6 characters\n";
                        setState(() {});
                        return;
                      } else {
                        await changePassword(_pass.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text("Create",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))))
        ],
      ),
    );
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
        "Stop creating a new password",
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
        "Continue creating a new password",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Do you want to stop creating new passwords?",
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
