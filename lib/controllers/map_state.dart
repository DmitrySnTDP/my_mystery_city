import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart' as fl_material;
import 'package:geolocator/geolocator.dart';
import 'package:my_mystery_city/controllers/search_nearest_place.dart';

import 'package:my_mystery_city/views/map_page.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/listeners/map_object_tap_listener.dart';
import 'package:my_mystery_city/listeners/cluster_listener.dart';

import 'package:yandex_maps_mapkit/mapkit.dart' hide LocationSettings;
import 'package:yandex_maps_mapkit/image.dart' as image_provider;


Position? userPosition;
PlacemarkMapObject? userLocationPlacemark;
ClusterizedPlacemarkCollection? markerCollections;
final fl_material.ValueNotifier<MarkerMap?> tappedMarker = fl_material.ValueNotifier(null);
final fl_material.ValueNotifier<int?> showRouteNum = fl_material.ValueNotifier(null);

final MapObjectTapListenerImpl tabMarkerListener = MapObjectTapListenerImpl(onMapObjectTapped:
  (mapObject , point ) {
    if (mapObject is PlacemarkMapObject) {
      getMarkerMap(mapObject.geometry.latitude, mapObject.geometry.longitude).then((marker) {
        tappedMarker.value = marker;
        showRouteNum.value = null;
      continueLogic();
      });  
    }
    return true;
  }
);

final clusterListener = ClusterListenerImpl();
// типы точек: 1 - без типа (по умолчанию), 2 - архитектура, 3 - природа, 4 - памятники, 5 - легенды и истории
const markersPaths = ["unknown.png", "intresting_place.png", "architect.png", "nature.png", "monument.png", "legends.png"];
final markersImgs = [
  for (var marker in markersPaths)
  image_provider.ImageProvider.fromImageProvider(fl_material.AssetImage("assets/icons/markers/$marker"))
];

void continueLogic() {
  if (tappedMarker.value != null && tappedMarker.value!.isChecked == 0) {
    if (userLocationPlacemark != null && (userLocationPlacemark!.geometry.latitude - tappedMarker.value!.latitude).abs() < 0.001
      && (userLocationPlacemark!.geometry.longitude - tappedMarker.value!.longitude).abs() < 0.001) {
      removeUnknownPoint(tappedMarker.value!);
      tappedMarker.value!.isChecked = 1;
      updateMarkerMapExploreStatus(tappedMarker.value!);
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
  markerCollections!.clear();
}

void addPoint(MarkerMap marker) {
  final img = marker.isChecked == 0 ? markersImgs[0]: markersImgs[marker.typePoint];
  markerCollections!.addPlacemarkWithImage(Point(latitude: marker.latitude, longitude: marker.longitude), img);
}

Future<void> makePoints(MapWindow mapWindow_) async {
    markerCollections =  mapWindow_.map.mapObjects.addClusterizedPlacemarkCollection(clusterListener);
    final dbData = await getData();

    for (final marker in dbData) {
      addPoint(marker);
    }
    markerCollections!.addTapListener(tabMarkerListener);
    markerCollections!.clusterPlacemarks(clusterRadius: 25.0, minZoom: 15);
}

Future<void> showNearPlace() async {
  const double radiusSearch = 2000; //радиус поиска в метрах
  final nearPoint = await getNearPointInRadius(
    radiusSearch, 
    Point(
      latitude: userLocationPlacemark!.geometry.latitude,
      longitude: userLocationPlacemark!.geometry.longitude,
    )
  );
  if (nearPoint != null) {
    tappedMarker.value = nearPoint;
    mapWindow_!.map.moveWithAnimation(
      CameraPosition(
        Point(latitude: nearPoint.latitude, longitude:  nearPoint.longitude),
        zoom: 16,
        azimuth: 0.0,
        tilt: 30.0
      ),
      Animation(
        AnimationType.Smooth,
        duration: 0.5,
      )
    );
  }
}