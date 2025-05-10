import 'dart:async';
import 'dart:core';
import 'dart:core' as dart_core;

import 'package:flutter/material.dart' as fl_material;
import 'package:geolocator/geolocator.dart';

import 'package:my_mystery_city/views/map_page.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/listeners/map_object_tap_listener.dart';
import 'package:my_mystery_city/listeners/cluster_listener.dart';

import 'package:yandex_maps_mapkit/mapkit.dart' hide LocationSettings;
import 'package:yandex_maps_mapkit/image.dart' as image_provider;

// List<List<Point>> markersLists = [List.];
// List<List<MarkerMap>> markersCache = List.empty();
// List<Point> monumentsMaprekers = List.empty(growable: true);
// List<Point> unknownPlacesMarkers = List.empty(growable: true);
// List<Point> intrestPlaceMarkers = List.empty(growable: true);

Position? userPosition;
PlacemarkMapObject? userLocationPlacemark;
// PlacemarkMapObject? placemark;
// final dart_core.Map<MarkerMap, int> markerCache = {};
ClusterizedPlacemarkCollection? markerCollections;
final fl_material.ValueNotifier<MarkerMap?> tappedMarker = fl_material.ValueNotifier(null);

final MapObjectTapListenerImpl tabMarkerListener = MapObjectTapListenerImpl(onMapObjectTapped:
  (mapObject , point ) {
    if (mapObject is PlacemarkMapObject) {
      getMarkerMap(mapObject.geometry.latitude, mapObject.geometry.longitude).then((marker) {
        tappedMarker.value = marker;
      continueLogic();
      });  
    }
    return true;
  }
);

final clusterListener = ClusterListenerImpl();

final unknownMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/unknown_marker.png")); // 0
final monumentMarker =  image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/monument_marker.png")); // 1
final intrestPlaceMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/intresting_place_marker.png")); // 2
final startRouteMarker = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/images/start_route_marker.png"));

void continueLogic() {
  if (tappedMarker.value != null && tappedMarker.value!.isChecked == 0) {
    if (userLocationPlacemark != null && (userLocationPlacemark!.geometry.latitude - tappedMarker.value!.latitude).abs() < 0.001
      && (userLocationPlacemark!.geometry.longitude - tappedMarker.value!.longitude).abs() < 0.001) {
      removeUnknownPoint(tappedMarker.value!);
      tappedMarker.value!.isChecked = 1;
      updateMarkerMapExploreStatus(tappedMarker.value!);
      // addPoint(tappedMarker.value!);
      makePoints(mapWindow_!);
    }
  }
  
}

Future<Position?> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Проверка, включен ли GPS
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // Проверка разрешений
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return null;
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
  // var index = markerCache[marker];
  // if (index != null) {
    // unknownPlacesMarkers.removeAt(index);
    // markerCache.remove(marker);

  // }
  markerCollections!.clear();
}

void addPoint(MarkerMap marker) {
  image_provider.ImageProvider? img;

  if (marker.isChecked == 0){
        img = unknownMarker;
        // markersLists[0].add(Point(latitude: marker.latitude, longitude: marker.longitude));
        // unknownPlacesMarkers.add(Point(latitude: marker.latitude, longitude: marker.longitude));
      }
      else {
        switch(marker.typePoint){
          case(1):
            // markersLists[1].add(Point(latitude: marker.latitude, longitude: marker.longitude));
            // monumentsMaprekers.add(Point(latitude: marker.latitude, longitude: marker.longitude));
            img = monumentMarker;
            break;
          case(2):
            // markersLists[2].add(Point(latitude: marker.latitude, longitude: marker.longitude));
            
            // intrestPlaceMarkers.add(Point(latitude: marker.latitude, longitude: marker.longitude));
            img = intrestPlaceMarker;
            break;
        }
      }
      markerCollections!.addPlacemarkWithImage(Point(latitude: marker.latitude, longitude: marker.longitude), img!);
}

Future<void> makePoints(MapWindow mapWindow_) async {
    // if (unknownPlacesMarkers.isEmpty) {
      markerCollections =  mapWindow_.map.mapObjects.addClusterizedPlacemarkCollection(clusterListener);
      final dbData = await getData();

      for (final marker in dbData) {
        addPoint(marker);
      // }
    }
    // final iconStyle0 = IconStyle(anchor: null, rotationType: RotationType.NoRotation, zIndex: 1, visible: true, scale: 1.0, tappableArea: null);
    // final iconStyle1 = IconStyle(anchor: null, rotationType: RotationType.NoRotation, zIndex: 2, visible: true, scale: 1.0, tappableArea: null);
    // final iconStyle2 = IconStyle(anchor: null, rotationType: RotationType.NoRotation, zIndex: 3, visible: true, scale: 1.0, tappableArea: null);
    // markerCollections!.addPlacemarkWithImageStyle(unknownMarker, iconStyle0, points: unknownPlacesMarkers);
    // markerCollections!.addPlacemarkWithImageStyle(monumentMarker, iconStyle1, points: monumentsMaprekers);
    // markerCollections!.addPlacemarkWithImageStyle(intrestPlaceMarker, iconStyle2, points: intrestPlaceMarkers);
    markerCollections!.addTapListener(tabMarkerListener);
    markerCollections!.clusterPlacemarks(clusterRadius: 60.0, minZoom: 15);
}