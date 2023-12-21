import 'package:flutter/material.dart';
import 'package:frontend/AllPages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/AllPages/routes_page.dart';
import 'dart:convert';
import 'package:frontend/ultils/store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPage> {
  bool _showPass = false;
  bool _filedPassword = false;
  bool _filedPhoneNumber = false;
  TextEditingController phone = TextEditingController();
  TextEditingController pass = TextEditingController();
  // String? _codeLogin;
  String? _message;
  bool _isLogined = false;
  // Future<List<User>>? _login;
  @override
  void initState() {
    super.initState();
  }

  Future<String?> login(String email, String pass) async {
    debugPrint("Fetch login");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'email': email, 'password': pass};

    try {
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
        return 'Email hoặc mật khẩu không hợp lệ';
      }
      AppStore.ID = userId;
      AppStore.TOKEN = token;
      AppStore.USERNAME = userName;
      AppStore.ROLE = role;

      if (AppStore.TOKEN != '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
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
        padding: EdgeInsets.only(
          top: screenHeight * 0.05,
        ),
        child: Text("Study Planner App",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            )),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.3, vertical: screenHeight * 0.05),
        child: Image.asset(
          "assets/logo.png",
          width: screenWidth * 0.32, // Thiết lập kích thước rộng của hình ảnh
          height: screenHeight * 0.16, // Thiết lập kích thước cao của hình ảnh
          fit: BoxFit.contain,
        ),
      ),
      Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.05,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1),
          child: Column(children: [
            TextFormField(
              controller: phone,
              decoration: const InputDecoration(hintText: "Enter your email"),
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                    _message = 'Invalid email!';
                  } else {
                    _message = null;
                  }
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
                child: Text(_filedPassword ? "SHOW" : "",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                onTap: onToggleChangePass,
              )
            ]),
            SizedBox(height: 20),
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
                  visible: (_isLogined && _message == null),
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
                      if (phone.text == '' || pass.text == '') {
                        _isLogined = false;
                        _message = 'Vui lòng điền đầy đủ email và tài khoản';
                        setState(() {});
                        return;
                      }
                      _message = await login(phone.text, pass.text);
                      if (_message != null) {
                        _isLogined = false;
                        setState(() {});
                      } else {
                        _isLogined = true;
                        setState(() {});
                      }
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
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20),
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
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20),
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
