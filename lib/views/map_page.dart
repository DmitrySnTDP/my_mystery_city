import 'package:flutter/material.dart' ;
// import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:my_mystery_city/controllers/map_state.dart';
import 'package:my_mystery_city/controllers/root-creater.dart';
import 'package:my_mystery_city/data/reader_json.dart';
import 'package:my_mystery_city/views/home_page.dart';
import 'package:my_mystery_city/views/more_info_point_page.dart';
import 'package:my_mystery_city/views/point_window_on_map.dart';
import 'package:my_mystery_city/views/route_variables_window.dart';

import 'package:yandex_maps_mapkit/mapkit.dart' hide LocationSettings, TextStyle;
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';


late StreamSubscription<Position> _positionStream;

MapWindow? mapWindow_;


class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  VoidCallback? _listener;
  late final double windowWidth;
  late final PedestrianRouteManager routeManager;
  var defaultPoint = Point(latitude: 56.837716, longitude: 60.596828); // убрать с костылём зума на екб

  @override
  void initState() {
    super.initState();

    setState(() {
      routeManager = PedestrianRouteManager();
    });

    _listener = () {
      if (mounted) setState(() {});
    };
    tappedMarker.addListener(_listener!);
    showRouteNum.addListener(_listener!);

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      final userPoint = Point(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (userLocationPlacemark != null) {
        setState(() {
          userLocationPlacemark!.geometry = userPoint;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionStream.cancel();
    tappedMarker.removeListener(_listener!);
    showRouteNum.removeListener(_listener!);
    routeManager.cancelAllSessions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final windowWidth = MediaQuery.of(context).size.height;
  return MaterialApp(
    theme: Theme.of(context),
    home: Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (mapWindow) async {
              mapWindow_ = mapWindow;
              mapWindow.map.setMapStyle(await readJsonFile("assets/style/style_map.json"));
              // Костыль, чтобы пока позиция пользователя загружалась, карта заранее смотрела на Екатеринбург, а не на весь мир
              mapWindow_!.map.move(CameraPosition(defaultPoint, zoom: 12.5, azimuth: 0.0, tilt: 30.0));
              mapkit.onStart();
              if (userPosition == null){
                await makePoints(mapWindow_!);
              }
              await addUserLocationPlacemark();
              moveToUserLocation(mapWindow_);
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: 
            ElevatedButton(
              onPressed: () {
                moveToUserLocation(mapWindow_);
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              child: Icon(Icons.near_me),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 0,
            child: 
            // TextButton(
            //   onPressed: () async {
            //     await showNearPlace();
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: WidgetStatePropertyAll(Colors.white),
            //     shape: WidgetStateProperty.all(
            //     RoundedRectangleBorder(
            //       side: BorderSide(color: orangeColor, width: 2),
                  
            //       borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //   ),
            //   child: Text(
            //     "Ближайшее место",
            //     style: TextStyle(
            //       color: orangeColor,
            //     ),
            //   )
            // ),
            ElevatedButton(
              onPressed: () async {
                await showNearPlace();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                iconColor: Colors.white,
                shape: CircleBorder(),
                iconSize: 20,
              ),
              child: Icon(Icons.search),
            ),
          ),
          if (tappedMarker.value != null) 
            MarkerOverlay(
              marker: tappedMarker.value!,
              onClose: () {
                setState(
                () {
                    tappedMarker.value = null;
                  },
                );
              },
              onCreateRoot: () async {
                if (userLocationPlacemark != null){
                  await routeManager.buildRoute(
                    startPoint: Point(latitude: userLocationPlacemark!.geometry.latitude, longitude: userLocationPlacemark!.geometry.longitude),
                    endPoint: Point(latitude: tappedMarker.value!.latitude, longitude: tappedMarker.value!.longitude)
                  );

                  tappedMarker.value = null;
                  showRouteNum.value = 0;
                  routeManager.showRouteOnMap(showRouteNum.value!, mapWindow_!, windowWidth);
                }
                else {
                  throw "can't create root, because user location is not defined";
                }
              },
              moreInfoFunc: () {
                openMoreInfo(context, tappedMarker.value!);
              },
            ),
          if (showRouteNum.value != null)
            RouteOverlay(
              routesData: routeManager.pedestrianRoutes,
              func: (int index) {
                showRouteNum.value = index;
                routeManager.showRouteOnMap(index, mapWindow_!, windowWidth);
              },
              onClose: () {
                setState(
                  () {
                    showRouteNum.value = null;
                    routeManager.cancelAllSessions();
                  }
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}