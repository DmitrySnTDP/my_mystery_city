import 'package:flutter/material.dart';
import 'package:my_mystery_city/views/map_page.dart';

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  final colorOnClick = Color.fromRGBO(246, 135, 99, 1);
  // final gradientColor = ShaderMask(
  // shaderCallback: (Rect bounds) {
  //   return LinearGradient(
  //     colors: [Color.fromRGBO(247, 108, 108, 1), Color.fromRGBO(244, 162, 89, 1)],
  //     begin: Alignment.centerLeft,
  //     end: Alignment.centerRight,
  //     ).createShader(bounds);
  //   },
  //   child: Icon(Icons.settings),
  // );


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
              
              indicatorColor: Color.from(alpha: 0, red: 255, green: 255, blue: 255),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                return TextStyle(
                  fontSize: 12,
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: states.contains(WidgetState.selected)
                      ? Color.fromRGBO(246, 135, 99, 1)
                      : Color.fromRGBO(51, 51, 51, 1),
                );
              }),
              selectedIndex: selectedIndex,
              destinations: <Widget>[
                NavigationDestination(
                  selectedIcon: ImageIcon(const AssetImage("assets/icons/map.png"), color: colorOnClick),
                  icon: const ImageIcon(AssetImage('assets/icons/map.png')),
                  label: 'Карта',
                ),
                NavigationDestination(
                  selectedIcon: ImageIcon(const AssetImage("assets/icons/routes.png"), color: colorOnClick),
                  icon: const ImageIcon(AssetImage('assets/icons/routes.png')),
                  label: 'Категории',
                ),
                NavigationDestination(
                  selectedIcon: ImageIcon(const AssetImage("assets/icons/achievements.png"), color: colorOnClick),
                  icon: const ImageIcon(AssetImage('assets/icons/achievements.png')),
                  label: 'Достижения',
                  
                ),
                NavigationDestination(
                  selectedIcon: ImageIcon(const AssetImage("assets/icons/profile.png"), color: colorOnClick),
                  icon: const ImageIcon(AssetImage('assets/icons/profile.png')),
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