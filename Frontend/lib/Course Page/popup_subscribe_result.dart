import 'package:flutter/material.dart';

class PopupSubscribeResult extends StatefulWidget {
  final bool isSubscribedSucceed;
  const PopupSubscribeResult({super.key, required this.isSubscribedSucceed});

  @override
  State<PopupSubscribeResult> createState() => _PopupSubscribeResultState();
}

class _PopupSubscribeResultState extends State<PopupSubscribeResult> {




  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Container(
        height: widget.isSubscribedSucceed ? 100 : 120,
        child: Column(
          children: [

            Visibility(
              visible: widget.isSubscribedSucceed,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  child: Text("Subscribe course successfully"),
                ),
            ),

            Visibility(
              visible: widget.isSubscribedSucceed,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  ElevatedButton(onPressed: () => { Navigator.pop(context) }, child: Text("Cool!")),
                ],),
            ),

             Visibility(
              visible: !widget.isSubscribedSucceed,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  child: Text("Subscribe course failed, please try later again :(("),
                ),
            ),

            Visibility(
              visible: !widget.isSubscribedSucceed,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  ElevatedButton(onPressed: () => { Navigator.pop(context) }, child: Text("Oke")),
                ],),
            ),
          ],
        ),
      ),
    );
  }
}