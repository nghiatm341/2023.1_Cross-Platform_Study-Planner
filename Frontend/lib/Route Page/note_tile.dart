import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/Route%20Page/lesson_note_page.dart';
import 'package:frontend/ultils/store.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteTile extends StatelessWidget {
  final NoteData noteData;
  Function(BuildContext)? deleteFunction;

  NoteTile({super.key, required this.noteData, required this.deleteFunction,});

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, top: 0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(8),
            )
          ],
        ),
        child: Container(
          width: 800,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            noteData.content,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
