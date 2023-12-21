import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                await logout();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Text("Logout",
                  style: TextStyle(
                      color: Colors.amber[300],
                      fontSize: 16,
                      fontWeight: FontWeight.bold)))),
    );
  }
}
