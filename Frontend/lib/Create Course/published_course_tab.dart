import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/course_item.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/utils.dart' as utils;

class PublishedCourses extends StatefulWidget {
  const PublishedCourses({super.key});

  @override
  State<PublishedCourses> createState() => _PublishedCoursesState();
}

class _PublishedCoursesState extends State<PublishedCourses> {
  late List<CourseItemData> courseList = [];
  late List courseLessonList;

  Future<void> fetchCourses() async {
    // Replace with your API endpoint
    debugPrint("Fetch api list course");

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'author_id': AppStore.ID,
      'is_drafting': 0
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/course/list'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        List courses = jsonData['data'];

        debugPrint("course count: " + courses.length.toString());

        setState(() {
          courseList = courses.map((c) {
            String rawDate = c['create_at'];

            String date = utils.getSubstringUntilCharacter(rawDate, 'T');
            List subscribers = c['list_subscriber'];

            debugPrint("subscribers count: " + subscribers.length.toString());

            var meSubscriber = subscribers
                    .where((element) => element['user_id'] == AppStore.ID)
                    .length >
                0;

            return new CourseItemData(
                courseId: c['id'],
                authorName: c['author_id']['firstName'] +
                    " " +
                    c['author_id']['lastName'],
                createdAt: date,
                title: c['title'],
                isSubscribed: meSubscriber,
                subscribersCount: subscribers.length,
                description: c['description'],
                lessons: c['lessons'],
                isDrafting: c['is_drafting']);
          }).toList();
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

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: RefreshIndicator(
      onRefresh: fetchCourses,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return CourseItem(courseData: courseList[index]);
          },
          itemCount: courseList.length),
    ));
  }
}
