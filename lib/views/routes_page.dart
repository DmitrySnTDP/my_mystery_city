
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_mystery_city/controllers/map_state.dart';
import 'package:my_mystery_city/controllers/root_creater.dart';
// import 'package:my_mystery_city/controllers/root_creater.dart';
// import 'package:flutter/rendering.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/enums/routes_enum.dart';
import 'package:my_mystery_city/main.dart';
import 'package:my_mystery_city/views/help_widgets.dart';
import 'package:my_mystery_city/views/route_more_info_page.dart';

Map<RouteType, List<MarkerMap>> routesData = {};
var errorRouteWidgetCheck = false;

Future<void> getRoutes() async {
  for (final route in RouteType.values) {
    if (!routesData.containsKey(route) && route != RouteType.noRoute) {
      routesData[route] = await getMarkersMapOnRoute(route);
    }
  }
}


void openRoutesPage(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutesPage(),
      ),
    );
}


class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key,});

  @override
  State<RoutesPage> createState() => _RoutesPageState();

}
class _RoutesPageState extends State<RoutesPage> {
  String searchQuery = '';
  final selectedButtonStyle = ButtonStyle(
    visualDensity: VisualDensity.compact,
    backgroundColor: WidgetStatePropertyAll(orangeColor),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
  final notSelectedButtonStyle = ButtonStyle(
    visualDensity: VisualDensity.compact,
    backgroundColor: WidgetStatePropertyAll(Colors.white),
    shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      side: BorderSide(color: orangeColor),
      borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {

    final filteredList = routesData.keys.where((route) {
      return route.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
      
    return SafeArea(
      top: false,
      child:  Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              margin: EdgeInsets.only(bottom: 10, top: 19),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: selectedButtonStyle,
                    child: Text(
                      "Избранное",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: notSelectedButtonStyle,
                    child: Text(
                      "Изведанное",
                      style: TextStyle(
                        color: orangeColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: notSelectedButtonStyle,
                    child: Text(
                      "Новое",
                      style: TextStyle(
                        color: orangeColor,
                      ),
                    ),
                  ),
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 18, right: 18, bottom: 10),
              child: Column(
                spacing: 10,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Поиск",
                      hintStyle: TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: ImageIcon(const AssetImage("assets/icons/search.png")),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  if (errorRouteWidgetCheck) 
                    errorHelpWidget("Упс, построение маршрута недоступно :(", height: 500, topPos: 50, buttonFunc: () {
                      setState(() {
                        errorRouteWidgetCheck = false;
                      });
                    },),
                  ...getRoutesPreview(
                    context,
                    filteredList,                    
                    () {
                      setState(() {
                        errorRouteWidgetCheck = true;
                      });
                    }),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}

Iterable<Widget> getRoutesPreview(BuildContext context, List<RouteType> routes,  VoidCallback onError,) sync* {
  for (var route in routes) {
    yield FutureBuilder<PedestrianRouteManager>(
      future: createRouteFromMarkers(routesData[route]!),
      builder: (cotext, snapshot) 
      {
        final routeManager = snapshot.data;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 13,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: 6,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Маршрут «${route.name}»",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          route.previewText,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 5,
                      children: [
                        ImageIcon(
                          const AssetImage("assets/icons/time.png"),
                          size: 24,
                        ),
                        Text(
                          routeManager != null && routeManager.pedestrianRoutes.length > 1? routeManager.pedestrianRoutes.first.metadata.weight.time.text : "??",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        ImageIcon(
                          const AssetImage("assets/icons/length.png"),
                          size: 24,
                        ),
                        Text(
                          routeManager != null && routeManager.pedestrianRoutes.length > 1? routeManager.pedestrianRoutes.first.metadata.weight.walkingDistance.text: "??",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            final height = MediaQuery.of(context).size.height;
                            if (routeManager != null) {
                              Navigator.pop(context);
                              showRouteFromPage(routeManager, routesData[route]!, context, height);
                            }
                            else {
                              onError;
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(orangeColor),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          child: Text(
                            "В путь!",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            openRouteMoreInfoPage(context, routesData[route]!, route, routeManager);
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            minimumSize: WidgetStateProperty.all(Size.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Подробнее",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            )
                          )
                        )
                      ]
                    )
                  ]
                )
              )
            ],
          ),
        );
      }
    );
  }
}