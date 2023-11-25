import 'package:flutter/material.dart';

class InProgressRoutesTab extends StatefulWidget {
  const InProgressRoutesTab({super.key});

  @override
  State<InProgressRoutesTab> createState() => _InProgressRoutesTabState();
}

class _InProgressRoutesTabState extends State<InProgressRoutesTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("In progress tab"),),
    );
  }
}