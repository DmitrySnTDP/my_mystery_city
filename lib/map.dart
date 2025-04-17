import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

Position? lastPosition;
Position? position;
MapWindow? mapWindow_;

Future<Position?> determinePosition() async {
  if (await Permission.location.request().isGranted) {
    return await Geolocator.getCurrentPosition();
  }
  return null;
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Future<void> _moveToUserLocation() async
  { 
    if (mapWindow_ != null)
    { 
      var targetPoint = Point(latitude: 56.837716, longitude: 60.596828);
      if (position == null && lastPosition == null){
        mapWindow_!.map.move(CameraPosition(targetPoint, zoom: 15, azimuth: 0.0, tilt: 30.0));
        position = await determinePosition(); 
      }
      if (position != null) {
        targetPoint = Point(latitude: position!.latitude, longitude: position!.longitude);
        lastPosition = position;
      }
      else if (lastPosition != null) {
        targetPoint = Point(latitude: lastPosition!.latitude, longitude: lastPosition!.longitude);
      }
      mapWindow_!.map.move(CameraPosition(targetPoint, zoom: 15, azimuth: 0.0, tilt: 30.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: YandexMap(
          onMapCreated: (mapWindow) async
          {
            mapWindow_ = mapWindow;
            await _moveToUserLocation();
            mapkit.onStart();
          }
        )
      )
    );
  }
}