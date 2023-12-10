import 'package:flutter/material.dart';

class DialogRouteLessonUnDone extends StatefulWidget {
  const DialogRouteLessonUnDone({super.key});

  @override
  State<DialogRouteLessonUnDone> createState() => _DialogRouteLessonUnDoneState();
}

class _DialogRouteLessonUnDoneState extends State<DialogRouteLessonUnDone> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber,
      content: Container(
        height: 120,
        child: Text("Lesson Undone dialog"),
      ),
    );
  }
}