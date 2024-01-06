import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/popup_subscribe_result.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PopupSubscribeCourse extends StatefulWidget {
  final int courseId;
  final VoidCallback onConfirmSubscribe;

  const PopupSubscribeCourse({super.key, required this.courseId, required this.onConfirmSubscribe});

  @override
  State<PopupSubscribeCourse> createState() => _PopupSubscribeCourse();
}

class _PopupSubscribeCourse extends State<PopupSubscribeCourse> {

  bool _isLoading = false;
  bool _doneConfirm = false;

  void cancelSubscribe(){
    Navigator.pop(context);
  }

  void showSubscribeCourseResult(bool isSucceed){
    showDialog(
        context: context, 
        builder: (context) {
        return PopupSubscribeResult(isSubscribedSucceed: isSucceed,);
      });
  }

  Future<void> _subscribeCourse() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? userId = prefs.getInt('userId');

    setState(() {
      _isLoading = true;
      _doneConfirm = true;
    });

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = 
    {
      'id': widget.courseId, 
      'user_id': userId,
    };

    Map<String, dynamic> postDataRoute = 
    {
      'courseId': widget.courseId, 
      'userId': userId,
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/course/subscribe'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      final createRouteResponse = await http.post(
        Uri.parse('${constaint.apiUrl}/studyRoute/createStudyRoute'),
        headers: headers,
        body: jsonEncode(postDataRoute),
      );

      if (response.statusCode == 200 && createRouteResponse.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        widget.onConfirmSubscribe();
        Navigator.pop(context);
        showSubscribeCourseResult(true);

      } else {
        // Request failed with an error status code
        debugPrint('Failed with status code: ${response.statusCode}');
        Navigator.pop(context);
        showSubscribeCourseResult(false);
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      debugPrint('Error: $error');
      Navigator.pop(context);
      showSubscribeCourseResult(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Container(
        height: 140,

        child: Column(
          children: [
            Center(child: Text("Subscribe course", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber))),


            Visibility(
              visible: !_doneConfirm,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                child: Text("Do you want to subscribe this course? "),
              ),
            ),

            Visibility(
              visible: !_doneConfirm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
            
                children: [
              
                ElevatedButton(onPressed: () => {
                  _subscribeCourse()
                }, child: Text("Yes"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
            
                ElevatedButton(onPressed: cancelSubscribe, child: Text("No"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
            
              ],),

            ),

            Visibility(child: CircularProgressIndicator(), visible: _isLoading,)
          ],
        ),
      ),
    );
  }
}