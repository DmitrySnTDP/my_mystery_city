import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:my_mystery_city/controllers/map_state.dart';
import 'package:my_mystery_city/data/reader_json.dart';
import 'package:my_mystery_city/views/point_window_on_map.dart';

import 'package:yandex_maps_mapkit/mapkit.dart' hide LocationSettings;
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
  var defaultPoint = Point(latitude: 56.837716, longitude: 60.596828); // убрать с костылём зума на екб

  // Обновление метки пользователя
  @override
  void initState() {
    super.initState();

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
    _positionStream.cancel(); // Остановить поток при закрытии виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    theme: Theme.of(context),
    home: Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (mapWindow) async {
              mapWindow_ = mapWindow;
              mapWindow.map.setMapStyle(await readJsonFile("assets/style/style_map.json"));
              if (userPosition == null){
                await makePoints(mapWindow_!);
              }
              // Костыль, чтобы пока позиция пользователя загружалась, карта заранее смотрела на Екатеринбург, а не на весь мир
              mapWindow_!.map.move(CameraPosition(defaultPoint, zoom: 12.5, azimuth: 0.0, tilt: 30.0));
              await addUserLocationPlacemark();
              moveToUserLocation(mapWindow_);
              mapkit.onStart();
            },
          ),
          Positioned(
            bottom: 50,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                moveToUserLocation(mapWindow_);
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              child: Icon(Icons.near_me),
            ),
          ),
          if (tappedMarker != null)
            MarkerOverlay(marker: tappedMarker!),
        ],
      ),
    ),
  );
}
}