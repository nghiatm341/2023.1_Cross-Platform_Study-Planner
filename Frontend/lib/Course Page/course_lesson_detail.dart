import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/course_lesson_item.dart';
import 'package:frontend/Route%20Page/route_lesson_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/utils.dart' as utils;

class CourseLessonDetail extends StatefulWidget {

  final int lessonIndex;
  final CourseLessonData lessonData;

  const CourseLessonDetail(
      {super.key, required this.lessonIndex, required this.lessonData});

  @override
  State<CourseLessonDetail> createState() => _CourseLessonDetailState();
}

class _CourseLessonDetailState extends State<CourseLessonDetail> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lesson " + (widget.lessonIndex + 1).toString()),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          mainAxisAlignment: MainAxisAlignment.start,

          children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              widget.lessonData.title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )),
          ),

          Container(

            child: Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child:
                          Text(widget.lessonData.contents[index]['contents'], style: TextStyle(fontSize: 16),),
                    );
                  },
                  itemCount: widget.lessonData.contents.length,
                ),
              ),
          ),
          
        ]),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/bg5.png"), fit: BoxFit.cover),
        // ),
      ),
    );
  }
}


