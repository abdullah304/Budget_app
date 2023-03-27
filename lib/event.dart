import 'package:flutter/material.dart';
import 'dart:io';
import 'api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class Event {
  final String name;
  final String url;
  final String date;
  final String thumbnail;
  final double? price;

  Event(
      {required this.name,
      required this.url,
      required this.date,
      required this.thumbnail,
      this.price});
}

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<dynamic> events = [];
  List<dynamic> cacheEvents = [];
  TextEditingController searchController = TextEditingController(); //
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    var result = await MyAPI().fetchSomeData();
    var decodedResult = jsonDecode(result);
    List<Map<String, dynamic>> webData = List.castFrom(decodedResult);
    List<Event> eventData = [];
    for (var i = 0; i < webData.length; i++) {
      var event = webData[i];
      var event_details = Event(
          name: event['name'] ?? '',
          url: event['url'] ?? '',
          date: event['date'] ?? '',
          thumbnail: event['thumbnail'] ?? '',
          price: event['price'] ?? 0.0);
      eventData.add(event_details);
    }
    setState(() {
      events = eventData;
      cacheEvents = eventData;
    });
  }

  void filterEvents(String searchText, String priceText) {
    if (searchText.isEmpty && priceText.isEmpty) {
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
              onChanged: (ignore) {
                if (searchController.text == '' && priceController.text == '') {
                  setState(() {
                    events = cacheEvents;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Enter Event",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              onChanged: (ignore) {
                if (searchController.text == '' && priceController.text == '') {
                  setState(() {
                    events = cacheEvents;
                  });
                }
              },
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
                    String searchText = searchController.text;
                    String priceText = priceController.text;
                    List<dynamic> filteredEvents = events //title search
                        .where((event) => event.name
                            .toLowerCase()
                            .contains(searchText.toLowerCase()))
                        .toList();
                    //price filter
                    if (priceText.isNotEmpty) {
                      filteredEvents = filteredEvents
                          .where(
                              (event) => event.price <= double.parse(priceText))
                          .toList();
                      filteredEvents.sort((a, b) => b.price.compareTo(a.price));
                    }
                    setState(() {
                      events = filteredEvents;
                    });
                    if (searchText == '' && priceText == '') {
                      setState(() {
                        events = cacheEvents;
                      });
                    }
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
                    //
                    var price_str; //price var
                    if (events[index].price != null) {
                      if (events[index].price == 0) {
                        price_str = "Free";
                      } else if (events[index].price % 1 == 0) {
                        //if .00 decimals
                        price_str = events[index].price.truncate().toString();
                      } else {
                        //normal
                        price_str = events[index].price.toString();
                      }
                    } else {
                      price_str = "Free";
                    }

                    var link = events[index].url;

                    return InkWell(
                        onTap: () {
                          //nothing
                        },
                        splashColor: Colors.amberAccent,
                        highlightColor: Colors.transparent,
                        child: ListTile(
                            leading:
                                Image.network(events[index].thumbnail), //image
                            title: Text(events[index].name), //name
                            subtitle: Text(events[index].date), //date
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("\$ $price_str", //price
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
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
                                          content: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'For more info: ',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: events[index].url,
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          var url =
                                                              events[index].url;
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url);
                                                          }
                                                        })
                                            ]),
                                          ),
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
