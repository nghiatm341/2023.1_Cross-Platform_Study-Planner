import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  bool checkPassChange = false;
  final passwordCtrl = TextEditingController();
  final passwordCfmCtrl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordCtrl.dispose();
    passwordCfmCtrl.dispose();
    super.dispose();
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
                          controller: passwordCtrl,
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
                          controller: passwordCfmCtrl,
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
                            // Điều hướng về trang đăng nhập
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
    if (passwordCtrl.text.length < 6 || passwordCtrl.text.length > 12) {
      checkPassChange = false;
      return _showAlertDialog(context, 'Error', 'Password must be more than 6 characters and less than 12 characters');
    }
    if (passwordCtrl.text == passwordCfmCtrl.text) {
      checkPassChange = true;
      _showAlertDialog(context, 'Success', 'Password changed successfully');
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

