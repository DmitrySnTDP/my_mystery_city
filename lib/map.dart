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
            mapkit.onStart();
          }
        )
      )
    );
  }
}