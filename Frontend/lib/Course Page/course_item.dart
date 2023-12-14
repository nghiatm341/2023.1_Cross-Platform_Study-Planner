import 'package:flutter/material.dart';
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
  CourseItemUIData courseItemUIData = new CourseItemUIData();

  String courseDescription = "";

  Future<void> fetchCourses(CourseItemData routeData) async {
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
          courseItemUIData.title = courseData['title'];
          courseItemUIData.author = "1";
          courseItemUIData.startDate = routeData.createdAt;
          courseItemUIData.progress = routeData.progress;
        });
      } else {
        // Request failed with an error status code
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }

  Future<void> fetchAuthor(CourseItemData routeData) async {
    
  }

  @override
  void initState() {
    super.initState();
    fetchCourses(widget.courseData);
    fetchAuthor(widget.courseData);
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
                    flex: 3,
                    child: Icon(
                      Icons.book,
                      size: 60,
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
                          courseItemUIData.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text("Author: " + courseItemUIData.author,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                      Text(
                        "Start: " + courseItemUIData.startDate,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
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
                            courseItemUIData.progress +
                                "%", // Number to display inside the circle
                            style: TextStyle(
                              color: Colors.green, // Color of the number text
                              fontSize: 20, // Font size of the number text
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
            context, MaterialPageRoute(builder: (context) => RouteDetail(description: courseDescription, routeId: widget.courseData.routeId)))
      },
    );
  }
}

class CourseItemData {
  final String routeId;
  final int courseId;
  final int userId;
  final String createdAt;
  final String progress;

  CourseItemData(
      {required this.routeId,
      required this.courseId,
      required this.userId,
      required this.createdAt,
      required this.progress});
}

class CourseItemUIData {
  String title = "1";
  String author = "1";
  String startDate = "1";
  String progress = "1";
}
