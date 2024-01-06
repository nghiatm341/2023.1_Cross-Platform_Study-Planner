import 'package:flutter/material.dart';
import 'package:frontend/SharePost/all_post.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;
import 'dart:convert';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(AppStore.ID);
  }
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String content = '';
        String imageUrl = '';

        return AlertDialog(
          title: Text('Create Post'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Content'),
                  onChanged: (value) {
                    content = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onChanged: (value) {
                    imageUrl = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Đóng hộp thoại khi người dùng nhấn Cancel
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: ()async {
                Map<String, String> headers = {
            'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
               };
                try {
                  final response = await http.post(
                  Uri.parse('${constaint.apiUrl}/post/create'),
                  headers: headers,
                  body: jsonEncode({
                    'userId': AppStore.ID,
                    'title': title,
                    'content': content,
                    'image': imageUrl
                  }),
                );
                print('userId: ${AppStore.ID} Title: $title, Content: $content, Image URL: $imageUrl');
                } catch (e) {
                  print(e);
                }
                // Đóng hộp thoại sau khi xử lý xong
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  },
  child: Icon(Icons.add),
  backgroundColor: Colors.amber,
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
