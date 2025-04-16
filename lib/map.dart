import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  // ignore: unused_field, override_on_non_overriding_member
  MapWindow? _mapWindow;
  
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: YandexMap(
          onMapCreated: (mapWindow)
          {
            _mapWindow = mapWindow;
            mapWindow.map.move(
              CameraPosition(Point(latitude: 56.8519, longitude: 60.6122), zoom: 12.5, azimuth: 150.0, tilt: 30.0)
            );
            mapkit.onStart();
          }
        )
      )
    );
  }
}