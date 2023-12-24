import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewCourseScreen(),
    );
  }
}

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
      lessons.add(Lesson(title: '', chapterName: '', contents: []));
    });
  }

  void _deleteLesson(int index) {
    setState(() {
      lessons.removeAt(index);
    });
  }

  void _addContent(int lessonIndex) {
    setState(() {
      lessons[lessonIndex].contents.add(Content(type: 0, content: ''));
    });
  }

  void _deleteContent(int lessonIndex, int contentIndex) {
    setState(() {
      lessons[lessonIndex].contents.removeAt(contentIndex);
    });
  }

  void _saveCourse() {
    // Perform API call here using the data from the controllers and lessons
    Map<String, dynamic> courseData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };

    // Example API call:
    // ApiService.createCourse(courseData);

    // You might want to handle the API response or errors here
    print(courseData);
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
                  onDeleteContent: (int contentIndex) => _deleteContent(i, contentIndex),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addLesson,
                child: Text('Add Lesson'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveCourse,
                child: Text('Save'),
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
  String chapterName;
  List<Content> contents;

  Lesson({required this.title, required this.chapterName, required this.contents});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'chapterName': chapterName,
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
      'type': type,
      'content': content,
    };
  }
}

class LessonWidget extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onAddContent;
  final VoidCallback onDelete;
  final Function(int) onDeleteContent;

  LessonWidget({
    required this.lesson,
    required this.onAddContent,
    required this.onDelete,
    required this.onDeleteContent,
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
              onChanged: (value) => lesson.chapterName = value,
              decoration: InputDecoration(labelText: 'Chapter Name'),
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
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(primary: Colors.red),
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
              decoration: InputDecoration(labelText: 'Content Text'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Delete Content'),
            ),
          ],
        ),
      ),
    );
  }
}
