import 'package:flutter/material.dart';
// import 'package:frontend/Course%20Page/course_item.dart';

class CourseForm extends StatefulWidget {
  // final CourseItemData courseData;

  // const CourseForm(
  //     {super.key, required this.courseData});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void saveCourse() {
    // Replace this with your actual API call logic
    Course newCourse = Course(
      title: _titleController.text,
      description: _descriptionController.text,
    );

    // Map the Course object to Map<String, dynamic>
    Map<String, dynamic> courseMap = newCourse.toMap();

    // Print the mapped data (for testing purposes)
    print(courseMap);

    // Add your API call logic here
    // Example: api.saveCourse(courseMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Validate inputs before saving
                if (_titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty) {
                  saveCourse();
                } else {
                  // Show a snackbar or alert indicating that fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class Course {
  String title;
  String description;

  Course({required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}