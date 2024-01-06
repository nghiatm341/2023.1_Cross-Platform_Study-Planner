
import 'package:flutter/material.dart';

class SimpleNetworkImage extends StatelessWidget {

  final String imageUrl;

  final BoxFit boxFitType;

  const SimpleNetworkImage({super.key, required this.imageUrl, required this.boxFitType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Image.network(
          imageUrl,
          fit: boxFitType,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Text('Error loading image');
          },
        ),
    );
  }
}