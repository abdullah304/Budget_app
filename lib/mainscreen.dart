import 'package:flutter/material.dart';
//import 'secondscreen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
          //
        }),
        title: Text("Budget"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){
            //
          }),
        ],
      ),
      /*body: Center(

          child: Text("Next", style: TextStyle(
            primarySwatch: Colors.white,
          ),
          ),
          color: Colors.amber,
          //onPressed: (){
          //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()),
           // );
          }
        ),
      ),*/
    );
  }
}

//RaisedButton({required Text child, required MaterialColor color, param2}) {}
