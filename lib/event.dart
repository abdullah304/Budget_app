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
  List<dynamic> cacheEvents = [];
  final searchController = TextEditingController(); //

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    var result = await MyAPI().fetchSomeData('Events in Santa Cruz');
    var decodedResult = jsonDecode(result);
    List<dynamic> newEvents = decodedResult
        .map((event) => Event(
            name: event['title'],
            description: event['description'] ?? '',
            date: event['date']['start_date'] ?? '',
            thumbnail: event['thumbnail'] ?? ''))
        .toList();
    setState(() {
      events = newEvents;
      cacheEvents = newEvents;
    });
  }

  void filterEvents(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        events = cacheEvents;
      });
    }
  }

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
              controller: searchController,
              onChanged: (searchText) {
                filterEvents(searchText);
              },
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
                  splashRadius: 20.0,
                  onPressed: () {
                    String searchText = searchController.text.toLowerCase();
                    List<dynamic> filteredEvents = events
                        .where((event) =>
                            event.name.toLowerCase().contains(searchText))
                        .toList();
                    setState(() {
                      events = filteredEvents;
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
                          //nothing
                        },
                        splashColor: Colors.amberAccent,
                        highlightColor: Colors.transparent,
                        child: ListTile(
                            leading: Image.network(events[index].thumbnail),
                            title: Text(events[index].name),
                            subtitle: Text(events[index].description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(events[index].date),
                                IconButton(
                                  icon: Icon(Icons.add_box),
                                  iconSize: 32.0, //ottomatic
                                  splashRadius: 22.0,
                                  onPressed: () async {
                                    //add item to personal events
                                    bool addEvent = await showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Add this to personal events?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Add'),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (addEvent) {
                                      // add item to personal events
                                      print(events[index].name);
                                      //Image.network(events[index].thumbnail),
                                      //Text(events[index].name),
                                      //Text(events[index].description),
                                      //Text(events[index].date),
                                    }
                                  },
                                )
                              ],
                            )));
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
