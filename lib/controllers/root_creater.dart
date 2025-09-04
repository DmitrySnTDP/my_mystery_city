import 'dart:async';
import 'dart:math' as fl_math;

import 'package:flutter/material.dart' as fl_material;
import 'package:yandex_maps_mapkit/mapkit.dart' hide Map;
import 'package:yandex_maps_mapkit/runtime.dart';
import 'package:yandex_maps_mapkit/transport.dart';

class PedestrianRouteManager {
  // List<MasstransitRoute> pedestrianRoutes = [];
  MapObjectCollection? routesCollection;
  // late Point startRoutePoint;
  // late Point endRoutePoint;
  late Map<double, RouteInfo> routesInfo = {};
  

  MasstransitSession? pedestrianSession;
  final PedestrianRouter pedestrianRouter = TransportFactory.instance.createPedestrianRouter();
  

  Future<double> buildRoute({
    required List<RequestPoint> requestPoints,
  }) async {
    final routeInfo = RouteInfo(requestPoints.first.point, requestPoints.last.point);
    final routeId = (requestPoints.first.point.latitude + requestPoints.first.point.latitude * 193) * 3571
      + requestPoints.last.point.latitude + requestPoints.last.point.latitude * 353;

    final completer = Completer<double>();

    late final pedestrianRouteListener = RouteHandler(
      onMasstransitRoutes: (newRoutes) async {
        if (newRoutes.isEmpty) {
          completer.completeError("Can't build a route");
        }
        else {
          routeInfo.pedestrianRoutes = newRoutes;
          completer.complete(routeId);
        }
      },
      onMasstransitRoutesError: (error) {
        switch (error) {
          case final NetworkError _:
            completer.completeError("Pedestrian routes request error due network issue");
          default:
            completer.completeError("Pedestrian routes request unknown error");
        }
      },
    );
    
    _requestPedestrianRoutes(requestPoints, pedestrianRouteListener);
    routesInfo[routeId] = routeInfo;
    return completer.future;
  }


  void showRouteOnMap(double routeId, int routeNum, {double width = 0, MapWindow? mapWindow})  {
    if (routesInfo.containsKey(routeId)) {
      // routesCollection ??= mapWindow.map.mapObjects.addCollection();
      if (routesInfo[routeId]!.pedestrianRoutes.isEmpty) {
        throw "route swoving error: count route < 1";
      }

      // routesCollection?.clear();
      routesCollection!.addPolylineWithGeometry(routesInfo[routeId]!.pedestrianRoutes[routeNum].geometry)..zIndex = 5.0..setStrokeColor(fl_material.Color.fromRGBO(244, 162, 89, 1));
      if (mapWindow != null) {
        _moveCameraToRoute(routesInfo[routeId]!.startRoutePoint, routesInfo[routeId]!.endRoutePoint, routesInfo[routeId]!.pedestrianRoutes[routeNum], mapWindow, width);
      }
    }
  }

  void _moveCameraToRoute(Point start, Point end, MasstransitRoute route, MapWindow mapWindow, double width) {
    final maxDiff = fl_math.max(
      (start.latitude - end.latitude).abs() / 90 * 500,
      (start.longitude - end.longitude).abs() / 180 * 500
    );
    final zoom = fl_math.log(width / maxDiff) / fl_math.ln2;
    mapWindow.map.moveWithAnimation(
      CameraPosition(
        Point(
          latitude: (start.latitude + end.latitude) / 2,
          longitude: (start.longitude + end.longitude) / 2
        ),
        zoom: zoom,
        azimuth: 0.0,
        tilt: 30.0
      ),
      Animation(
        AnimationType.Smooth,
        duration: 0.5,
      )
    );
    
    mapWindow.map.cameraPositionForGeometry(Geometry.fromPolyline(route.geometry));
  }

  void cancelAllSessions() {
    routesInfo.clear();
    // pedestrianSession?.cancel();
    // pedestrianRoutes = [];
    routesCollection?.clear();
  }

  void cancelRoute(double routeId) {
    routesInfo.remove(routeId);
  }

  void _requestPedestrianRoutes(List<RequestPoint> points, RouteHandler pedestrianRouteListener) {
    var timeOptions = TimeOptions();
    const routeOptions = RouteOptions(FitnessOptions(avoidSteep: false));

    pedestrianSession = pedestrianRouter.requestRoutes(
      timeOptions,
      routeOptions,
      pedestrianRouteListener,
      points: points,
    );
  }
}

class RouteInfo {
  var _pedestrianRoutes = <MasstransitRoute>[];
  // MapObjectCollection? routesCollection;
  final Point startRoutePoint;
  final Point endRoutePoint;
  late final double timeRoute;
  late final double lengthRoute;

  
  RouteInfo(this.startRoutePoint, this.endRoutePoint);

  List<MasstransitRoute> get pedestrianRoutes => _pedestrianRoutes;

  set pedestrianRoutes(List<MasstransitRoute> newValue) {
    _pedestrianRoutes = newValue;
    timeRoute = _pedestrianRoutes.first.metadata.weight.time.value;
    lengthRoute = pedestrianRoutes.first.metadata.weight.walkingDistance.value;
  }
}