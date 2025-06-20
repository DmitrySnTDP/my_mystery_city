import 'package:my_mystery_city/data/reader_json.dart';
import 'package:my_mystery_city/enums/routes_enum.dart';
import 'package:my_mystery_city/enums/type_point_enum.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' as mapkit;


Database? database;
var firstTapNear = false;

Future<List<MarkerMap>> getData() async {
  await checkOpenDB();
  return await getMarkersMap();
}

class MarkerMap {
  final double latitude;
  final double longitude;
  final TypePoint typePoint;
  int isChecked;
  final String name;
  final String description;
  final String routeName;
  final List<String> imgLink;

  MarkerMap({
    required this.latitude,
    required this.longitude,
    required this.typePoint,
    required this.isChecked,
    required this.name,
    required this.description,
    required this.routeName,
    required this.imgLink
  });

  Map<String, Object?> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'type_point': typePoint.indexType,
      'is_checked': isChecked,
      'name': name,
      'description': description,
      'route_name': routeName,
      'img_link': imgLink.join(" ")
    };
  }

  factory MarkerMap.fromJson(Map<String, dynamic> json) {
    return MarkerMap(
      latitude: json["latitude"],
      longitude: json["longitude"],
      typePoint: getTypePointFromDB(json["type_point"]),
      isChecked: json["is_checked"],
      name: json["name"],
      description: json["description"], 
      routeName: json["route_name"],
      imgLink: json["img_link"].split(" "),
    );
  }
}

Future<void> checkDB() async {
  var path = join(await getDatabasesPath(), "assets/db/db_local.db");
  var exists = await databaseExists(path);

  if (!exists) {
    await createFillTable();
    firstTapNear = true;
  }
}

Future<void> checkOpenDB() async {
  database ??= await openDatabase(join(await getDatabasesPath(), "assets/db/db_local.db"));
}

Future<void> createFillTable() async {
  await createTable();
  await checkOpenDB();
  var markers = await readMarkersFromJson("assets/db/points.json");
  for (var marker in markers)
  {
    await insertMarker(marker);
  }
}

Future<void>createTable() async {
  // ignore: unused_local_variable
  var database_ = await openDatabase(join(await getDatabasesPath(), "assets/db/db_local.db"),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE markers_data (latitude REAL NOT NULL, longitude	REAL NOT NULL, type_point	INTEGER NOT NULL DEFAULT 1 CHECK(type_point >= 1 AND type_point <= 5), is_checked	BLOB NOT NULL, name	TEXT,	description	TEXT, route_name TEXT, img_link TEXT,	PRIMARY KEY(latitude, longitude))',
      );
    },
    version: 1,
  );
}

Future<List<MarkerMap>> getMarkersMap() async {
  await checkOpenDB();
  final db = database!;

  final List<Map<String, Object?>> markersMaps = await db.query('markers_data');

  return [
    for (final {'latitude': latitude as double,
      'longitude': longitude as double,
      'type_point': typePoint as int,
      'is_checked': isChecked as int,
      'name': name as String,
      'description': description as String,
      'route_name' : routeName as String,
      'img_link' : imgLink as String,
    } in markersMaps)
      
      MarkerMap(
        latitude: latitude,
        longitude: longitude,
        typePoint: getTypePointFromDB(typePoint),
        isChecked: isChecked,
        name: name,
        description: description,
        routeName: routeName, 
        imgLink: imgLink.split(" ")
      ),
  ];
}

Future<void> insertMarker(MarkerMap marker) async {
  await checkOpenDB();
  final db = database!;
  await db.insert(
    'markers_data',
    marker.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deleteMarkerMap(String name) async {
  await checkOpenDB();
  final db = database!;
  await db.delete(
    'markers_data',
    where: 'name = ?',
    whereArgs: [name],
  );
}

Future<void> updateMarkerMapExploreStatus(MarkerMap marker) async {
  await checkOpenDB();
  final db = database!;
  await db.update(
    'markers_data',
    {'is_checked': marker.isChecked},
    where: 'latitude = ? AND longitude = ?',
    whereArgs: [marker.latitude, marker.longitude],
  );
}

Future<List<MarkerMap>> getMarkerMapInRadius(mapkit.Point userPoint, double dLatitude, double dLongitude) async {
  await checkOpenDB();
  final db = database!;
  List<MarkerMap> markers = [];
  final markersData = await db.query(
    'markers_data',
    where: 'latitude > ? AND latitude < ? AND longitude > ? and longitude < ? AND is_checked = ?',
    whereArgs: [userPoint.latitude - dLatitude, userPoint.latitude + dLatitude, userPoint.longitude - dLongitude, userPoint.longitude + dLongitude, 0],
  );
  for (var data in markersData) {
    markers.add(MarkerMap.fromJson(data));
  }
  return markers;
}

Future<MarkerMap?> getMarkerMap(double latitude, double longitude) async {
  await checkOpenDB();
  final db = database!;
  final result = await db.query(
    'markers_data',
    where: 'latitude = ? AND longitude = ?',
    whereArgs: [latitude, longitude],
    limit: 1,
  );
  for (var markerData in result)
  {
    return MarkerMap.fromJson(markerData);
  }
  return null;
}

Future<List<MarkerMap>> getMarkersMapOnRoute(RouteType routeType) async {
  await checkOpenDB();
  final db = database!;
  List<MarkerMap> markers = [];
  final markersData = await db.query(
    'markers_data',
    where: 'route_name LIKE ?',
    whereArgs: ["%${routeType.identificator}%"],
  );
  for (var data in markersData) {
    markers.add(MarkerMap.fromJson(data));
  }
  return markers;
}

Future<List<MarkerMap>> getMarkersMapOnType(TypePoint type) async {
  await checkOpenDB();
  final db = database!;
  List<MarkerMap> markers = [];
  final markersData = await db.query(
    'markers_data',
    where: 'type_point = ?',
    whereArgs: [type.indexType],
  );
  for (var data in markersData) {
    markers.add(MarkerMap.fromJson(data));
  }
  return markers;
}


TypePoint getTypePointFromDB(int data) {
  switch (data){
    case(1):
      return TypePoint.intrestingPlace;
    case(2):
      return TypePoint.architecture;
    case(3):
      return TypePoint.nature;
    case(4):
      return TypePoint.monument;
    case(5): 
      return TypePoint.legends;
    default:
      return TypePoint.intrestingPlace;
  }
}

List<RouteType> getRouteNameFromDB(String data) {
  final dataList = data.split(", ");
  final List<RouteType> result = RouteType.values.where(
    (routeType) {
      return dataList.contains(routeType.identificator);
    }
  ).toList();

    return result;
}