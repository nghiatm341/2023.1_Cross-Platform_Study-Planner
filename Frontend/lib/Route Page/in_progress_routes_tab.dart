import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class InProgressRoutesTab extends StatefulWidget {
  const InProgressRoutesTab({super.key});

  @override
  State<InProgressRoutesTab> createState() => _InProgressRoutesTabState();
}

class _InProgressRoutesTabState extends State<InProgressRoutesTab> {

  List<RouteItemData> inProgressRoute = [];

  void refetchCourses(){
    debugPrint("re fetch course");
    fetchCourses();
  }

  Future<void> fetchCourses() async {

    debugPrint("Fetch api list route");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? userId = prefs.getInt('userId');

    Map<String, String> headers = {
      'Content-Type': 'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'userId' : userId
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/studyRoute/getAllInProgressRoutes'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        List routeItems = jsonData['data'];

        setState(() {

            inProgressRoute = routeItems.map((e) {

              List allLessons = e['lessons'];
              final completeCount = allLessons.where((element) => element['isCompleted'] == true).length;

              String rawDate = e['createdAt'];

              String date = utils.getSubstringUntilCharacter(rawDate, 'T');

              String finishRawDate = e['finishedAt'];
              String finishDate = utils.getSubstringUntilCharacter(finishRawDate, 'T');

              return new RouteItemData(
                routeId: e['routeId'], 
                courseId: e['courseId'], 
                userId: e['userId'], 
                createdAt: date,
                finishedAt: finishDate,
                progress: (((completeCount / allLessons.length) * 100).ceil()).toString(),
                courseAvatar: constaint.sampleCourseAvatarUrl
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
  void initState(){
    super.initState();
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
          child: ListView.builder(itemBuilder: (context, index) {
            return RouteItem(routeData: inProgressRoute[index], reloadTab: refetchCourses,);
          }, itemCount: inProgressRoute.length),
        );
  }
}