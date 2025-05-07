import 'dart:async';

import 'package:flutter/material.dart' as fl_material;
import 'package:geolocator/geolocator.dart';

import 'package:my_mystery_city/views/map_page.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/listeners/map_object_tap_listener.dart';
import 'package:my_mystery_city/listeners/cluster_listener.dart';

import 'package:yandex_maps_mapkit/mapkit.dart' hide LocationSettings;
import 'package:yandex_maps_mapkit/image.dart' as image_provider;


Position? lastPosition;
Position? userPosition;
PlacemarkMapObject? placemark;
PlacemarkMapObject? userLocationPlacemark;
// List<PlacemarkMapObject>? placemarksCache;
ClusterizedPlacemarkCollection? markerCollections;
MarkerMap? tappedMarker;

final MapObjectTapListenerImpl tabMarkerListener = MapObjectTapListenerImpl(onMapObjectTapped:
  (mapObject , point ) {
    if (mapObject is PlacemarkMapObject) {
      getMarkerMap(mapObject.geometry.latitude, mapObject.geometry.longitude).then((marker) {
        tappedMarker = marker;
        continueLogic();
      });  
    }
    return true;
  }
);
final clusterListener = ClusterListenerImpl();

final unknownMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/unknown_marker.png")); 
final monumentMarker =  image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/monument_marker.png")); // 1
final intrestPlaceMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/intresting_place_marker.png")); // 2
final startRouteMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/start_route_marker.png"));

void continueLogic() {
  if (tappedMarker != null && userLocationPlacemark != null && tappedMarker!.isChecked == 0 && (userLocationPlacemark!.geometry.latitude - tappedMarker!.latitude).abs() < 0.001 && (userLocationPlacemark!.geometry.longitude - tappedMarker!.longitude).abs() < 0.001) {
        // removeUnknownPoint(tappedMarker!);
        tappedMarker!.isChecked = 1;
        updateMarkerMapExploreStatus(tappedMarker!);
        // addPoint(tappedMarker!);
      }
}

Future<Position?> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Проверка, включен ли GPS
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
    // return Future.error('Location services are disabled.');
  }

  // Проверка разрешений
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
      // return Future.error('Location permissions are denied.');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return null;
    // return Future.error('Location permissions are permanently denied.');
  } 

  // Получение текущей позиции
  return await Geolocator.getCurrentPosition();
}

Future<void> addUserLocationPlacemark() async {
  final imageProvider = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/icons/user_location.png"));
  
  var userPosition = await _determinePosition(); 
  if (userPosition != null) {
    userLocationPlacemark = mapWindow_!.map.mapObjects.addPlacemark();
    userLocationPlacemark!.geometry = Point(latitude: userPosition.latitude, longitude: userPosition.longitude);
    userLocationPlacemark!.setIcon(imageProvider);
  }
}

StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0,
  ),
).listen((Position position) {
  final userPoint = Point(
    latitude: position.latitude,
    longitude: position.longitude,
  );

  // Обновить метку пользователя на карте
  if (userLocationPlacemark != null){
    userLocationPlacemark?.geometry = userPoint;
  }
});

void moveToUserLocation(MapWindow? mapWindow_) async
{ 
  if (mapWindow_ != null)
  { 
    if (userLocationPlacemark == null){
      // TO DO выводить виджет о необходимости включить местоположение 
    }
    else {
      var targetPoint = userLocationPlacemark!.geometry;
      mapWindow_.map.moveWithAnimation(
        CameraPosition(targetPoint, zoom: 15, azimuth: 0.0, tilt: 30.0),
        Animation(
          AnimationType.Smooth,
          duration: 0.5,
        )
      );
    }
  }
}

void removeUnknownPoint(MarkerMap marker) {
  // markerCollections!.remove();
}

void addPoint(MarkerMap marker) {
  image_provider.ImageProvider? img;

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
      markerCollections!.addPlacemarkWithImage(Point(latitude: marker.latitude, longitude: marker.longitude), img!);
}

Future<void> makePoints(MapWindow mapWindow_) async {
    markerCollections =  mapWindow_.map.mapObjects.addClusterizedPlacemarkCollection(clusterListener);
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
      // _placemarksCache[id] = placemark;
      markerCollections!.addPlacemarkWithImage(Point(latitude: marker.latitude, longitude: marker.longitude), img!);
    }
    markerCollections!.addTapListener(tabMarkerListener);
    markerCollections!.clusterPlacemarks(clusterRadius: 60.0, minZoom: 15);
}