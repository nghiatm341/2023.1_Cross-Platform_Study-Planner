import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_detail.dart';

class RouteItem extends StatelessWidget {

  final RouteItemData routeData;

  RouteItem({
      super.key,
      required this.routeData
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Container(
            height: 120,
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Icon(
                      Icons.book,
                      size: 60,
                    )),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          routeData.title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text("Author: " + routeData.author,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                      Text(
                         "Start: " + routeData.startDate,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50, // Set the width of the container
                        height: 50, // Set the height of the container
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 255, 255,
                              255), // Set the background color of the circle
                        ),
                        child: Center(
                          child: Text(
                            routeData.progress + "%", // Number to display inside the circle
                            style: TextStyle(
                              color: Colors.green, // Color of the number text
                              fontSize: 20, // Font size of the number text
                              fontWeight: FontWeight
                                  .bold, // Font weight of the number text
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 132, 230, 255),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black)),
          ),
        ),
      ),
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetail()))
      },
    );
  }
}

class RouteItemData {
  final String title;
  final String author;
  final String startDate;
  final String progress;

  RouteItemData(
      {required this.title,
      required this.author,
      required this.startDate,
      required this.progress});
}
