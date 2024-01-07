import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/Route%20Page/route_detail.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/ultils/simpleNetworkImage.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteItem extends StatefulWidget {
  RouteItemData routeData;
  VoidCallback reloadTab;

  RouteItem({super.key, required this.routeData, required this.reloadTab});

  @override
  State<RouteItem> createState() => _RouteItem();
}

class _RouteItem extends State<RouteItem> {
  RouteItemUIData routeItemUIData = new RouteItemUIData();

  String courseDescription = "";

  bool _isDisposed = false;
  Completer<void> _completer = Completer<void>();

  void _reload(){
    debugPrint("_redisplay route item");
    widget.reloadTab();

    Future.delayed(Duration(milliseconds: 300), () {
      if(!_isDisposed){
         _displayProgress();
      }
    });
  }


  void _displayProgress(){
    debugPrint("_re display route progress " + widget.routeData.progress.toString());
    setState(() {
      routeItemUIData.progress = widget.routeData.progress;
    });
  }

  @override
  void dispose() {
    _isDisposed = true; // Set flag to true when the widget is disposed
    super.dispose();
  }

  Future<void> fetchCourses(RouteItemData routeData) async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'id': routeData.courseId};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/course/getById'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        final courseData = jsonData['data'];

        setState(() {
          courseDescription = courseData['description'];
          routeItemUIData.title = courseData['title'];
          routeItemUIData.startDate = routeData.createdAt;
          routeItemUIData.progress = routeData.progress;
          routeItemUIData.author = courseData['author_id']['firstName'] +  " " + courseData['author_id']['lastName'];
          routeItemUIData.courseAvatar = (courseData['avatar'] != null) ? courseData['avatar'] : "";
          routeItemUIData.hasAvatar = routeItemUIData.courseAvatar != "";
        });
      } else {
        // Request f
        //ailed with an error status code
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses(widget.routeData);
  }

  @override
  Widget build(BuildContext context) {

    bool hasAvatar = routeItemUIData.hasAvatar;

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
                    child: Container(
                      height: 60, 
                      child: 
                        hasAvatar ? SimpleNetworkImage(imageUrl: routeItemUIData.courseAvatar, boxFitType: BoxFit.cover) : Image(image: AssetImage("assets/course-default-icon.jpg"), fit: BoxFit.cover) 
                        )
                      ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            routeItemUIData.title,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Text("Author: " + routeItemUIData.author,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left),
                        Text(
                          "Start: " + routeItemUIData.startDate,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50, // Set the width of the container
                        height: 50, // Set the height of the container
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 255, 255,
                              255), // Set the background color of the circle
                        ),
                        child: Center(
                          child: Text(
                            routeItemUIData.progress +
                                "%", // Number to display inside the circle
                            style: TextStyle(
                              color: Colors.green, // Color of the number text
                              fontSize: 18, // Font size of the number text
                              fontWeight: FontWeight
                                  .bold, // Font weight of the number text
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 132, 230, 255),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black)),
          ),
        ),
      ),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RouteDetail(
                      description: courseDescription,
                      routeId: widget.routeData.routeId,
                      testCb: _reload,
                    )))
      },
    );
  }
}

class RouteItemData {
  final String routeId;
  final int courseId;
  final int userId;
  final String createdAt;
  final String finishedAt;
  final String progress;

  RouteItemData(
      {required this.routeId,
      required this.courseId,
      required this.userId,
      required this.createdAt,
      required this.progress, 
      required this.finishedAt,
  });
}

class RouteItemUIData {
  String title = "...";
  String author = "...";
  String startDate = "...";
  String progress = "...";
  String courseAvatar = "";
  bool hasAvatar = false;
}
