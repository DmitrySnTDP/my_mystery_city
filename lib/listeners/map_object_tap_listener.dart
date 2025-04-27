import 'package:yandex_maps_mapkit/mapkit.dart';

final class MapObjectTapListenerImpl implements MapObjectTapListener {
  // final bool Function(MapObject, Point) onMapObjectTapped;

  // const MapObjectTapListenerImpl({required this.onMapObjectTapped});

  @override
  bool onMapObjectTap(MapObject mapObject, Point point) {
    print("Tapped the placemark: Point(latitude: ${point.latitude}, longitude: ${point.longitude})");
    return true;
    // return onMapObjectTapped(mapObject, point);
  }
}