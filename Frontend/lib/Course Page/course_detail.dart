import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/course_item.dart';
import 'package:frontend/Course%20Page/course_lesson_item.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/Route%20Page/route_lesson_item.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/utils.dart' as utils;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CourseDetail extends StatefulWidget {
  final CourseItemData courseData;

  const CourseDetail({super.key, required this.courseData});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showPublishDraftConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to ${widget.courseData.isDrafting.toInt() == 1 ? 'publish' : 'draft'} this course?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                // Perform the action when the user confirms
                // ...
                try {
                  EasyLoading.show();
                  Map<String, String> headers = {
                    'Content-Type':
                        'application/json', // Set the content type for POST request
                    // Add other headers if needed
                  };

                  Map<String, dynamic> postData = {
                    'id': widget.courseData.courseId,
                    'is_drafting':
                        widget.courseData.isDrafting.toInt() == 1 ? 0 : 1
                  };

                  final response = await http.post(
                    Uri.parse('${constaint.apiUrl}/course/update'),
                    headers: headers,
                    body: jsonEncode(postData), // Encode the POST data to JSON
                  );
                  print(json.decode(response.body));
                  EasyLoading.dismiss();
                } catch (error) {
                  // Catch and handle any errors that occur during the API call
                  print('Error: $error');
                  EasyLoading.dismiss();
                }
                // Close the dialog
                Navigator.of(context).pop();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this course?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                // Perform the action when the user confirms
                // ...
                try {
                  EasyLoading.show();
                  Map<String, String> headers = {
                    'Content-Type':
                        'application/json', // Set the content type for POST request
                    // Add other headers if needed
                  };

                  Map<String, dynamic> postData = {
                    'id': widget.courseData.courseId
                  };

                  final response = await http.post(
                    Uri.parse('${constaint.apiUrl}/course/delete'),
                    headers: headers,
                    body: jsonEncode(postData), // Encode the POST data to JSON
                  );
                  print(json.decode(response.body));
                  EasyLoading.dismiss();
                } catch (error) {
                  // Catch and handle any errors that occur during the API call
                  print('Error: $error');
                  EasyLoading.dismiss();
                }
                // Close the dialog
                Navigator.of(context).pop();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  SpeedDial _buildFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      visible: AppStore.ROLE == "teacher",
      children: [
        SpeedDialChild(
          child: Icon(Icons.delete),
          visible: widget.courseData.isDrafting.toInt() == 1,
          backgroundColor: Colors.red,
          onTap: () {
            _showDeleteConfirmationDialog(context);
          },
          label: 'Delete',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        SpeedDialChild(
          child: Icon(Icons.edit),
          visible: widget.courseData.isDrafting.toInt() == 1,
          backgroundColor: Colors.blue[400],
          onTap: () {
            // Add functionality for the second button
            print('Edit');
          },
          label: 'Edit',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        SpeedDialChild(
          child: Icon(widget.courseData.isDrafting.toInt() == 1
              ? Icons.public_sharp
              : Icons.public_off_sharp),
          backgroundColor: Colors.amber,
          onTap: () async {
            _showPublishDraftConfirmationDialog(context);
          },
          label:
              widget.courseData.isDrafting.toInt() == 1 ? 'Publish' : 'Draft',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
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
      floatingActionButton: _buildFAB(),
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
                  Text(
                    "Course: " + widget.courseData.title,
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 12),
                      child: Text("Author: " + widget.courseData.authorName)),
                ]),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8)),
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
            child: Text(
              "Description: " + widget.courseData.description,
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
                  return CourseLessonItem(
                      lessonIndex: index,
                      lessonData: new CourseLessonData(
                          lessonId: widget.courseData.lessons[index]['lesson']
                              ['id'],
                          title: widget.courseData.lessons[index]['lesson']
                              ['title'],
                          contents: widget.courseData.lessons[index]['lesson']
                              ['contents']));
                },
                itemCount: widget.courseData.lessons.length),
          )
        ]),
      ),
    );
  }
}
