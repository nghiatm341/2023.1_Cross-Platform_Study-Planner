import 'package:flutter/material.dart';

class RouteLessonDetail extends StatefulWidget {
  const RouteLessonDetail({super.key});

  @override
  State<RouteLessonDetail> createState() => _RouteLessonDetailState();
}

class _RouteLessonDetailState extends State<RouteLessonDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lesson detail"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.white
              .withOpacity(0.5), // Set the opacity level (0.5 for 50% opacity)
          BlendMode.srcATop, // Adjust BlendMode as needed
        ),

        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg2.jpg"), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
