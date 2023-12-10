import 'package:flutter/material.dart';

class RouteItemComplete extends StatefulWidget {
  const RouteItemComplete({super.key});

  @override
  State<RouteItemComplete> createState() => _RouteItemCompleteState();
}

class _RouteItemCompleteState extends State<RouteItemComplete> {

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Icon(
                    Icons.book,
                    size: 40,
                  )),


              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text("Quantum physic for beginner",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left, ),
                    ),
                    Text("Author: Einstein",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left),

                     
                  ],
                ),
              ),

              
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Start: 12/09/2023", style: TextStyle(fontSize: 16),),
                    Text("End: 12/25/2023", style: TextStyle(fontSize: 16),),
                
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
    );
  }
}

