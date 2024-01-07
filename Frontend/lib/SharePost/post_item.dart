import 'package:flutter/material.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;
import 'package:shared_preferences/shared_preferences.dart';

class PostItem extends StatefulWidget {
  final PostItemData postItemData;
  late bool isLike = false;
  PostItem({Key? key, required this.postItemData}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  TextEditingController _commentController = TextEditingController();
  late bool _isLike;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLike = widget.isLike;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

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
            child: Column(
              children: [
                Row(
                  children: [
                    // Like Button
                    TextButton(
                      onPressed: () {
                        // Handle like button click
                        setState(() {
                          _isLike = !_isLike;
                        });
                        print('Like button clicked');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: _isLike ? Colors.blue : Colors.grey,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            'Like',
                            style: TextStyle(
                                color: _isLike ? Colors.blue : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    // Comment TextField and Button
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Handle comment button click
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              final int? userId = prefs.getInt('userId');
                              String comment = _commentController.text;
                              print('Comment button clicked: $comment');

                              try {
                                Map<String, String> headers = {
                                  'Content-Type':
                                      'application/json', // Set the content type for POST request
                                };
                                final response = await http.post(
                                  Uri.parse('${constaint.apiUrl}/post/comment'),
                                  headers: headers,
                                  body: jsonEncode({
                                    'userId': userId,
                                    'postId': widget.postItemData.postId,
                                    'comment': comment
                                  }), // Encode the POST data to JSON
                                );
                                print(response.body);
                                if (response.statusCode == 201) {
                                  print('=======${response.body}');
                                  _commentController
                                      .clear(); // Clear the input field
                                }
                              } catch (e) {
                                print('errrrrrrrrrrrrr: $e');
                              }
                              // Process the comment data as needed
                            },
                            child: Text('Comment'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Other Footer components...
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.postItemData.listComment.length,
                  itemBuilder: (BuildContext context, int index) {
                    final comment =
                        widget.postItemData.listComment[index]['comment'];
                    final name = widget.postItemData.listComment[index]['name'];
                    final avatar =
                        widget.postItemData.listComment[index]['avatar'];

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(avatar ??
                                    "https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg"),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 0, 8, 2),
                            child: Text(
                              name,
                              //textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            comment,
                            //textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    );
                  },
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

  PostItemData({
    required this.postId,
    required this.userName,
    required this.title,
    required this.content,
    required this.type,
    required this.listLike,
    required this.listComment,
    required this.createdAt,
    required this.routeId,
  });
}
