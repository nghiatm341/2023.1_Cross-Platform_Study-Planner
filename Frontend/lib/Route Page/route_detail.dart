import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/Route%20Page/route_lesson_item.dart';

class RouteDetail extends StatelessWidget {
  const RouteDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Route Detail",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg1.jpg"), fit: BoxFit.cover),
        ),

        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //description
          Container(
            padding: EdgeInsets.all(8),

            //width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              "Khoá học này dành cho những học viên tham gia chương trình giảng dạy về Android do người hướng dẫn giảng dạy trong môi trường lớp học, nằm trong chương trình Phát triển Android bằng Kotlin.",
              style: TextStyle(fontSize: 16),
            ),
          ),

          //progress
          Container(
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Complete 7/15 lessons",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Center(
                    child: Text(
                      "45%",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
          ),

          //list lesson
          Expanded(
              child: ListView(children: [
            RouteLessonItem(),
            RouteLessonItem(),
          ]))
        ]),
      ),
    );
  }
}
