
import 'package:flutter/material.dart';

class SimpleNetworkImage extends StatelessWidget {

  final String imageUrl;

  const SimpleNetworkImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
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