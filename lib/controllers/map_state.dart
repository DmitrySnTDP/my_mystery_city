import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart' as fl_material ;
import 'package:flutter/widgets.dart' hide Animation;
import 'package:geolocator/geolocator.dart';
import 'package:my_mystery_city/controllers/root_creater.dart';
import 'package:my_mystery_city/controllers/search_nearest_place.dart';
import 'package:my_mystery_city/views/home_page.dart';

import 'package:my_mystery_city/views/map_page.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/listeners/map_object_tap_listener.dart';
import 'package:my_mystery_city/listeners/cluster_listener.dart';

import 'package:yandex_maps_mapkit/mapkit.dart' hide LocationSettings;
import 'package:yandex_maps_mapkit/image.dart' as image_provider;


var errorGeoWidgetCheck = false;
var createRouteErrorWidgetCheck = false;
var firsTapGeo = false;
var firstTapNear = false;
late List<MarkerMap> markersMap;

Future<List<MarkerMap>> getMarkerForMap() async {
  return markersMap = await getData();
}

Position? userPosition;
PlacemarkMapObject? userLocationPlacemark;
ClusterizedPlacemarkCollection? markerCollections;
// final fl_material.ValueNotifier<Position?> userLocation = fl_material.ValueNotifier(null);
final fl_material.ValueNotifier<MarkerMap?> tappedMarker = fl_material.ValueNotifier(null);
final fl_material.ValueNotifier<int?> showRouteNum = fl_material.ValueNotifier(null);
final fl_material.ValueNotifier<bool> showMoreInfoCheck = fl_material.ValueNotifier(false);
final fl_material.ValueNotifier<PedestrianRouteManager?> showOtherRoutePage = fl_material.ValueNotifier(null);

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
      removePoints();
      tappedMarker.value!.isChecked = 1;
      updateMarkerMapExploreStatus(tappedMarker.value!);
      // getMarkerForMap().then (
        // (_) async {
          makePoints(mapWindow_!, markersMap);
        // }
      // );
      
    }
  }
  
}

Future<Position?> determinePosition() async {
  // Проверка, включен ли GPS
  if (!await checkEnableGeo()) {
    return null;
  }
  // Проверка разрешений
  if (!await checkPermissionGeo()){
    return null;
  }
  // Получение текущей позиции
  return await Geolocator.getCurrentPosition();
}

Future<bool> checkPermissionGeo() async {
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    } 
    return true;
}

Future<bool> checkEnableGeo() async => await Geolocator.isLocationServiceEnabled();


Future<void> addUserLocationPlacemark() async {
  final imageProvider = image_provider.ImageProvider.fromImageProvider(const fl_material.AssetImage("assets/icons/user_location.png"));
  
  var userPosition = await determinePosition(); 
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

void moveToUserLocation(MapWindow mapWindow_, {bool start = false}) async
{ 
  if (userLocationPlacemark == null){
    if (!start) {
      errorGeoWidgetCheck = true;
    }
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

void removePoints() {
  // markerCollections!.removeTapListener(tabMarkerListener);
  markerCollections!.clear();
  // mapWindow_?.map.mapObjects.remove(markerCollections!);
}

void addPoint(MarkerMap marker) {
  final img = marker.isChecked == 0 ? markersImgs[0]: markersImgs[marker.typePoint.indexType];
  markerCollections!.addPlacemarkWithImage(Point(latitude: marker.latitude, longitude: marker.longitude), img);
}

Future<void> makePoints(MapWindow mapWindow_, List<MarkerMap> markers) async {
    markerCollections = mapWindow_.map.mapObjects.addClusterizedPlacemarkCollection(clusterListener);
    // markerCollections = mapWindow_.map.mapObjects.addCollection();
    markerCollections!.addTapListener(tabMarkerListener);
    final dbData = await getData();
    
    for (final marker in dbData) {
      addPoint(marker);
    }
    
    markerCollections!.clusterPlacemarks(clusterRadius: 40.0, minZoom: 15);
}

Future<void> showNearPlace(MapWindow mapWindow) async {
  const double radiusSearch = 2000; //радиус поиска в метрах
  MarkerMap? nearPoint;
  if (userLocationPlacemark == null) {
    errorGeoWidgetCheck = true;
  }
  else {
    nearPoint = await getNearPointInRadius(
      radiusSearch, 
      Point(
        latitude: userLocationPlacemark!.geometry.latitude,
        longitude: userLocationPlacemark!.geometry.longitude,
      )
    );
  }
  if (nearPoint != null) {
    tappedMarker.value = nearPoint;
    mapWindow.map.moveWithAnimation(
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

void moveToTappedMarker() {
  if (mapWindow_ != null) {
    mapWindow_!.map.moveWithAnimation(
      CameraPosition(
        Point(latitude: tappedMarker.value!.latitude, longitude:  tappedMarker.value!.longitude),
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


Future<PedestrianRouteManager> createRouteFromMarkers(List<MarkerMap> markers) async {
  final routeManager = PedestrianRouteManager();  
  List<RequestPoint> requestPoints = [
    RequestPoint(
      Point(latitude: markers[1].latitude, longitude: markers[1].longitude), 
      RequestPointType.Waypoint, 
      null, null, null,
    ),
    RequestPoint(
      Point(latitude: markers[markers.length - 2].latitude, longitude: markers[markers.length - 2].longitude), 
      RequestPointType.Waypoint, 
      null, null, null,
    ),
  ];
  // await addUserLocationPlacemark();
  // await determinePosition();
  // if (userLocation.value != null) {
  //   requestPoints.add(
  //     RequestPoint(
  //       Point(latitude: userLocation.value!.latitude, longitude: userLocation.value!.longitude), 
  //       RequestPointType.Waypoint, 
  //       null, null, null,
  //     )
  //   );
  // }

  // for (final marker in markers) {
  //   var typePoint = RequestPointType.Waypoint;
  //   // if (marker == markers.first) {
  //   //   typePoint = RequestPointType.Waypoint;
  //   // }
  //   requestPoints.add(
  //     RequestPoint(
  //       Point(latitude: marker.latitude, longitude: marker.longitude), 
  //       typePoint, 
  //       null, null, null,
  //     ),
  //   );
  // }

  
  // if (requestPoints.length >= 2 && requestPoints.length < 13) {
  //   requestPoints.add(RequestPoint(
  //     Point(latitude: markers.first.latitude, longitude: markers.first.longitude), 
  //     RequestPointType.Waypoint, 
  //     null, null, null,
  //   ));
  // }
  // if (requestPoints.where((point) {return point.type == RequestPointType.Waypoint;}).length >= 2 && requestPoints.length < 13) {
    await routeManager.buildRoute(requestPoints: requestPoints);
  // }
  return routeManager;
}

Future<void> showRouteFromPage(PedestrianRouteManager routeManager, List<MarkerMap> markers, BuildContext context, double height) async {
  selectedIndex.value = 1;
  showOtherRoutePage.value = routeManager;
  
  
  if (mapWindow_ != null) {
    markersMap = markers;
    removePoints();
    // await makePoints(mapWindow_!, markersMap);
    await routeManager.showRouteOnMap(0, mapWindow_!, height);
  }
}

Future<void> hideRouteFromPage(MapWindow mapWindow, PedestrianRouteManager routeManager) async {
  routeManager.cancelAllSessions();
  removePoints();
  await makePoints(mapWindow, markersMap);
}