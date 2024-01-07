import 'package:flutter/material.dart';
import 'package:frontend/ultils/simpleNetworkImage.dart';
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
  late List listComment =  [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLike = widget.isLike;
    listComment = widget.postItemData.listComment;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool hasAvatar = widget.postItemData.avatarUrl != "";

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
                Container(
                  child: Container(
                      height: 60, 
                      child: 
                        hasAvatar ? SimpleNetworkImage(imageUrl: widget.postItemData.avatarUrl, boxFitType: BoxFit.cover) : Image(image: AssetImage("assets/user-default.png"), fit: BoxFit.cover) 
                        )
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
                                //print(response.body);
                                if (response.statusCode == 201) {
                                  final jsonData = json.decode(response.body);
                                  final List newLisCmt = jsonData['post']['list_comment'];

                                  setState(() {
                                    listComment = newLisCmt; 
                                  });
  
                                  _commentController.clear(); // Clear the input field
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
                  itemCount: listComment.length,
                  itemBuilder: (BuildContext context, int index) {
                    final comment =
                        listComment[index]['comment'];
                    final name = listComment[index]['name'];
                    final avatar = listComment[index]['avatar'];

                    bool hasAvatar = avatar != "";

                    debugPrint(avatar);

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,

                           child: hasAvatar ? SimpleNetworkImage(imageUrl: avatar, boxFitType: BoxFit.cover) : Image(image: AssetImage("assets/user-default.png"), fit: BoxFit.cover)
                            
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
  final String avatarUrl;

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
    required this.avatarUrl
  });
}
