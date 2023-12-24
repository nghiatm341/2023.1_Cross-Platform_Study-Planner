import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/lesson_note_page.dart';
import 'package:frontend/Route%20Page/popup_congrat.dart';
import 'package:frontend/Route%20Page/popup_notification.dart';
import 'package:frontend/Route%20Page/route_lesson_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/utils.dart' as utils;

class RouteLessonDetail extends StatefulWidget {
  final RouteCourseLessonData courseLessonData;
  final int lessonIndex;
  final String routeId;
  final bool isCompleted;
  final VoidCallback onCompleteLesson;

  const RouteLessonDetail(
      {super.key,
      required this.courseLessonData,
      required this.lessonIndex,
      required this.isCompleted,
      required this.onCompleteLesson,
      required this.routeId});

  @override
  State<RouteLessonDetail> createState() => _RouteLessonDetailState();
}

class _RouteLessonDetailState extends State<RouteLessonDetail> {

  void _showWarning() {
    showDialog(
        context: context,
        builder: (context) {
          return PopupNotification(
            message: "You must complete previous lesson",
          );
        });
  }

  void _showCongrat(){
    showDialog(
        context: context,
        builder: (context) {
          return PopupCongrat();
        });
  }

  void showLessonNote(){
    showDialog(context: context, builder: (context){ 
      return LessonNotePage(routeId: widget.routeId, lessonId: widget.courseLessonData.lessonId,);
    });
  }

  Future<void> callCompleteLesson() async {
    // Replace with your API endpoint
    debugPrint("Call API complete lesson");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'lessonId': widget.courseLessonData.lessonId,
      'routeId': widget.routeId
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/studyRoute/completeLesson'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        widget.onCompleteLesson();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        if(jsonData['data']['isCompleteCourse']){
          debugPrint("complete course");
          _showCongrat();
        }

      } else if (response.statusCode == 300) {
        debugPrint("Need to complete previous lesson");
        _showWarning();
      } else {
        // Request failed with an error status code
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lesson " + (widget.lessonIndex + 1).toString()),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showLessonNote,
        child: Icon(Icons.add), // Add your icon here
        backgroundColor: Colors.amber, // Change FAB background color
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),

        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  widget.courseLessonData.title,
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
                        child: Text(
                          widget.courseLessonData.contents[index]['contents'],
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    },
                    itemCount: widget.courseLessonData.contents.length,
                  ),
                ),
              ),
              Visibility(
                visible: !widget.isCompleted,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        callCompleteLesson();
                      },
                      child: Text("Complete")),
                ),
              )
            ]),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/bg5.png"), fit: BoxFit.cover),
        // ),
      ),
    );
  }
}
