import 'dart:async';
import 'dart:math' as fl_math;

import 'package:flutter/material.dart' as fl_material;
import 'package:yandex_maps_mapkit/mapkit.dart' ;
import 'package:yandex_maps_mapkit/runtime.dart';
import 'package:yandex_maps_mapkit/transport.dart';

class PedestrianRouteManager {
  List<MasstransitRoute> pedestrianRoutes = [];
  MapObjectCollection? routesCollection;
  late Point startRoutePoint;
  late Point endRoutePoint;
  

  MasstransitSession? pedestrianSession;
  final PedestrianRouter pedestrianRouter = TransportFactory.instance.createPedestrianRouter();
  

  Future<void> buildRoute({
    required List<RequestPoint> requestPoints,
  }) async {

    startRoutePoint = requestPoints.first.point;
    endRoutePoint = requestPoints.last.point;

    final completer = Completer<void>();

    late final pedestrianRouteListener = RouteHandler(
      onMasstransitRoutes: (newRoutes) async {
        if (newRoutes.isEmpty) {
          completer.completeError("Can't build a route");
        }
        else {
          pedestrianRoutes = newRoutes;
          completer.complete();
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

    return completer.future;
  }


  Future<void> showRouteOnMap(int routeNum, MapWindow mapWindow, double width) async {
    routesCollection ??= mapWindow.map.mapObjects.addCollection();
    if (pedestrianRoutes.isEmpty) {
      throw "route swoving error: count route < 1";
    }

    routesCollection?.clear();
    routesCollection!.addPolylineWithGeometry(pedestrianRoutes[routeNum].geometry)..zIndex = 5.0..setStrokeColor(fl_material.Color.fromRGBO(244, 162, 89, 1));
    _moveCameraToRoute(pedestrianRoutes[routeNum], mapWindow, width);

  }

  void _moveCameraToRoute(MasstransitRoute route, MapWindow mapWindow, double width) {
    final maxDiff= fl_math.max(
          (startRoutePoint.latitude - endRoutePoint.latitude).abs() / 90 * 500,
          (startRoutePoint.longitude - endRoutePoint.longitude).abs() / 180 * 500);
    final zoom = fl_math.log(width / maxDiff) / fl_math.ln2;
    mapWindow.map.moveWithAnimation(
      CameraPosition(
        Point(
          latitude: (startRoutePoint.latitude + endRoutePoint.latitude) / 2,
          longitude: (startRoutePoint.longitude + endRoutePoint.longitude) / 2
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
    pedestrianSession?.cancel();
    pedestrianRoutes = [];
    routesCollection?.clear();
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