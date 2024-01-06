import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/SharePost/post_item.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/const.dart' as constaint;


class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPosts();
}

class _AllPosts extends State<AllPosts> {
// Sample data
  List<PostItemData> postData1 = [];
  List<PostItemData> postData = [
    PostItemData(
        postId: "",
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
    PostItemData(
        postId: "",
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
    PostItemData(
        postId: "",
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
    PostItemData(
        postId: "",
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
  ];


  Future getCourses() async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/post/list'),
        headers: headers,
        body: jsonEncode({}), // Encode the POST data to JSON
      );
      if(response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List data = jsonData['data'];
        print(data);

        setState(() {
          
          /* postData1 = data.map((item) {
            String postId = item['_id'];
            String userName = item['_id'];

            return PostItemData(
              postId: postId, 
              userName: '',

    
             );
          }).toList(); */

        });
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: postData.length,
        itemBuilder: (context, index) {
          final post = postData[index];

          return PostItem(postItemData: post);
        });
  }
}
