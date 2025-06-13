import 'dart:math';

import 'package:my_mystery_city/data/db_worker.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';


double metersToLatitudeDegrees(double meters) {
  return meters / 111320.0;
}

double metersToLongitudeDegrees(double meters, double latitude) {
  var latRad = latitude * (pi / 180.0);
  var lengthOfDegree = 111320.0 * cos(latRad);
  return meters / lengthOfDegree;
}


Future<MarkerMap?> getNearPointInRadius(double meters, Point userPosition) async {
  final dLatitude = metersToLatitudeDegrees(meters);
  final dLongitude = metersToLongitudeDegrees(meters, userPosition.latitude);
  final markers = await getMarkerMapInRadius(userPosition, dLatitude, dLongitude);
  double minDistance = 180;
  MarkerMap? nearestMarker; 
  for (var marker in markers) {
    final distance = sqrt(pow((userPosition.latitude - marker.latitude).abs(), 2) + pow((userPosition.longitude - marker.longitude).abs(), 2));
    if (distance < minDistance) {
      nearestMarker = marker;
      minDistance = distance;
    }
  }
  return nearestMarker;
}