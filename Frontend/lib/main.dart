import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/AllPages/home_page.dart';
import 'package:frontend/AllPages/home_page_admin.dart';
import 'package:frontend/AllPages/home_page_teacher.dart';
import 'package:frontend/AllPages/routes_page.dart';
import 'package:frontend/AuthPage/login.dart';
import 'package:frontend/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? role = prefs.getString('role');
  // final String? token = prefs.getString('token');
  //   final int? userId = prefs.getInt('userId');
  //   final String? userName = prefs.getString('userName');

  Widget _getHomePageBasedOnRole(String role) {
    switch (role) {
      case 'student':
        return HomePage();
      case 'teacher':
        return HomePageTeacher();
      case 'admin':
        return HomePageAdmin();
      default:
        return LoginPage();
    }
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Widget initialPage = _getHomePageBasedOnRole(role.toString());

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialPage,
      theme: ThemeData(primarySwatch: Colors.amber),
      builder: EasyLoading.init(),
    );
  }
}
