import 'event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import http.client;
import 'dart:convert';
// import 'dart:ui' as ui show Canvas, Paint, Path;
import 'package:intl/intl.dart'; //translate date to something readable

class MyAPI {
  Future<String> fetchSomeData() async {
    //event_id part
    List<dynamic> id = [];
    var event_id_url = Uri.parse('http://localhost:5000/events');
    var response = await http.get(event_id_url);
    if (response.statusCode == 200) {
      var id_data = jsonDecode(response.body);
      for (int i = 1; i < 2; i++) {
        for (var items in id_data[i.toString()]) {
          //if(!unique_id.contains(items)){
          id.add(items);
          //}
        }
      }
    } else {
      print("Failed to fetch Event Id's");
    }

    Set<dynamic> unique_id = id.toSet(); //filters our duplicates

    //event details part
    List<Map<String, dynamic>> event_details = [];
    for (var event_id in unique_id) {
      var url = Uri.parse('http://localhost:5000/events/$event_id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var name = data["name"]?["text"] ?? '';
        var url = data["url"] ?? '';
        var thumbnail = data["logo"]?["url"] ?? '';

        var min_price = data["ticket_availability"]?["minimum_ticket_price"]
                ?["major_value"] ??
            '';
        var max_price = data["ticket_availability"]?["maximum_ticket_price"]
                ?["major_value"] ??
            '';
        var price;
        if (min_price != null && max_price != null) {
          //turn price into double
          price = (double.parse(max_price) + double.parse(min_price)) / 2;
        } else {
          price = 0;
        }

        var date;
        var raw_date = data["start"]?["local"] ?? ''; //ex: 2023-04-02:2354324
        if (raw_date != null) {
          DateTime clean_date = DateTime.parse(raw_date); //ex: april 3 2023
          date = DateFormat('MMMM d').format(clean_date); //ex: april 2
        } else {
          date = null;
        }
        print(price);
        event_details.add({
          'name': name,
          'url': url,
          'thumbnail': thumbnail,
          'price': price,
          'date': date
        });
      }
    }
    String jsonWebData = jsonEncode(event_details);
    return jsonWebData;
  }
}





/*
class MyAPI {
  Future<String> fetchSomeData() async {
    var event_id = '564929879477';
    Set<dynamic> uniqueTitles = {};
    List<dynamic> webData = [];
    var url = Uri.parse(
        'https://www.eventbriteapi.com/v3/events/$event_id/?expand=ticket_availability');
    var response = await http
        .get(url, headers: {'Authorization': 'Bearer YJ34VU55YJRL5GSDVLBF'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      webData.add(data);
    } else {
      throw Exception('Failed to fetch data from API');
    }
    String jsonWebData = jsonEncode(webData);
    return jsonWebData;
  }
}
*/