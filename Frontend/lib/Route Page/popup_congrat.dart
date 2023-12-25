import 'package:flutter/material.dart';

class PopupCongrat extends StatefulWidget {

  const PopupCongrat({super.key});

  @override
  State<PopupCongrat> createState() => _PopupCongrat();
}

class _PopupCongrat extends State<PopupCongrat> {

  void _close(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 150,
  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
              Text("Congratulation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),    
              Text("You've completed a course!"),     
              ElevatedButton(onPressed: _close, child: Text("Cool!"))   
          ]),
      ),
    );
  }
}