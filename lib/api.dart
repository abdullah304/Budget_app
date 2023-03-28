import 'event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import http.client;
import 'dart:convert';
// import 'dart:ui' as ui show Canvas, Paint, Path;

class MyAPI {
  Future<String> fetchSomeData() async {
    //event details part
    List<Map<String, dynamic>> event_details = [];
    var url = Uri.parse('http://localhost:5000/events');
    var response = await http.get(url);
    var raw_text = jsonDecode(response.body);
    for (var event_id in raw_text.keys) {
      if (response.statusCode == 200) {
        var data = raw_text[event_id];
        var name = data["name"] ?? '';
        var thumbnail = data["image"] ?? '';
        var price_str = data["price"] ?? "0.0";
        var price = double.tryParse(price_str.replaceAll('\$', '')) ?? 0.0;
        var date = data["date"] ?? '';
        var id = event_id;
        event_details.add({
          'name': name,
          'thumbnail': thumbnail,
          'price': price,
          'date': date,
          'id' : id
        });
      }
    }
    String jsonWebData = jsonEncode(event_details);
    return jsonWebData;
  }

  Future<String> fetchApiData(String event_id) async {
    String get_url;
    var url = Uri.parse('https://www.eventbriteapi.com/v3/events/$event_id');
    var response = await http
        .get(url, headers: {'Authorization': 'Bearer YJ34VU55YJRL5GSDVLBF'});
    var raw_text = jsonDecode(response.body);
    if (response.statusCode == 200) {
      get_url = raw_text['url'];
    } else {
      get_url = '';
    }
    return get_url;
  }
}
