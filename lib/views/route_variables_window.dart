import 'package:flutter/material.dart';
import 'package:my_mystery_city/controllers/map_state.dart';
import 'package:my_mystery_city/views/home_page.dart';
// import 'package:path/path.dart';
// import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/transport.dart';


class RouteOverlay extends StatelessWidget {
  final List<MasstransitRoute> routesData;
  final Function func;
  final VoidCallback onClose;

  const RouteOverlay({
    super.key,
    required this.routesData,
    required this.func,
    required this.onClose,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.65),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(247, 245, 242, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        children:[ 
          IconButton(
            icon: Icon(Icons.close),
            style: ButtonStyle(alignment: Alignment.topRight),
            onPressed: onClose
          ),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: getVariablesRoute(routesData, func, context),
          ),
          Padding(padding: EdgeInsets.only(left: 120, right: 120), child: 
          TextButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(orangeColor),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              minimumSize: WidgetStatePropertyAll(Size(150, 50)),
            ),
            child: Text(
              "Начать",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              )
            ),
          ),)
        ]
      ),
    );
  }
}

List<Widget> getVariablesRoute(List<MasstransitRoute> routes, Function callBackFunc, BuildContext context) {
  List<Widget> widgets = [];

  final buttonStyle = ButtonStyle(
    shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      side: BorderSide(color: orangeColor),
      borderRadius: BorderRadius.circular(10),
      ),
    ),
    minimumSize: WidgetStatePropertyAll(
      Size((MediaQuery.of(context).size.width / routes.length) - 40, 50)
    )
  );

  final buttonStyleActive = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(orangeColor),
    shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      ),
    ),
    minimumSize: WidgetStatePropertyAll(
      Size((MediaQuery.of(context).size.width / routes.length) - 35, 50)
    )
  );

  for (var i = 0; i < routes.length; i++) {
    final textColor = showRouteNum.value == i ? Colors.white: orangeColor;

    widgets.add(
      TextButton(
        onPressed: null,
        child: Column(
          children: [
            TextButton(
              onPressed: () => callBackFunc(i),
              
              style: showRouteNum.value == i ? buttonStyleActive: buttonStyle,
              child: Column(
                children: [
                  Text(
                    routes[i].metadata.weight.time.text,
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    routes[i].metadata.weight.walkingDistance.text,
                    style: TextStyle(color: textColor),
                  ),
                ]
              )
            )
          ]
        )
      )
    );
  }
  return widgets;
}