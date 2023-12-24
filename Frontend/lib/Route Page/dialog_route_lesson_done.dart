import 'package:flutter/material.dart';

class DialogRouteLessonDone extends StatefulWidget {

  final String startDate;
  final String finishDate;

  const DialogRouteLessonDone({super.key, required this.startDate, required this.finishDate});

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
        child: Column(
          children: [
              Text("Begin: " + widget.startDate),
              Text("Complete: " + widget.finishDate)

          ]),
      ),
    );
  }
}