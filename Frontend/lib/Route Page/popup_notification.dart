import 'package:flutter/material.dart';

class PopupNotification extends StatefulWidget {

  final String message;

  const PopupNotification({super.key, required this.message});

  @override
  State<PopupNotification> createState() => _PopupNotification();
}

class _PopupNotification extends State<PopupNotification> {

  void _close(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 120,
  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
              Text(widget.message),     
              ElevatedButton(onPressed: _close, child: Text("Oke"))   
          ]),
      ),
    );
  }
}