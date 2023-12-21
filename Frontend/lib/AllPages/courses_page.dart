import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Courses"),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg3.jpg"), fit: BoxFit.cover)),
            child: const Column(
              children: [
                TabBar(tabs: [
                  Tab(
                    icon: Icon(
                      Icons.bookmark_added_outlined,
                      color: Colors.black,
                    ),
                    child: Text(
                      "Subscribed",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.language_outlined,
                      color: Colors.black,
                    ),
                    child: Text(
                      "Browse",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ])
              ],
            ),
          ),
        ));
  }
}
