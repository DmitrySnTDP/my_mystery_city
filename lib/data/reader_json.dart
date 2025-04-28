import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:my_mystery_city/data/db_worker.dart';


Future<String> readJsonFile(String filePath)  {
  return rootBundle.loadString(filePath);
}

Future<List<MarkerMap>> readMarkersFromJson(String filePath) async {
  String contents = await rootBundle.loadString(filePath);
  List<dynamic> jsonArray = jsonDecode(contents);
  return jsonArray.map((item) => MarkerMap.fromJson(item)).toList();
}