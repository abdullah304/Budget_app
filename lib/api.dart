import 'event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import http.client;
import 'dart:convert';
// import 'dart:ui' as ui show Canvas, Paint, Path;

class MyAPI {
  Future<String> fetchSomeData(String query) async {
    var apikey =
        'c5de17dd587cea9b22bd1bde4533efc3837a87c8cd01222cbededbb641e0c96f';
    Set<dynamic> uniqueTitles = {};
    List<dynamic> webData = [];

    var url = Uri.parse(
        'https://serpapi.com/search?q=$query&engine=google_events&api_key=$apikey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['events_results'];
      webData.addAll(data);
      String jsonWebData = jsonEncode(webData);
      return jsonWebData;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

}