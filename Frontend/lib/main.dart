import 'package:flutter/material.dart';
import 'package:frontend/AllPages/home_page.dart';
import 'package:frontend/AllPages/routes_page.dart';
import 'package:frontend/AuthPage/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(primarySwatch: Colors.amber),
    );
  }
}
