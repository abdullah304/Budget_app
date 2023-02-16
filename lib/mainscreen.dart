import 'package:flutter/material.dart';
//import 'secondscreen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget"),
        centerTitle: true,
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        //tool tip: increment Counter
        child: const Icon(Icons.add),
      ),
    );
  }
}

//RaisedButton({required Text child, required MaterialColor color, param2}) {}
