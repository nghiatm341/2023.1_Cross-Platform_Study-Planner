import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/browse_courses_tab.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Courses"),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: BrowseCoursesTab());
  }
}
