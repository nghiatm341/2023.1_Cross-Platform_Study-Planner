import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/course_item.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class BrowseCoursesTab extends StatefulWidget {
  const BrowseCoursesTab({super.key});

  @override
  State<BrowseCoursesTab> createState() => _BrowseCoursesTabState();
}

class _BrowseCoursesTabState extends State<BrowseCoursesTab> {
  String _searchText = "";

  TextEditingController _textEditingController = TextEditingController();

  void clearFilter() {
    _searchText = "";
    _textEditingController.clear();
    setState(() {
      courseList = [];
    });

  }

  void findCourse() {
    if(_searchText != ""){
      debugPrint("find courses with title: " + _searchText);
      fetchCourses();
    }
  }

  void updateSearchText(String value) {
    _searchText = value;
    debugPrint("update search text: " + value);
  }

  void closeKeyboard(BuildContext context) {
    // FocusScopeNode's static method to unfocus the current focused input
    FocusScope.of(context).unfocus();
  }

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

    Map<String, dynamic> postData = {'title': _searchText, 'is_drafting': 0};

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? userId = prefs.getInt('userId');

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

            var meSubscriber = subscribers.where((element) => element['user_id'] == userId).length > 0;

            return new CourseItemData(
              courseId: c['id'],
              authorName: c['author_id']['firstName'] + " " + c['author_id']['lastName'],
              createdAt: date,
              title: c['title'],
              isSubscribed: meSubscriber,
              subscribersCount: subscribers.length,
              description: c['description'],
              lessons: c['lessons'],
              isDrafting: c['is_drafting']
            );
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
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Text(
              "Search course:",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(4),
                ),
                width: 300,
                padding: EdgeInsets.all(8),
                child: Container(
                  width: 240,
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter some keywords...', // Placeholder text
                      border:
                          OutlineInputBorder(), // Optional border appearance
                    ),
                    onChanged: (value) => {updateSearchText(value)},
                  ),
                ),
              ),
              Container(
                child: Column(children: [
                  ElevatedButton(
                      onPressed: () => {closeKeyboard(context), clearFilter()},
                      child: Text("Clear")),
                  ElevatedButton(
                      onPressed: () => {closeKeyboard(context), findCourse()},
                      child: Text("Search")),
                ]),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
            child: Container(
              height: 1,
              color: Colors.black,
            ),
          ),

          Expanded(
            child: Container(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return CourseItem(courseData: courseList[index]);
                },
                itemCount: courseList.length),
          ))
        ],
      ),
    );
  }
}
