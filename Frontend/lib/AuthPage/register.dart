import 'package:flutter/material.dart';
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
String _messagePhone =
    "Nhập số di động để liên hệ của bạn. Bạn có thể ẩn thông tin này trên trang cá nhân sau.";

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPage();
}

class _SendOtpPage extends State<SendOtpPage> {
  bool _filedEmail = false;
  TextEditingController phone = TextEditingController();
  String? _message;
  bool _isClickContinue = false;
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
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/send-otp'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(email: email),
          ),
        );
      } else {
        print('Failed with status code: ${response.statusCode}');
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
                  controller: phone,
                  decoration:
                      const InputDecoration(hintText: "Enter your email"),
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        _message = 'Invalid email!';
                      } else {
                        _message = null;
                      }
                      if (value.isNotEmpty) {
                        _filedEmail = true;
                      }
                      if (value.isEmpty) {
                        _filedEmail = false;
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
                  height: 20,
                  child: Visibility(
                      visible: (_isClickContinue && _message == null),
                      child: Container(
                        height: 20,
                        width: 20,
                        child: Center(child: CircularProgressIndicator()),
                      )),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    child: ElevatedButton(
                        onPressed: _message != null
                            ? () {}
                            : () async {
                                if (phone.text == '') {
                                  _isClickContinue = false;
                                  _message = 'Please fill in email';
                                  setState(() {});
                                  return;
                                }
                                if (_message != null) {
                                  _isClickContinue = false;
                                } else {
                                  _isClickContinue = true;
                                }
                                setState(() {});
                                _message = await sendOtp(phone.text);
                                if (_message != null) {
                                  _isClickContinue = false;
                                } else {
                                  _isClickContinue = true;
                                }
                                setState(() {});
                                print('Failed with status code' +
                                    _message.toString());
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
  int? otp;
  String? _message;
  bool _isClickContinue = false;
  @override
  void initState() {
    super.initState();
  }

  Future<String?> verifyOtp(String email, int? otp) async {
    debugPrint("Fetch verify-otp");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'email': email, 'otp': otp.toString()};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/verify-otp'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        String token = jsonData['token'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InformPage(email: email, token: token),
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
                    otp = int.parse(value);
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
                  height: 20,
                  child: Visibility(
                      visible: (otp != null && _message == null),
                      child: Container(
                        height: 20,
                        width: 20,
                        child: Center(child: CircularProgressIndicator()),
                      )),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (otp == null) {
                            print("run here");
                            _message = 'Please fill in code';
                            setState(() {});
                            return;
                          }
                          if (_message != null) {
                            _isClickContinue = false;
                          } else {
                            _isClickContinue = true;
                          }
                          _message = await verifyOtp(email.toString(), otp);
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
  // String _textMessage =
  //     "Tạo mật khẩu gồm tối thiểu 6 ký tự. Đó phải là mật khẩu mà người khác không đoán được.";
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
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/sign-up'),
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
        body: Column(children: [
          Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, right: screenWidth * 0.05),
              child: Text(_textMessage,
                  style: TextStyle(
                    color: _colorMessage,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center)),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 0),
                    height: screenHeight * 0.06,
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
                            child: Text(_filedPassword ? "SHOW" : "",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            onTap: onToggleChangePass,
                          )
                        ]),
                  ),
                ]),
                SizedBox(height: 15),
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
                    margin: const EdgeInsets.only(top: 30),
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
                            _textMessage = "Vui lòng nhập mật khẩu.\n";
                            _colorMessage = Colors.red;
                            return;
                          } else {
                            if (_pass.text.length < 6) {
                              _colorMessage = Colors.red;
                              _textMessage = "Mật khẩu quá ngắn.\n";
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
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
        _textMessage = "Vui lòng nhập họ và tên của bạn.";
        _colorMessage = Colors.red;
      } else if (!_filledFamilyName) {
        _textMessage = "Vui lòng nhập họ của bạn.";
        _colorMessage = Colors.red;
      } else if (!_filedName) {
        _textMessage = "Vui lòng nhập tên của bạn.";
        _colorMessage = Colors.red;
      } else {
        _textMessage = "Nhập tên bạn sử dụng trong đời thực.";
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
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  // set up the buttons
  // Widget cancelButton = TextButton(
  //   child: Text("Stop creating account", style: TextStyle(color: Colors.red)),
  //   onPressed: () {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => LoginPage()));
  //   },
  // );
  // Widget continueButton = TextButton(
  //   child:
  //       Text("Continue creating account", style: TextStyle(color: Colors.grey)),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //     ;
  //   },
  // );
  Widget cancelButton = GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    },
    child: Padding(
      padding: EdgeInsets.only(top: 10),
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
      padding: EdgeInsets.only(top: 10),
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
      height: screenHeight * 0.15,
      width: screenWidth * 0.6,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
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
