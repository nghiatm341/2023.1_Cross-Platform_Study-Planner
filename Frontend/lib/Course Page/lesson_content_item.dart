import 'package:flutter/material.dart';
import 'package:frontend/ultils/simpleNetworkImage.dart';

class LessonContentItem extends StatelessWidget {
  final int contentType;
  final String content;

  const LessonContentItem(
      {super.key, required this.contentType, required this.content});

  @override
  Widget build(BuildContext context) {
    bool isText = (contentType == 1);

    return Container(
      child: isText
          ? Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
            )
          : Container(width: 100, height: 200, child: SimpleNetworkImage(imageUrl: content),),
    );
  }
}
