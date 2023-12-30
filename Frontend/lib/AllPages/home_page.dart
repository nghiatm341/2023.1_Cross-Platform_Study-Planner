import 'package:flutter/material.dart';
import 'package:frontend/AllPages/account_page.dart';
import 'package:frontend/AllPages/courses_page.dart';
import 'package:frontend/AllPages/routes_page.dart';
import 'package:frontend/AllPages/social_page.dart';
import 'package:frontend/AllPages/test_upload_image.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndexPage = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _currentIndexPage = index;
    });
  }

  final List _pages = [
    RoutesPage(),
    CoursesPage(),
    SocialPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar: AppBar(
      //   title: Text("Sharing-learn App"),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      //   titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      // ),

      body: _pages[_currentIndexPage],

      bottomNavigationBar: Container(
        color: Colors.amber,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
          child: GNav(
            backgroundColor: Colors.amber,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.yellow.shade600,
            gap: 8,
            padding: EdgeInsets.all(16),

           onTabChange: _navigateBottomBar,

            tabs: const [
            GButton(
              icon: LineIcons.map,
              text: "Routes",
            ),
            GButton(
              icon: LineIcons.school,
              text: "Courses",
            ),
            GButton(
              icon: LineIcons.globe,
              text: "Social",
            ),
            GButton(
              icon: LineIcons.user,
              text: "Account",
            ),
          ]),
        ),
      ),
    );
  }
}
