import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Event {
  final String name;
  final String description;
  final String date;
  final String thumbnail;

  Event({
    required this.name,
    required this.description,
    required this.date,
    required this.thumbnail,
  });
}

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<dynamic> events = [];
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
                hintText: "Enter Event",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.amber,
                  onPressed: () async {
                    var result =
                        await MyAPI().fetchSomeData('Events in Santa Cruz');
                    var decodedResult = jsonDecode(result);
                    List<dynamic> newEvents = decodedResult
                        .map((event) => Event(
                            name: event['title'],
                            description: event['description'] ?? '',
                            date: event['date']['start_date'] ?? '',
                            thumbnail: event['thumbnail'] ?? ''))
                        .toList();
                    setState(() {
                      events =
                          newEvents; // Update the state with the API result
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                        height: 1, thickness: 5, color: Colors.white);
                  },
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        print('hey this works');
                        //add item to personal events?
                      },
                      splashColor: Colors.amberAccent,
                      child: ListTile(
                        leading: Image.network(events[index].thumbnail),
                        title: Text(events[index].name),
                        subtitle: Text(events[index].description),
                        trailing: Text(events[index].date),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
