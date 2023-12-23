import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/complete_routes_tab.dart';
import 'package:frontend/Route%20Page/in_progress_routes_tab.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("My learning route"),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg1.jpg"), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const TabBar(
     
                  tabs: [
                  Tab(
                    icon: Icon(Icons.schedule, color: Colors.black),
                    child: Text(
                      "In progress",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    icon: Icon(Icons.task_alt, color: Colors.black),
                    child: Text(
                      "Complete",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
                Expanded(
                  child: TabBarView(
                      children: [InProgressRoutesTab(), CompleteRoutesTab()]),
                )
              ],
            ),
          )),
    );
  }
}
