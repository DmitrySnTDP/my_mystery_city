import 'package:flutter/material.dart' hide Animation;
import 'package:flutter/services.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/image.dart' as image_provider;
import 'package:yandex_maps_mapkit/yandex_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'db_worker.dart';

Position? lastPosition;
Position? userPosition;
MapWindow? mapWindow_;
PlacemarkMapObject? placemark;
MapObjectCollection? mapObjectCollection;
final unknownMarker = image_provider.ImageProvider.fromImageProvider(const AssetImage("assets/images/unknown_marker.png")); 
final monumentMarker =  image_provider.ImageProvider.fromImageProvider(const AssetImage("assets/images/monument_marker.png")); // 1
final intrestPlaceMarker = image_provider.ImageProvider.fromImageProvider(const AssetImage("assets/images/intresting_place_marker.png")); // 2
final startRouteMarker = image_provider.ImageProvider.fromImageProvider(const AssetImage("assets/images/start_route_marker.png"));

Future<Position?> determinePosition() async {
  if (await Permission.location.request().isGranted) {
    return await Geolocator.getCurrentPosition();
  }
  return null;
}

Future<String> _readJsonFile(String filePath)  {
  return rootBundle.loadString(filePath);
}

final class MapObjectTapListenerImpl implements MapObjectTapListener {

  @override
  bool onMapObjectTap(MapObject mapObject, Point point) {
    print("Tapped the placemark: Point(latitude: ${point.latitude}, longitude: ${point.longitude})");
    return true;
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final listener = MapObjectTapListenerImpl();

  Future<void> _makePoints() async {
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

  Future<void> _moveToUserLocation() async
  { 
    if (mapWindow_ != null)
    { 
      var targetPoint = Point(latitude: 56.837716, longitude: 60.596828);
      if (userPosition == null && lastPosition == null){
        mapWindow_!.map.move(CameraPosition(targetPoint, zoom: 15, azimuth: 0.0, tilt: 30.0));
      }
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

  var defaultPoint = Point(latitude: 56.837716, longitude: 60.596828);

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    theme: Theme.of(context),
    home: Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (mapWindow) async {
              mapWindow_ = mapWindow;
              mapWindow.map.setMapStyle(await _readJsonFile("assets/style/style_map.json"));
              await _makePoints();

              // Костыль, чтобы пока позиция пользователя загружалась, карта заранее смотрела на Екатеринбург, а не на весь мир
              mapWindow_!.map.move(CameraPosition(defaultPoint, zoom: 15, azimuth: 0.0, tilt: 30.0));

              await _moveToUserLocation();
              mapkit.onStart();
            },
          ),
          Positioned(
            bottom: 50,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                _moveToUserLocation();
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              child: Icon(Icons.near_me),
            ),
          ),
        ],
      ),
    ),
  );
}
}