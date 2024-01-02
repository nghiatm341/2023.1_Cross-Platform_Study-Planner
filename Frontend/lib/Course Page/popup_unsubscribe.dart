import 'package:flutter/material.dart';
import 'package:frontend/Course%20Page/popup_subscribe_result.dart';
import 'package:frontend/Course%20Page/popup_unsubscribe_result.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PopupUnsubscribeCourse extends StatefulWidget {
  final int courseId;
  final VoidCallback onConfirmUnsubscribe;

  const PopupUnsubscribeCourse({super.key, required this.courseId, required this.onConfirmUnsubscribe});

  @override
  State<PopupUnsubscribeCourse> createState() => _PopupUnsubscribeCourse();
}

class _PopupUnsubscribeCourse extends State<PopupUnsubscribeCourse> {

  bool _isLoading = false;
  bool _doneConfirm = false;

  void cancelUnsubscribe(){
    Navigator.pop(context);
  }

  void showUnsubscribeCourseResult(bool isSucceed){
    showDialog(
        context: context, 
        builder: (context) {
        return PopupUnsubscribeResult(isUnsubscribedSucceed: isSucceed,);
      });
  }

  Future<void> _unsubscribeCourse() async {

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
        Uri.parse('${constaint.apiUrl}/course/unsubscribe'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      final deleteRouteResponse = await http.post(
        Uri.parse('${constaint.apiUrl}/studyRoute/deleteStudyRouteWhenUnsubscribe'),
        headers: headers,
        body: jsonEncode(postDataRoute),
      );

      if (response.statusCode == 200 && (deleteRouteResponse.statusCode == 200 || deleteRouteResponse.statusCode == 300)) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        widget.onConfirmUnsubscribe();
        Navigator.pop(context);
        showUnsubscribeCourseResult(true);

      } else {
        // Request failed with an error status code
        debugPrint('Failed with status code: ${response.statusCode}');
        Navigator.pop(context);
        showUnsubscribeCourseResult(false);
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      debugPrint('Error: $error');
      Navigator.pop(context);
      showUnsubscribeCourseResult(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Container(
        height: 200,
        child: Column(
          children: [
            Center(child: Text("Unsubscribe course", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(193, 223, 48, 36)))),


            Visibility(
              visible: !_doneConfirm,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                child: Text("Do you want to unsubscribe this course?"),
              ),
            ),

            Visibility(
              visible: !_doneConfirm,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text("Your study progress with this course will be deleted!"),
              ),
            ),

            Visibility(
              visible: !_doneConfirm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
            
                children: [
              
                ElevatedButton(onPressed: () => {
                  _unsubscribeCourse()
                }, child: Text("Yes"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
            
                ElevatedButton(onPressed: cancelUnsubscribe, child: Text("No"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
            
              ],),

            ),

            Visibility(child: CircularProgressIndicator(), visible: _isLoading,)
          ],
        ),
      ),
    );
  }
}