import 'package:flutter/material.dart';

class PopupUnsubscribeResult extends StatefulWidget {
  final bool isUnsubscribedSucceed;
  const PopupUnsubscribeResult({super.key, required this.isUnsubscribedSucceed});

  @override
  State<PopupUnsubscribeResult> createState() => _PopupUnsubscribeResultState();
}

class _PopupUnsubscribeResultState extends State<PopupUnsubscribeResult> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: Container(
        height: widget.isUnsubscribedSucceed ? 100 : 120,
        child: Column(
          children: [

            Visibility(
              visible: widget.isUnsubscribedSucceed,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  child: Text("Unsubscribe course successfully"),
                ),
            ),

            Visibility(
              visible: widget.isUnsubscribedSucceed,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  ElevatedButton(onPressed: () => { Navigator.pop(context) }, child: Text("Continue")),
                ],),
            ),

             Visibility(
              visible: !widget.isUnsubscribedSucceed,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  child: Text("Unsubscribe course failed, please try later again :(("),
                ),
            ),

            Visibility(
              visible: !widget.isUnsubscribedSucceed,
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