import 'package:flutter/material.dart';

class CreateCourse extends StatefulWidget {
  const CreateCourse({super.key});

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a course",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}