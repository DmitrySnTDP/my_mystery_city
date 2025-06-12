import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;
import 'views/home_page.dart';
import 'data/db_worker.dart';
import '_mapkit_key.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkDB();
  // cachedPoint();
  init.initMapkit(
    apiKey: mapkitApiKey,
    locale: "ru_RU"
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My mystery city',
      theme: ThemeData(colorSchemeSeed: Colors.white),
      home: const MyHomePage(title: 'My Mystery City'),
    );
  }
}