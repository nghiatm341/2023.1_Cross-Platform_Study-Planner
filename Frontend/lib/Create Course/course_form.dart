import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/ultils/simpleNetworkImage.dart';
import 'package:frontend/ultils/store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

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

  String courseAvatarUrl = "";
  bool courseAvatarUploaded = false;
  bool courseAvatarUploading = false;
  final storage = FirebaseStorage.instance.ref();

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
      'lessons': lessons
          .where((lesson) => _isValidLesson(lesson))
          .map((lesson) => lesson.toJson())
          .toList(),
      'author_id': userId,
      'avatar': courseAvatarUrl,
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

  void _addImageContent(int lessonIndex) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    debugPrint('Image: ${image.path}');

    try {
      //image folder in cloud
      Reference cloudAvatarDirectory = storage.child("Avatar");

      // generate image file name
      String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

      //get file image extension (pne or jpg)
      String fileExtension = image!.path.split('.').last.toLowerCase();

      // image need uploaded reference
      Reference imageToUpload =
          cloudAvatarDirectory.child('$uniqueImageName.$fileExtension');

      UploadTask uploadTask = imageToUpload.putFile(File(image!.path));

      final snapshot = await uploadTask!.whenComplete(() {});

      String url = "";
      //use to store in database
      url = await snapshot.ref.getDownloadURL();

      if (url != "") {
        setState(() {
          lessons[lessonIndex].contents.add(Content(type: 2, content: url));
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void clearAvatar() {
    setState(() {
      courseAvatarUploaded = false;
      courseAvatarUrl = "";
    });
  }

  void uploadAvatar() async {
    final picker = ImagePicker();

    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    debugPrint('Image: ${image.path}');

    setState(() {
      courseAvatarUploading = true;
    });

    try {
//image folder in cloud
      Reference cloudAvatarDirectory = storage.child("Avatar");

      // generate image file name
      String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

      //get file image extension (pne or jpg)
      String fileExtension = image!.path.split('.').last.toLowerCase();

      // image need uploaded reference
      Reference imageToUpload =
          cloudAvatarDirectory.child('$uniqueImageName.$fileExtension');

      UploadTask uploadTask = imageToUpload.putFile(File(image!.path));

      final snapshot = await uploadTask!.whenComplete(() {
        setState(() {
          courseAvatarUploading = false;
        });
      });
      //use to store in database
      String url = await snapshot.ref.getDownloadURL();

      setState(() {
        courseAvatarUrl = url;
        courseAvatarUploaded = true;
      });
    } catch (e) {
      // debugPrint(e.toString());
      setState(() {
        courseAvatarUploading = false;
      });
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Are you sure you want to save course?'),
              SizedBox(height: 10),
              Text(
                'Invalid lessons and contents will be removed',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call function A when user confirms
                _saveCourse();
                Navigator.of(context).pop();
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
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
              Visibility(
                  visible: !courseAvatarUploaded,
                  child: ElevatedButton(
                    onPressed: uploadAvatar,
                    child: Text("Upload Avatar"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black),
                  )),
              Visibility(
                  visible: courseAvatarUploading,
                  child: LinearProgressIndicator(
                    value: null,
                    color: Colors.amber,
                  )),
              Visibility(
                  visible: courseAvatarUploaded,
                  child: Column(
                    children: [
                      SimpleNetworkImage(imageUrl: courseAvatarUrl, boxFitType: BoxFit.contain),
                      ElevatedButton(
                        onPressed: clearAvatar,
                        child: Text("Clear"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black),
                      )
                    ],
                  )),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    // labelText: 'Title',
                    label: Row(
                  children: [
                    Text('Title'),
                    Padding(padding: EdgeInsets.all(3.0)),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                )),
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
                  onAddImageContent: () => _addImageContent(i),
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
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_isValidLessons(lessons)) {
                    _saveCourse();
                  } else {
                    _showConfirmationDialog(context);
                  }
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black),
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
      'contents': contents
          .where((content) => _isValidContent(content))
          .map((content) => content.toJson())
          .toList(),
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
  final VoidCallback onAddImageContent;
  final Function(int) onDeleteContent;
  final ValueChanged<double> onEstimateTimeChanged;

  LessonWidget({
    required this.lesson,
    required this.onAddContent,
    required this.onDelete,
    required this.onDeleteContent,
    required this.onEstimateTimeChanged,
    required this.onAddImageContent,
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
              decoration: InputDecoration(
                  // labelText: 'Lesson Title'
                  label: Row(
                children: [
                  Text('Lesson Title'),
                  Padding(padding: EdgeInsets.all(3.0)),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              )),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => lesson.chapterTitle = value,
              decoration: InputDecoration(labelText: 'Chapter Title'),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: [
                    Text('Estimate Time: ${lesson.estimateTime} hours'),
                    Padding(padding: EdgeInsets.all(3.0)),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, foregroundColor: Colors.black),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onAddImageContent,
              child: Text('Add Image'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, foregroundColor: Colors.black),
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
            content.type == 1
                ? TextField(
                    onChanged: (value) => content.content = value,
                    maxLines: 4,
                    decoration: InputDecoration(labelText: 'Content Text'),
                  )
                : SimpleNetworkImage(imageUrl: content.content, boxFitType: BoxFit.contain),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Text('Delete Content'),
            ),
          ],
        ),
      ),
    );
  }
}

// Validate
bool _isValidContent(Content content) {
  // Rule 5: Content must not be an empty string
  return content.content.isNotEmpty;
}

bool _isValidLesson(Lesson lesson) {
  // Rule 2: Lesson title must not be an empty string
  if (lesson.title.isEmpty) {
    return false;
  }

  // Rule 3: Lesson estimateTime must be more than 0
  if (lesson.estimateTime <= 0) {
    return false;
  }

  // Rule 4: Contents must have at least 1 content complying with rule 5
  bool hasValidContent =
      lesson.contents.any((content) => _isValidContent(content));

  return hasValidContent;
}

bool _isValidLessons(List<Lesson> lessons) {
  // Rule 1: At least one lesson must comply with all rules 2, 3, 4
  bool hasValidLesson = lessons.any((lesson) => _isValidLesson(lesson));

  if (!hasValidLesson) {
    return false;
  }

  // All lessons must either comply with all rules 2, 3, 4 or violate all 2, 3, 4
  bool allLessonsComply = lessons
      .every((lesson) => _isValidLesson(lesson) || !_isValidLesson(lesson));

  return allLessonsComply;
}
