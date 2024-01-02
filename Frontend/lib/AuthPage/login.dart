import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/AllPages/home_page.dart';
import 'package:frontend/AllPages/home_page_admin.dart';
import 'package:frontend/AllPages/home_page_teacher.dart';
import 'package:frontend/AuthPage/forgotPassword.dart';
import 'package:frontend/AuthPage/register.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/AllPages/routes_page.dart';
import 'dart:convert';
import 'package:frontend/ultils/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPage> {
  bool _showPass = false;
  bool _filedPassword = false;
  bool _filedPhoneNumber = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  String? _message;
  @override
  void initState() {
    super.initState();
  }

  Future<String?> login(String email, String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    debugPrint("Fetch login");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'email': email, 'password': pass};

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/login'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      String token = '';
      String userName = '';
      int userId;
      String role = '';
      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        token = jsonData['token'];
        userName = jsonData['userName'];
        userId = jsonData['id'];
        role = jsonData['role'];
      } else {
        print('Failed with status code: ${response.statusCode}');

        EasyLoading.dismiss();
        return 'Email or password is invalid';
      }
      await prefs.setInt('userId', userId);
      await prefs.setString('token', token);
      await prefs.setString('userName', userName);
      await prefs.setString('role', role);
      // AppStore.ID = userId;
      // AppStore.TOKEN = token;
      // AppStore.USERNAME = userName;
      // AppStore.ROLE = role;

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageAdmin(),
          ),
        );
      } else if (role == 'teacher') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageTeacher(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }

      EasyLoading.dismiss();
      return null;
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
        body: Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0, vertical: screenHeight * 0.015),
        child: Image.asset(
          "assets/logo-bkhn-04.png",
          width: screenWidth * 1,
          height: screenHeight * 0.075,
          fit: BoxFit.contain,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.0,
        ),
        child: Text("Study Planner App",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            )),
      ),
      Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1),
          child: Column(children: [
            TextFormField(
              controller: email,
              decoration: const InputDecoration(hintText: "Enter your email"),
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  _message = null;
                  if (value.isNotEmpty) {
                    _filedPhoneNumber = true;
                  }
                  if (value.isEmpty) {
                    _filedPhoneNumber = false;
                  }
                });
              },
            ),
            Stack(alignment: AlignmentDirectional.centerEnd, children: [
              TextFormField(
                controller: pass,
                obscureText: !_showPass,
                obscuringCharacter: "•",
                onChanged: (value) {
                  setState(() {
                    if (_message == 'Invalid email!') {
                      return;
                    }
                    _message = null;
                    if (value.isNotEmpty) {
                      _filedPassword = true;
                    }
                    if (value.isEmpty) {
                      _filedPassword = false;
                    }
                  });
                },
                decoration:
                    const InputDecoration(hintText: "Enter your password"),
              ),
              GestureDetector(
                child: Text(_filedPassword ? (_showPass ? "HIDE" : "SHOW") : "",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                onTap: onToggleChangePass,
              )
            ]),
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
                margin: const EdgeInsets.only(top: 0),
                height: screenHeight * 0.055,
                width: screenWidth,
                child: ElevatedButton(
                    onPressed: () async {
                      if (email.text == '' || pass.text == '') {
                        _message = 'Please fill in both email and account';
                        setState(() {});
                        return;
                      }
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(email.text)) {
                        _message = 'Invalid email!';
                        setState(() {});
                        return;
                      }
                      _message = await login(email.text, pass.text);
                      setState(() {});
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: Text("Login",
                        style: TextStyle(
                            color: (_filedPassword && _filedPhoneNumber)
                                ? Colors.white
                                : Colors.amber[300],
                            fontSize: 16,
                            fontWeight: FontWeight.bold)))),
            GestureDetector(
              onTap: () {
                // Handle the onTap event, e.g., navigate to the forgot password screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendOtpForgetPasswordPage(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Forgot password ?",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle the onTap event, e.g., navigate to the forgot password screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendOtpPage(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Create new account",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ])),
    ]));
  }

  void onToggleChangePass() {
    setState(() {
      _showPass = !_showPass;
    });
  }
}
