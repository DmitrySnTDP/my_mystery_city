import 'package:flutter/services.dart';

Future<String> readJsonFile(String filePath)  {
  return rootBundle.loadString(filePath);
}