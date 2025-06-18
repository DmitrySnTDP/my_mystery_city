import 'package:flutter/material.dart';
import 'package:my_mystery_city/views/categories_page.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;
import 'views/home_page.dart';
import 'data/db_worker.dart';
import '_mapkit_key.dart';

const orangeColor = Color.fromRGBO(246, 135, 99, 1);
const backgroundColorCustom =  Color.fromRGBO(247, 245, 242, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkDB();
  await getPoints();
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
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
        scaffoldBackgroundColor: backgroundColorCustom,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColorCustom,
          surfaceTintColor: backgroundColorCustom,
        ),
      ),
      home: MyHomePage(),
    );
  }
}