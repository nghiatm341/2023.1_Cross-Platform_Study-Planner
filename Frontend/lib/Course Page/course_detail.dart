import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/course_item.dart';
import 'package:frontend/Course%20Page/course_lesson_item.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/Route%20Page/route_lesson_item.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/utils.dart' as utils;

class CourseDetail extends StatefulWidget {

  final CourseItemData courseData;

  const CourseDetail(
      {super.key, required this.courseData});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint("lessons count: " + widget.courseData.lessons.length.toString());
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Course detail",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg1.jpg"), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
         
          Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("Course: " +  widget.courseData.title, style: TextStyle(fontSize: 18),),


              Container(
                padding: EdgeInsets.only(top: 12),
                child: Text("Author: " +  widget.courseData.authorName)
              ),

              
            ]),

            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(8)
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 8),
          ),

          //description
          Container(
            padding: EdgeInsets.all(8),

            //width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8)),
                child: Text("Description: " +  widget.courseData.description,
                style: TextStyle(fontSize: 14),
            ),
          ),

          //progress
          Container(
            padding: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
          ),

          //list lesson
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return CourseLessonItem(lessonIndex: index, 
                  lessonData: new CourseLessonData(
                    lessonId: widget.courseData.lessons[index]['lesson']['id'], 
                    title: widget.courseData.lessons[index]['lesson']['title'], 
                    contents: widget.courseData.lessons[index]['lesson']['contents']));
                },
                itemCount: widget.courseData.lessons.length),
          )
        ]),
      ),
    );
  }
}
