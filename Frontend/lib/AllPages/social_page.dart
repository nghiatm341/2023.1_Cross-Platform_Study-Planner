import 'package:flutter/material.dart';
import 'package:frontend/SharePost/all_post.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("My Courses"),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           // CreateCourse(),
              //           // NewCourseScreen(),

              //     ));
              print('Create post');
            },
            child: Icon(Icons.add), // Add your icon here
            backgroundColor: Colors.amber, // Change FAB background color
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg1.jpg"), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.new_releases, color: Colors.black),
                    child: Text(
                      "All Posts",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    icon: Icon(Icons.drafts, color: Colors.black),
                    child: Text(
                      "My Posts",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
                Expanded(
                  child: TabBarView(children: [AllPosts(), AllPosts()]),
                )
              ],
            ),
          )),
    );
  }
}
