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
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List data = jsonData['data'];
        print(data);

        setState(() {
          postData1 = data.map((item) {
            String postId = item['_id'] ?? "";
            // Perform null checks using the null-aware and null-coalescing operators
            String userName = item['user'] != null
                ? '${item['user']['lastName'] ?? ''} ${item['user']['firstName'] ?? ''}'
                : "";
            String title = item['title'] ?? "";
            String content = item['content'] ?? "";
            String createdAt = item['created_at'] ?? "";
            List listLike = item['list_like'] ?? [];
            List listComment = item['list_comment'] ?? [];
            return PostItemData(
              postId: postId,
              userName: userName,
              title: title,
              content: content,
              type: 0,
              listLike: listLike,
              listComment: listComment,
              createdAt: createdAt,
              routeId: 0,
              avatarUrl: (item['user'] != null  && item['user']['avatar'] != null) ? item['user']['avatar']  : ""
            );
          }).toList();
        });
      }
    } catch (e) {
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
    return Expanded(
      child: RefreshIndicator(
        onRefresh: getCourses,
        child: ListView.builder(
            itemCount: postData1.length,
            itemBuilder: (context, index) {
              final post = postData1[index];
        
              return PostItem(postItemData: post);
            }),
      ),
    );
  }
}
