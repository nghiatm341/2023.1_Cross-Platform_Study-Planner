import 'package:flutter/material.dart';
import 'package:frontend/SharePost/post_item.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPosts();
}

class _AllPosts extends State<AllPosts> {
// Sample data
  final List<PostItemData> postData = [
    PostItemData(
        postId: 0,
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
    PostItemData(
        postId: 0,
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
    PostItemData(
        postId: 0,
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
    PostItemData(
        postId: 0,
        userName: 'A',
        title: 'First post',
        content: "This is the first post",
        type: 0,
        listLike: [],
        listComment: [],
        createdAt: '17:00 20/12/2023',
        routeId: 0),
  ];

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
