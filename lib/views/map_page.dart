import 'package:flutter/material.dart' ;
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:my_mystery_city/controllers/map_state.dart';
import 'package:my_mystery_city/controllers/root_creater.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/data/reader_json.dart';
import 'package:my_mystery_city/main.dart';
import 'package:my_mystery_city/views/point_window_on_map.dart';
import 'package:my_mystery_city/views/route_variables_window.dart';
import 'package:my_mystery_city/views/help_widgets.dart';

import 'package:yandex_maps_mapkit/mapkit.dart' hide LocationSettings, TextStyle;
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';


StreamSubscription<Position>? _positionStream;

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
  int? lastRouteNumValue; 

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

    checkEnableGeo().then(
      (checkResult) {
        if (checkResult) {
          _positionStream = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 0,
            ),
          ).listen(
            (Position position) {
              final userPoint = Point(
                latitude: position.latitude,
                longitude: position.longitude,
              );
              if (userLocationPlacemark != null) {
                setState(
                  () {
                    userLocationPlacemark!.geometry = userPoint;
                  }
                );
              }
            }
          );
        }
      }
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    tappedMarker.removeListener(_listener!);
    showRouteNum.removeListener(_listener!);
    routeManager.cancelAllSessions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final windowWidth = MediaQuery.of(context).size.height;

  if (showRouteNum.value != lastRouteNumValue) {
    if (showRouteNum.value == null) {
      routeManager.cancelAllSessions();
    }
    lastRouteNumValue = showRouteNum.value;
  }

  var extraHeightButtons = 0.0;
  if (tappedMarker.value != null) {
    if (tappedMarker.value!.isChecked == 1) {
      extraHeightButtons = MediaQuery.of(context).size.height - 325;
    }
    else {
      extraHeightButtons = MediaQuery.of(context).size.height * 0.3;
    }
  }
  else if (showRouteNum.value != null) {
    extraHeightButtons = 180;
  }

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
              if (tappedMarker.value == null) {
                moveToUserLocation(mapWindow_!, start: true);
              }
              else {
                moveToTappedMarker();
              }
            },
          ),
          if (firsTapGeo)
            startHelpWidget(
              "Нажмите чтобы увидеть своё местоположение", 
              bottomPos: 25 + extraHeightButtons,
            ),
          if (firstTapNear)
          startHelpWidget(
            "Нажмите чтобы увидеть ближайшее неизведанное место", 
            bottomPos: 75 + extraHeightButtons,
          ),
          if (errorGeoWidgetCheck)
            errorHelpWidget(
              "Функция недоступна из-за отстутствия информации о вашем местоположении.",
              height: 100,
              bottomPos: 25 + extraHeightButtons,
              buttonFunc: () {
                setState(
                  () {
                    errorGeoWidgetCheck = false;
                  }
                );
              }
            ),
          if (createRouteErrorWidgetCheck)
            errorHelpWidget(
              "Невозможно построить маршрут, из-за отсутствия информации о вашем местоположении.",
              height: 100,
              bottomPos: 25 + extraHeightButtons,
              buttonFunc: () {
                setState(
                  () {
                    createRouteErrorWidgetCheck = false;
                  }
                );
              }
            ),
          Positioned(
            bottom: 25 + extraHeightButtons,
            right: 0,
            child: 
            ElevatedButton(
              onPressed: () {
                setState(() {
                  moveToUserLocation(mapWindow_!);
                  if (firsTapGeo) {
                      firsTapGeo = false;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              child: Icon(Icons.near_me),
            ),
          ),
          Positioned(
            bottom: 75 + extraHeightButtons,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (firstTapNear) {
                      firstTapNear = false;
                      firsTapGeo = true;
                  }
                  showNearPlace(mapWindow_!).then((_) {});
                });
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
                  setState(() {
                    createRouteErrorWidgetCheck = true;
                  });
                }
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