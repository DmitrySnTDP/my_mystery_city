import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? database;

Future<List<MarkerMap>> getData() async {
  database = await openDatabase(join(await getDatabasesPath(), "db_local.db"));
  var data = getMarkersMap();
  return data;
}

class MarkerMap {
  final double latitude;
  final double longitude;
  final int typePoint;
  final int isChecked;
  final String name;
  final String description;

  MarkerMap({required this.latitude, required this.longitude, required this.typePoint, required this.isChecked, required this.name, required this.description});

  Map<String, Object?> toMap() {
    return {'latitude': latitude, 'longitude': longitude, 'type_point': typePoint, 'is_checked': isChecked, 'name': name, 'description': description};
  }
}
// Future<void>createTable() async {
//   final database_ = openDatabase(
//     join(await getDatabasesPath(), 'db_local.db'),
//     onCreate: (db, version) {
//       return db.execute(
//         'CREATE TABLE markers_data (latitude REAL NOT NULL, longitude	REAL NOT NULL, type_point	INTEGER NOT NULL DEFAULT 0 CHECK(type_point >= 0 AND type_point < 3), is_checked	BLOB NOT NULL, name	TEXT,	description	TEXT,	PRIMARY KEY(latitude, longitude))',
//       );
//     },
//     version: 1,
//   );
// }

Future<List<MarkerMap>> getMarkersMap() async {
  final db = database!;

  final List<Map<String, Object?>> markersMaps = await db.query('markers_data');

  return [
    for (final {'latitude': latitude as double,
      'longitude': longitude as double,
      'type_point': typePoint as int,
      'is_checked': isChecked as int,
      'name': name as String,
      'description': description as String
    } in markersMaps)
      
      MarkerMap(latitude: latitude, longitude: longitude, typePoint: typePoint, isChecked: isChecked, name: name, description: description),
  ];
}

Future<void> insertMarker(MarkerMap marker) async {
  final db = database!;
  await db.insert(
    'markers_data',
    marker.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deleteMarkerMap(String name) async {
  final db = database!;

  await db.delete(
    'markers_data',
    where: 'name = ?',
    whereArgs: [name],
  );
}