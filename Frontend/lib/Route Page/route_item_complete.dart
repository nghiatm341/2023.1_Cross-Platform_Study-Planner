import 'package:flutter/material.dart';
import 'package:frontend/Route%20Page/route_item.dart';
import 'package:frontend/Route%20Page/route_detail.dart';
import 'package:frontend/const.dart' as constaint;
import 'package:frontend/ultils/simpleNetworkImage.dart';
import 'package:frontend/ultils/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteItemComplete extends StatefulWidget {

  final RouteItemData routeData;

  const RouteItemComplete({super.key, required this.routeData});

  @override
  State<RouteItemComplete> createState() => _RouteItemCompleteState();
}

class _RouteItemCompleteState extends State<RouteItemComplete> {

   RouteItemCompleteUIData routeItemUIData = new RouteItemCompleteUIData();
   String courseDescription = "";

    void _reload(){
      fetchCourses(widget.routeData);
    }

   Future<void> fetchCourses(RouteItemData routeData) async {
    Map<String, String> headers = {
      'Content-Type':
          'application/json', // Set the content type for POST request
      // Add other headers if needed
    };

    Map<String, dynamic> postData = {'id': routeData.courseId};

    try {
      final response = await http.post(
        Uri.parse('${constaint.apiUrl}/course/getById'),
        headers: headers,
        body: jsonEncode(postData), // Encode the POST data to JSON
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonData = json.decode(response.body);
        final courseData = jsonData['data'];

        setState(() {
          courseDescription = courseData['description'];
          routeItemUIData.title = courseData['title'];
          routeItemUIData.startDate = routeData.createdAt;
          routeItemUIData.endDate = routeData.finishedAt;
          routeItemUIData.author = courseData['author_id']['firstName'] +  " " + courseData['author_id']['lastName'];
        });
      } else {
        // Request failed with an error status code
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Catch and handle any errors that occur during the API call
      print('Error: $error');
    }
  }


   @override
  void initState() {
    super.initState();
    fetchCourses(widget.routeData);
  }

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
                    flex: 2,
                    child: Container(height: 60, child: SimpleNetworkImage(imageUrl: widget.routeData.courseAvatar))),
    
    
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(routeItemUIData.title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left, ),
                        ),
                        Text("author: " + routeItemUIData.author,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left),
                      
                         
                      ],
                    ),
                  ),
                ),
    
                
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
    
                      Text("Start: " + routeItemUIData.startDate, style: TextStyle(fontSize: 16),),
                      Text("End: " + routeItemUIData.endDate, style: TextStyle(fontSize: 16),),
                  
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 49, 247, 42),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black)
                ),
                
          ),
        ),
      ),

      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RouteDetail(description: courseDescription, routeId: widget.routeData.routeId, testCb: () => {},)))
      },
    );
  }
}

class RouteItemCompleteUIData {
  String title = "...";
  String author = "...";
  String startDate = "...";
  String endDate = "...";
}


