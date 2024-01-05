import 'package:flutter/material.dart';
import 'package:frontend/ultils/store.dart';
import 'package:intl/intl.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DialogRouteLessonUnDone extends StatefulWidget {
  final DateTime routeCreatedTime;
  final int studyTime;
  final String routeId;
  final int lessonId;
  final VoidCallback onChangeStudyTime;

  const DialogRouteLessonUnDone(
      {super.key, required this.routeCreatedTime, required this.studyTime, required this.lessonId, required this.routeId, required this.onChangeStudyTime});

  @override
  State<DialogRouteLessonUnDone> createState() =>
      _DialogRouteLessonUnDoneState();
}

class _DialogRouteLessonUnDoneState extends State<DialogRouteLessonUnDone> {

  late int _currentStudyTime = widget.studyTime;

  late bool _hasChange = false;

  void _decreaseStudyTime(){
    if(_currentStudyTime > 1){
      setState(() {
        _currentStudyTime -= 1;

        if(!_hasChange) _hasChange = true;
      });
    }
  }

  void _increaseStudyTime(){
      setState(() {
        _currentStudyTime += 1;

        if(!_hasChange) _hasChange = true;
      });
  }

  void _confirmChange(){
    _updateStudyTime();
    
  }

  Future<void> _updateStudyTime() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? userId = prefs.getInt('userId');

    Map<String, String> headers = {
      'Content-Type':
          'application/json',
      'Authorization': "Bearer ${token}"// Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'routeId': widget.routeId, 'lessonId': widget.lessonId, 'newStudyTime': _currentStudyTime};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/studyRoute/changeLessonStudyTime'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);

        widget.onChangeStudyTime();
        Navigator.pop(context);

      } else {
        // Request failed with an error status code
        debugPrint('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      debugPrint('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 168, 220, 255),
      content: Container(
        height: 178,
        child: Column(
          children: [
            Text("Due date: " +
                DateFormat('yyyy-MM-dd').format(widget.routeCreatedTime
                    .add(Duration(days: _currentStudyTime)))),

            Container(
              padding: EdgeInsets.only(top: 12),
              child: Text("Study time (days):"),
            ),

            Container(
              padding: EdgeInsets.only(top: 12),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  SizedBox(
                    width: 40,
                    child: ElevatedButton(
                      onPressed: _decreaseStudyTime,
                      child: Icon(Icons.remove, size: 10,),
                      style: TextButton.styleFrom(
                        // Text color of the button
                        backgroundColor:
                            Colors.white, // Background color of the button
                      ),
                    ),
                  ),

                  Container(
                    child: Text(_currentStudyTime.toString()),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white
                    ),
                  ),

                  SizedBox(
                    width: 40,
                    child: ElevatedButton(
                      onPressed: _increaseStudyTime,
                      child: Icon(Icons.add, size: 10,),
                      style: TextButton.styleFrom(
                        // Text color of the button
                        backgroundColor:
                            Colors.white, // Background color of the button
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
            visible: _hasChange,
            child: Padding(
              padding:  EdgeInsets.only(top: 16),
              child: ElevatedButton(onPressed: (){
                _confirmChange();
              }, child: Text("Confirm")),
            ),
          )
          ],
        ),
      ),
    );
  }

  
}
