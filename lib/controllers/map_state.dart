import 'package:flutter/material.dart' as fl_material;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/listeners/map_object_tap_listener.dart';

import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/image.dart' as image_provider;
// import 'package:yandex_maps_mapkit/yandex_map.dart';


Position? lastPosition;
Position? userPosition;
PlacemarkMapObject? placemark;
MapObjectCollection? mapObjectCollection;
final listener = MapObjectTapListenerImpl();

final unknownMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/unknown_marker.png")); 
final monumentMarker =  image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/monument_marker.png")); // 1
final intrestPlaceMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/intresting_place_marker.png")); // 2
final startRouteMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/start_route_marker.png"));


Future<Position?> determinePosition() async {
  if (await Permission.location.request().isGranted) {
    return await Geolocator.getCurrentPosition();
  }
  return null;
}

Future<void> moveToUserLocation(mapWindow_) async
{ 
  if (mapWindow_ != null)
  { 
    var targetPoint = Point(latitude: 56.837716, longitude: 60.596828);
    // if (userPosition == null || lastPosition == null){
    // mapWindow_!.map.move(CameraPosition(targetPoint, zoom: 15, azimuth: 0.0, tilt: 30.0));
    // }
    userPosition = await determinePosition(); 
    if (userPosition != null) {
      targetPoint = Point(latitude: userPosition!.latitude, longitude: userPosition!.longitude);
      lastPosition = userPosition;
    }
    else if (lastPosition != null) {
      targetPoint = Point(latitude: lastPosition!.latitude, longitude: lastPosition!.longitude);
    }
    mapWindow_!.map.moveWithAnimation(
      CameraPosition(targetPoint, zoom: 15, azimuth: 0.0, tilt: 30.0),
      Animation(
        AnimationType.Smooth,
        duration: 0.5,
      )
    );
  }
}

Future<void> makePoints(mapWindow_) async {
    var markerCollections =  mapWindow_!.map.mapObjects.addCollection();
    final dbData = await getData();
    image_provider.ImageProvider? img;

    for (final marker in dbData) {
      if (marker.isChecked == 0){
        img = unknownMarker;
      }
      else {
        switch(marker.typePoint){
          case(1):
            img = monumentMarker;
            break;
          case(2):
            img = intrestPlaceMarker;
            break;
        }
      }

      markerCollections.addPlacemarkWithImage(Point(latitude: marker.latitude, longitude: marker.longitude), img!);
      markerCollections.addTapListener(listener);
    }
  }