import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/course_lesson_detail.dart';
import 'package:frontend/Course%20Page/popup_subscribe.dart';

class CourseLessonItem extends StatefulWidget {
  final CourseLessonData lessonData;
  final int lessonIndex;

  const CourseLessonItem({
    super.key,
    required this.lessonIndex,
    required this.lessonData,
  });

  @override
  State<CourseLessonItem> createState() => _CourseLessonItemState();
}

class _CourseLessonItemState extends State<CourseLessonItem> {
  void tapCourseLessonItem() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CourseLessonDetail(
                lessonData: widget.lessonData,
                lessonIndex: widget.lessonIndex)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      child: GestureDetector(
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //lesson title
              Expanded(
                flex: 8,
                child: Container(
                  //color: Color.fromARGB(255, 253, 234, 124),
                  height: 70,
                  alignment: Alignment.centerLeft,
      
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Lesson " +
                        (widget.lessonIndex + 1).toString() +
                        " : " +
                        widget.lessonData.title,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
      
              // actions
            ],
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            border:
                Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 92, 92, 92)
                    .withOpacity(0.5), // Shadow color with opacity
                spreadRadius: 1, // Spread radius
                blurRadius: 2, // Blur radius
                offset: Offset(1, 3), // Offset of the shadow
              ),
            ],
          ),
        ),

        onTap: tapCourseLessonItem,
      ),
    );
  }
}

class CourseLessonData {
  final int lessonId;
  final String title;
  final List contents;

  CourseLessonData({
    required this.lessonId,
    required this.title,
    required this.contents,
  });
}
