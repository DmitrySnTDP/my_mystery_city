import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;
import 'map.dart';
import '_mapkit_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(244, 147, 94, 1)),
      ),
      home: const MyHomePage(title: 'My mystery city'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context){

    Widget page = Placeholder();
    switch (selectedIndex) {
      case 0:
        page = MapPage();
        break;
      case 1:
        page = Placeholder(color: Colors.red,);
        break;
      case 2:
        page = Placeholder(color: Colors.yellow,);
        break;
      case 3:
        page = Placeholder(color: Colors.green,);
        break;
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
            NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                  });
                },
              selectedIndex: selectedIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.map),
                  label: 'Карта',
                ),
                NavigationDestination(
                  icon: Icon(Icons.book),
                  label: 'Справочник',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Настройки',
                ),
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Профиль',
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}