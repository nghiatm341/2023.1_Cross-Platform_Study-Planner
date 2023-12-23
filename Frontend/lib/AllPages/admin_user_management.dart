import 'package:flutter/material.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("User management")),
    );
  }
}