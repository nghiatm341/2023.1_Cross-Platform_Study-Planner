import 'package:flutter/material.dart';

class DialogRouteLessonDone extends StatefulWidget {

  const DialogRouteLessonDone({super.key});

  @override
  State<DialogRouteLessonDone> createState() => _DialogRouteLessonDone();
}

class _DialogRouteLessonDone extends State<DialogRouteLessonDone> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber,
      content: Container(
        height: 120,
        child: Text("Lesson done dialog"),
      ),
    );
  }
}