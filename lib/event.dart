import 'package:flutter/material.dart';



class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  // keeps track of what the user typed
  //final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Budget"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              //controller: textController ,
              decoration: InputDecoration(
                hintText:"Enter Event",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText:"Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            Container(

              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.amber,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}