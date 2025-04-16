import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> determinePosition() async {
  if (await Permission.location.request().isGranted) {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } else {
    return null;
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  // ignore: unused_field, override_on_non_overriding_member
  MapWindow? _mapWindow;
  
  Future<void> _moveToUserLocation() async
  {
    final position = await determinePosition();
    if (position != null && _mapWindow != null)
    {
      final targetPoint = Point(latitude: position.latitude, longitude: position.longitude);
      _mapWindow!.map.move(CameraPosition(targetPoint, zoom: 15, azimuth: 150.0, tilt: 30.0));
    }
  }

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: YandexMap(
          onMapCreated: (mapWindow) async
          {
            _mapWindow = mapWindow;
            await _moveToUserLocation();
            mapkit.onStart();
          }
        )
      )
    );
  }
}