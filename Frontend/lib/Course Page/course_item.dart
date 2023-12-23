import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/course_detail.dart';
import 'package:frontend/Course%20Page/popup_subscribe.dart';
import 'package:frontend/Course%20Page/popup_subscribe_result.dart';
import 'package:frontend/Route%20Page/route_detail.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseItem extends StatefulWidget {
  CourseItemData courseData;

  CourseItem({
    super.key,
    required this.courseData,
  });

  @override
  State<CourseItem> createState() => _RouteItem();
}

class _RouteItem extends State<CourseItem> {
  
  String courseDescription = "";

  @override
  void initState() {
    super.initState();
  }

  void subscribeCourse(){
    showDialog(
        context: context, 
        builder: (context) {
        return PopupSubscribeCourse(courseId: widget.courseData.courseId, onConfirmSubscribe: changeSubscribeState);
        //return PopupSubscribeResult(isSubscribedSucceed: true,);
      });
  }

  void changeSubscribeState(){
    setState(() {
      widget.courseData.isSubscribed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Container(
            height: 120,
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Icon(
                      Icons.book,
                      size: 50,
                    )),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.courseData.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text("Author: " + widget.courseData.authorName,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                      Text(
                        "Created at: " + widget.courseData.createdAt,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                    //subscribe state

                     Visibility(
                      visible: widget.courseData.isSubscribed,
                       child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: Text("Subscribed", style: TextStyle(fontSize: 12),)
                            ),
                     
                            Icon(Icons.app_registration)
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(4)
                        ),
                       ),
                     ),

                     GestureDetector(
                       child: Visibility(
                        visible: !widget.courseData.isSubscribed,
                         child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: Text("Subscribe", style: TextStyle(fontSize: 12),)
                              ),
                       
                              Icon(Icons.subscriptions)
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(4)
                          ),
                         ),
                       ),

                       onTap: () => {
                        subscribeCourse()
                       },
                     ),

                      Container(
                            width: 70, // Set the width of the container
                            height: 50, // Set the height of the container
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              shape: BoxShape.rectangle,
                              color: const Color.fromARGB(255, 255, 255,
                                  255), // Set the background color of the circle
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: Text(
                                        widget.courseData.subscribersCount.toString(), // Number to display inside the circle
                                    style: TextStyle(
                                      color: Colors.black, // Color of the number text
                                      fontSize: 20, // Font size of the number text
                                      fontWeight: FontWeight
                                          .bold, // Font weight of the number text
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Text(
                                        "subcribers", // Number to display inside the circle
                                    style: TextStyle(
                                      color: Colors.black, // Color of the number text
                                      fontSize: 12, // Font size of the number text
                                      fontWeight: FontWeight
                                          .bold, // Font weight of the number text
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 253, 201, 87),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black)),
          ),
        ),
      ),
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CourseDetail(courseData: widget.courseData)))
      },
    );
  }
}

class CourseItemData {
  final int courseId;
  final String authorName;
  final String title;
  final String createdAt;
  bool isSubscribed;
  final int subscribersCount;
  final String description;
  final List lessons;

  CourseItemData(
    {
      required this.title,
      required this.courseId,
      required this.authorName,
      required this.createdAt,
      required this.isSubscribed,
      required this.subscribersCount,
      required this.description,
      required this.lessons
    });
}
