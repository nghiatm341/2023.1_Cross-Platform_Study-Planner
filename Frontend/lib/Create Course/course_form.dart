import 'package:flutter/material.dart';
import 'package:frontend/ultils/store.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: NewCourseScreen(),
//     );
//   }
// }

class NewCourseScreen extends StatefulWidget {
  @override
  _NewCourseScreenState createState() => _NewCourseScreenState();
}

class _NewCourseScreenState extends State<NewCourseScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Lesson> lessons = [];

  void _addLesson() {
    setState(() {
      lessons.add(Lesson(
        title: '',
        chapterTitle: '',
        estimateTime: 0, // Default estimate time
        contents: [],
      ));
    });
  }

  void _deleteLesson(int index) {
    setState(() {
      lessons.removeAt(index);
    });
  }

  void _addContent(int lessonIndex) {
    setState(() {
      lessons[lessonIndex].contents.add(Content(type: 1, content: ''));
    });
  }

  void _deleteContent(int lessonIndex, int contentIndex) {
    setState(() {
      lessons[lessonIndex].contents.removeAt(contentIndex);
    });
  }

  void _saveCourse() async {
    debugPrint("Fetch add course");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? userId = prefs.getInt('userId');

    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    // Perform API call here using the data from the controllers and lessons
    Map<String, dynamic> courseData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
      'author_id': userId
    };

    // Example API call:
    // ApiService.createCourse(courseData);

    // You might want to handle the API response or errors here

    print(courseData);

    try {
      EasyLoading.show();
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/course/createWithNewLessons'),
        headers: headers,
        body: jsonEncode(courseData), // Encode the POST data to JSON
      );
      // if (response.statusCode == 200) {
      //   print(response);
      //   EasyLoading.dismiss();
      // } else {
      //   print(response);
      //   EasyLoading.dismiss();
      // }
      print(json.decode(response.body));
      EasyLoading.dismiss();
      Navigator.pop(context);
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Course'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 16),
              for (int i = 0; i < lessons.length; i++)
                LessonWidget(
                  lesson: lessons[i],
                  onAddContent: () => _addContent(i),
                  onDelete: () => _deleteLesson(i),
                  onDeleteContent: (int contentIndex) =>
                      _deleteContent(i, contentIndex),
                  onEstimateTimeChanged: (double newValue) {
                    setState(() {
                      lessons[i].estimateTime = newValue;
                    });
                  },
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addLesson,
                child: Text('Add Lesson'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveCourse,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Lesson {
  String title;
  String chapterTitle;
  double estimateTime;
  List<Content> contents;

  Lesson(
      {required this.title,
      required this.chapterTitle,
      required this.estimateTime,
      required this.contents});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'chapter_title': chapterTitle,
      'estimate_time': estimateTime,
      'contents': contents.map((content) => content.toJson()).toList(),
    };
  }
}

class Content {
  int type;
  String content;

  Content({required this.type, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'content_type': type,
      'contents': content,
    };
  }
}

class LessonWidget extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onAddContent;
  final VoidCallback onDelete;
  final Function(int) onDeleteContent;
  final ValueChanged<double> onEstimateTimeChanged;

  LessonWidget({
    required this.lesson,
    required this.onAddContent,
    required this.onDelete,
    required this.onDeleteContent,
    required this.onEstimateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) => lesson.title = value,
              decoration: InputDecoration(labelText: 'Lesson Title'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => lesson.chapterTitle = value,
              decoration: InputDecoration(labelText: 'Chapter Title'),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Text('Estimate Time: ${lesson.estimateTime} hours'),
                DecimalNumberPicker(
                  value: lesson.estimateTime.toDouble(),
                  minValue: 0,
                  maxValue: 24,
                  // step: 1,
                  decimalPlaces: 1,
                  itemHeight: 40,
                  axis: Axis.horizontal,
                  onChanged: (value) => onEstimateTimeChanged(value.toDouble()),
                ),
              ],
            ),
            SizedBox(height: 16),
            for (int i = 0; i < lesson.contents.length; i++)
              ContentWidget(
                content: lesson.contents[i],
                onDelete: () => onDeleteContent(i),
              ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onAddContent,
              child: Text('Add Content'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text('Delete Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  final Content content;
  final VoidCallback onDelete;

  ContentWidget({required this.content, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) => content.content = value,
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Content Text'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text('Delete Content'),
            ),
          ],
        ),
      ),
    );
  }
}
