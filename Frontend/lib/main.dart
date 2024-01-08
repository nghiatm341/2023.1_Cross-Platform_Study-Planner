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
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? role = prefs.getString('role');
  // final String? token = prefs.getString('token');
  //   final int? userId = prefs.getInt('userId');
  //   final String? userName = prefs.getString('userName');

  // final client = http.Client();
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(onError: (DioError e, handler) {
    if (e.response?.statusCode == 401) {
      // Xử lý chuyển hướng về màn hình login ở đây
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
    return handler.next(e);
  }));

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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: initialPage,
      theme: ThemeData(primarySwatch: Colors.amber),
      builder: EasyLoading.init(),
    );
  }
}
