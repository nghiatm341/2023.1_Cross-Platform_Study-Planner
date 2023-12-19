import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/dialog_route_lesson_done.dart';
import 'package:frontend/Route%20Page/dialog_route_lesson_undone.dart';
import 'package:frontend/Route%20Page/route_lesson_detail.dart';

class RouteLessonItem extends StatefulWidget {

  final int index;
  final String routeId;
  final String title;
  final RouteCustomLessonData customLessonData;
  final RouteCourseLessonData courseLessonData;
  final VoidCallback onCompleteLesson;
  final VoidCallback onChangeLesson;

  const RouteLessonItem({
    super.key, 
    required this.index, 
    required this.routeId, 
    required this.title, 
    required this.customLessonData, 
    required this.courseLessonData,
    required this.onCompleteLesson,
    required this.onChangeLesson
    });

  @override
  State<RouteLessonItem> createState() => _RouteLessonItemState();
}

class _RouteLessonItemState extends State<RouteLessonItem> {

  void tapRouteLessonItem() {
    Navigator.push(context, 
    MaterialPageRoute(
      builder: (context) => RouteLessonDetail
      (courseLessonData: widget.courseLessonData, 
      lessonIndex: widget.index, 
      isCompleted: widget.customLessonData.isCompleted,
      onCompleteLesson: widget.onCompleteLesson,
      routeId: widget.routeId,
      )));
  }

  void showDialogLessonDone(){
      showDialog(
        context: context, 
        builder: (context) {
        return DialogRouteLessonDone();
      });
  }

  void showDialogLessonUnDone(){
    showDialog(
        context: context, 
        builder: (context) {
        return DialogRouteLessonUnDone(
          routeCreatedTime: widget.customLessonData.routeCreatedAt, 
          studyTime: widget.customLessonData.studyTime,
          routeId: widget.routeId,
          lessonId: widget.customLessonData.lessonId,
          onChangeStudyTime: widget.onChangeLesson,
          );
      });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            //lesson title
            Expanded(
              flex: 8,
              child: GestureDetector(
                child: Container(
                  color: Colors.white,
                  height: 70,
                  alignment: Alignment.centerLeft,
                
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Lesson " + (widget.index + 1).toString() + " : " + widget.title,
                      style: TextStyle(fontSize: 16),
                    )
                    
                    ),

                onTap: tapRouteLessonItem,
              ),

              
            ),

            // actions
            Visibility(
              visible: widget.customLessonData.isCompleted,
              child: GestureDetector(
                child: Container(
                  width: 70,
                  child: Icon(Icons.task_alt, size: 30,),
                ),

                onTap: showDialogLessonDone,
              ),

              
            ),

            Visibility(
              visible: !widget.customLessonData.isCompleted,
              child: GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  width: 70,
                  child: Icon(Icons.more_vert, size: 30,),
                ),

                onTap: showDialogLessonUnDone,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: Colors.amber, width: 2),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 92, 92, 92).withOpacity(0.5), // Shadow color with opacity
              spreadRadius: 1, // Spread radius
              blurRadius: 2, // Blur radius
              offset: Offset(1, 3), // Offset of the shadow
            ),

          ],
        ),
      ),
    );
  }
}

class RouteCustomLessonData {
  final int lessonId;
  final int studyTime;
  final bool isCompleted;
  final DateTime routeCreatedAt;

  RouteCustomLessonData
  ({
      required this.lessonId,
      required this.studyTime,
      required this.isCompleted,
      required this.routeCreatedAt
  });
}

class RouteCourseLessonData {
  final int lessonId;
  final String title;
  final List contents;

  RouteCourseLessonData
  ({
      required this.lessonId,
      required this.title,
      required this.contents,
  });
}

