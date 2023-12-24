import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/Route%20Page/lesson_note_page.dart';
import 'package:frontend/ultils/store.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteTile extends StatelessWidget {
  final NoteData noteData;
  Function(BuildContext)? deleteFunction;

  NoteTile({super.key, required this.noteData, required this.deleteFunction,});

  Future<void> _addNoteToDb(String content) async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json',
      //'Authorization': "Bearer ${AppStore.TOKEN}"// Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'routeId': noteData.noteId, 
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/lessonNote/deleteLessonNote'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        debugPrint("Delete note succeed");

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
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, top: 0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(8),
            )
          ],
        ),
        child: Container(
          width: 800,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            noteData.content,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
