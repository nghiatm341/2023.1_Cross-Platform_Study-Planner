import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/note_tile.dart';
import 'package:frontend/ultils/store.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';

class LessonNotePage extends StatefulWidget {

  final int lessonId;
  final String routeId;

  const LessonNotePage({super.key, required this.routeId, required this.lessonId});

  @override
  State<LessonNotePage> createState() => _LessonNotePageState();
}

class _LessonNotePageState extends State<LessonNotePage> {
  List<NoteData> notesList = [];

  Future<void> _fetchNotes() async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json',
      //'Authorization': "Bearer ${AppStore.TOKEN}"// Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'routeId': widget.routeId, 
      'lessonId': widget.lessonId, 
      };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/lessonNote/getAllLessonNotes'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);

        List noteListData = jsonData['data'];

        setState(() {

            notesList = noteListData.map((e) {

              return new NoteData(noteId: e['noteId'], content: e['content']);

            }).toList();
        });

      } else {
        // Request failed with an error status code
        debugPrint('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      debugPrint('Error: $error');
    }
  }

  Future<void> _addNoteToDb(String content) async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json',
      //'Authorization': "Bearer ${AppStore.TOKEN}"// Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'routeId': widget.routeId, 
      'lessonId': widget.lessonId, 
      'noteContent' : content
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/lessonNote/createLessonNote'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        String newNoteId = jsonData['data']['noteId'];

        setState(() {
            notesList.add(new NoteData(noteId: newNoteId, content: _controller.text));
            _controller.clear();
      });

      } else {
        // Request failed with an error status code
        debugPrint('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      debugPrint('Error: $error');
    }
  }

  Future<void> _deleteNoteFromDb(String noteId) async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json',
      //'Authorization': "Bearer ${AppStore.TOKEN}"// Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {
      'noteId': noteId, 
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

  void close() {
    Navigator.of(context).pop();
  }

  final _controller = TextEditingController();

  void addNewNote() {

    if(_controller.text != ""){

      _addNoteToDb(_controller.text);
    }
  }

  void deleteNote(int index) {
    String noteId = notesList[index].noteId;

    debugPrint("noteId: " + noteId);

    if(noteId != ""){
      _deleteNoteFromDb(noteId);
    }

    setState(() {
      notesList.removeAt(index);
    });
  }

  @override
  void initState(){
    super.initState();
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 12),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Container(
        width: 600,
        height: 320,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(bottom: 12, top: 8),
                child: Center(
                  child: Text(
                    "Notes ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: NoteTile(noteData: notesList[index], deleteFunction: (context) => deleteNote(index),),
                  );
                },
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  width: 600,
                  padding: EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 200,
                        child: Container(
                          width: 200,
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter a note...', // Placeholder text
                              border:
                                  OutlineInputBorder(), // Optional border appearance
                            ),
                            onChanged: (value) => {},
                          ),
                        ),
                      ),
                      Container(
                        child: Column(children: [
                          ElevatedButton(
                              onPressed: addNewNote, child: Text("Add")),
                        ]),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class NoteData {
  final String noteId;
  final String content;

  NoteData({
    required this.noteId,
    required this.content,
  });
}
