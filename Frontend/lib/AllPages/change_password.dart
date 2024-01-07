import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/AllPages/account_page.dart';
import 'package:frontend/AuthPage/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;

class ChangePassword extends StatefulWidget {
  final String email;

  const ChangePassword({super.key, required this.email});

  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool showOldPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  bool checkPassChange = false;
  final _oldpasswordCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordCfmCtrl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _oldpasswordCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordCfmCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    debugPrint("Changing password");

    Map<String, String> headers = {
      'Content-Type':
      'application/json', // Set the content type for POST request
      // Add other headers if needed
      'Authorization': 'Bearer ' + token.toString()
    };

    Map<String, dynamic> postData = {
      'email': widget.email,
      'oldPassword': _oldpasswordCtrl.text,
      'newPassword': _passwordCfmCtrl.text
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/user/change-password'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );
      if (response.statusCode == 200) {
        // Successfully fetched data
        await prefs.clear();
        checkPassChange = true;

        debugPrint("Change password successfully");
        _showAlertDialog(context, 'Success', 'Password changed successfully');
      } else {
        print('Change password fail with status code: ${response.statusCode}');
        _showAlertDialog(context, 'Error', response.body);
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error logout: $error');
      _showAlertDialog(context, 'Error', error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Old Password',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _oldpasswordCtrl,
                          obscureText: !showOldPassword,
                          decoration: InputDecoration(
                            hintText: 'Type your old password here',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(showOldPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showOldPassword = !showOldPassword;
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _passwordCtrl,
                          obscureText: !showNewPassword,
                          decoration: InputDecoration(
                            hintText: 'Type your new password here',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(showNewPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Confirm New Password',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _passwordCfmCtrl,
                          obscureText: !showConfirmPassword,
                          decoration: InputDecoration(
                            hintText: 'Confirm your new password',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _onConfirmPressed,
                          child: Text('Confirm'),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.black)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountPage()));
                          },
                          child: Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onConfirmPressed() {
    // Kiểm tra xem hai trường mật khẩu có khớp nhau không
    if (_passwordCtrl.text.length < 6 || _passwordCtrl.text.length > 12) {
      checkPassChange = false;
      return _showAlertDialog(context, 'Error', 'Password must be more than 6 characters and less than 12 characters');
    }
    if (_passwordCtrl.text == _passwordCfmCtrl.text) {
      _changePassword();
    } else {
      checkPassChange = false;
      _showAlertDialog(context, 'Error', 'Passwords do not match');
    }
  }

  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (checkPassChange) {
                  // Điều hướng về trang đăng nhập
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()));
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

