import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/Route%20Page/route_lesson_item.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/utils.dart' as utils;

class CourseDetail extends StatefulWidget {
  final CourseDetail courseDetailData;

  const CourseDetail(
      {super.key, required this.courseDetailData});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  late List customLessonsData = [];
  late List courseLessonData = [];
  late int completeLessonsCount = 0;
  late int totalLessonCount = 1;
  late String routeCreatedTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Route Detail",
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
          //description
          Container(
            padding: EdgeInsets.all(8),

            //width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              "Description",
              style: TextStyle(fontSize: 16),
            ),
          ),

          //progress
          Container(
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Complete " +
                      completeLessonsCount.toString() +
                      "/" +
                      totalLessonCount.toString() +
                      " lessons",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Center(
                    child: Text(
                      ((completeLessonsCount / totalLessonCount) * 100).ceil().toString() + "%",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
          ),

          //list lesson
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                 
                },
                itemCount: customLessonsData.length),
          )
        ]),
      ),
    );
  }
}
