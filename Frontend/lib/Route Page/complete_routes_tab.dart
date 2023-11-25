import 'package:flutter/material.dart';

class CompleteRoutesTab extends StatefulWidget {
  const CompleteRoutesTab({super.key});

  @override
  State<CompleteRoutesTab> createState() => _CompleteRoutesTabState();
}

class _CompleteRoutesTabState extends State<CompleteRoutesTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Complete tab"),),
    );
  }
}