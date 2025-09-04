import 'package:flutter/material.dart';
// import 'package:my_mystery_city/controllers/root_creater.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/enums/routes_enum.dart';
import 'package:my_mystery_city/views/more_info_point_page.dart';


void openRouteMoreInfoPage(BuildContext context, List<MarkerMap> markers, RouteType route, String routeDistance, String routeTime) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RouteMoreInfoPage(markers: markers, route: route, routeDistance: routeDistance, routeTime: routeTime),
      ),
    );
}

class RouteMoreInfoPage extends StatefulWidget {
  final List<MarkerMap> markers;
  final RouteType route;
  final String routeDistance;
  final String routeTime;
  // final PedestrianRouteManager? routeManager;
  const RouteMoreInfoPage({super.key, required this.markers, required this.route, required this.routeDistance, required this.routeTime});

  @override
  State<RouteMoreInfoPage> createState() => _RouteMoreInfoPageState();

}
class _RouteMoreInfoPageState extends State<RouteMoreInfoPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child:  Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 18),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              margin: EdgeInsets.only(bottom: 13),
              child: Padding( 
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 6,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Маршрут «${widget.route.name}»",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.route.description,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 13,
                      ),
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
                          widget.routeTime,
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
                          widget.routeDistance,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              spacing: 13,
              children: getMarkersCards(widget.markers, context),
            ),
            SizedBox(height: 13,),
          ], 
        ),
      ),
    );
  }
}

List<Widget> getMarkersCards(List<MarkerMap> markers, BuildContext context) {
  List<Widget> widgets = [];
  for (final marker in markers) {
    final sentenses = marker.description.split(". ");
    var shortDescription = marker.description;
    if (sentenses.length > 2) {
      shortDescription = sentenses.getRange(0, 2).join(". ");
    }
    if (marker.isChecked == 1) {
      widgets.add(
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          margin: EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Image(
                  image: AssetImage(marker.imgLink[0]),
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      shortDescription,
                      textAlign: TextAlign.start,
                      
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);

                            openMoreInfo(context, marker);
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
        ),
      );
    }
    else {
      widgets.add(
        Stack(
          children: [
            Image.asset("assets/images/widgets_imgs/lock.png"),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                SizedBox(height: 100, width: 357), 
                Text(
                  "Откроется, когда изведаете локацию",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14)
                ),
              ]
            ),
          ]
        ),
      );
    }
  }
  return widgets;
}