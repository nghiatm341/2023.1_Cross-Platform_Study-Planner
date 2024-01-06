import 'package:flutter/material.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/const.dart' as constaint;

class PostItem extends StatefulWidget {
  final PostItemData postItemData;

  PostItem({Key? key, required this.postItemData}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  TextEditingController _commentController = TextEditingController();

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
                                    'userID': AppStore.ID,
                                    'postId': widget.postItemData.postId,
                                    'comment': comment
                                  }), // Encode the POST data to JSON
                                );
                                print(response.body);
                                if(response.statusCode == 201) {
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
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        comment,
                        textAlign: TextAlign.left,
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
