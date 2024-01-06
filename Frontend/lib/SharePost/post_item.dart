import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  PostItemData postItemData;

  PostItem({super.key, required this.postItemData});

  @override
  State<PostItem> createState() => _PostItem();
}

class _PostItem extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                // Circle Avatar for the picture
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/profile_picture.jpg'), // Replace with actual image
                  radius: 25.0,
                ),
                SizedBox(width: 10.0),
                // Name and Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postItemData.userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.postItemData.createdAt),
                  ],
                ),
              ],
            ),
          ),
          // Body
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                // Title
                Text(
                  widget.postItemData.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5.0),
                // Content
                Text(
                  widget.postItemData.content,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                // Like Button
                TextButton(
                  onPressed: () {
                    // Handle like button click
                    print('Like button clicked');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up),
                      SizedBox(width: 5.0),
                      Text('Like'),
                    ],
                  ),
                ),
                // Comment Button
                TextButton(
                  onPressed: () {
                    // Handle comment button click
                    print('Comment button clicked');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.comment),
                      SizedBox(width: 5.0),
                      Text('Comment'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostItemData {
  final String postId;
  final String userName;
  final String title;
  final String content;
  final int type;
  final List listLike;
  final List listComment;
  final String createdAt;
  final int routeId;

  PostItemData(
      {required this.postId,
      required this.userName,
      required this.title,
      required this.content,
      required this.type,
      required this.listLike,
      required this.listComment,
      required this.createdAt,
      required this.routeId});
}
