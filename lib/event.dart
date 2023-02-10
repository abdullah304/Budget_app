import 'package:flutter/material.dart';



class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  // keeps track of what the user typed
  //final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            TextField(
              //controller: textController ,
              decoration: InputDecoration(
                hintText:"Enter Event",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      //

    );
  }
}