import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_item.dart';

class InProgressRoutesTab extends StatefulWidget {
  const InProgressRoutesTab({super.key});

  @override
  State<InProgressRoutesTab> createState() => _InProgressRoutesTabState();
}

class _InProgressRoutesTabState extends State<InProgressRoutesTab> {

  List routeItemDataList = [
    new RouteItemData(title: "Route 1", author: "Author 1", startDate: "15/12/2023", progress: '45'),
    new RouteItemData(title: "Route 2", author: "Author 2", startDate: "25/12/2023", progress: '90'),
  ];

  @override
  Widget build(BuildContext context) {

    return Container(

      child: ListView.builder(itemBuilder: (context, index) {
        return RouteItem(routeData: routeItemDataList[index]);
      }, itemCount: routeItemDataList.length),
    );
  }
}