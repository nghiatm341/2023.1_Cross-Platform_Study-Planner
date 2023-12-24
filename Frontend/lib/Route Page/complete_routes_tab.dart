import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/Route%20Page/route_item_complete.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/utils.dart' as utils;

class CompleteRoutesTab extends StatefulWidget {
  
  const CompleteRoutesTab({super.key});

  @override
  State<CompleteRoutesTab> createState() => _CompleteRoutesTabState();
}

class _CompleteRoutesTabState extends State<CompleteRoutesTab> {

late List<RouteItemData> inProgressRoute = [];

  Future<void> fetchCourses() async {

 // Replace with your API endpoint
   

    Map<String, String> headers = {
      'Content-Type': 'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'userId' : AppStore.ID
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/studyRoute/getAllFinishedRoutes'),
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
                progress: (((completeCount / allLessons.length) * 100).ceil()).toString()
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
          return RouteItemComplete(routeData: inProgressRoute[index]);
        }, itemCount: inProgressRoute.length),
      );
  }
}