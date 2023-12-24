import 'package:flutter/material.dart';
import 'package:frontend/Create%20Course/create_course.dart';
import 'package:frontend/Create%20Course/drafting_course_tab.dart';
import 'package:frontend/Create%20Course/published_course_tab.dart';
import 'package:frontend/Route%20Page/complete_routes_tab.dart';
import 'package:frontend/Route%20Page/in_progress_routes_tab.dart';
import 'package:frontend/Create%20Course/course_form.dart';

class TeacherCoursePage extends StatefulWidget {
  const TeacherCoursePage({super.key});

  @override
  State<TeacherCoursePage> createState() => _TeacherCoursePage();
}

class _TeacherCoursePage extends State<TeacherCoursePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("My Courses"),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),

          floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => 
            // CreateCourse(),
            NewCourseScreen(),
            ));
          },
          child: Icon(Icons.add), // Add your icon here
          backgroundColor: Colors.amber, // Change FAB background color
        ),

          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg1.jpg"), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const TabBar(
     
                  tabs: [
                  Tab(
                    icon: Icon(Icons.new_releases, color: Colors.black),
                    child: Text(
                      "Published",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    icon: Icon(Icons.drafts, color: Colors.black),
                    child: Text(
                      "Draft",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
                Expanded(
                  child: TabBarView(
                      children: [PublishedCourses(), DraftingCourses()]),
                )
              ],
            ),
          )),
    );
  }
}
