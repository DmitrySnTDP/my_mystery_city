// import 'package:my_mystery_city/get_points_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:yandex_maps_mapkit/search.dart';

Database? database;

Future<List<MarkerMap>> getData() async {
  database = await openDatabase(join(await getDatabasesPath(), "assets/db/db_local.db"));
  var data = getMarkersMap();
  return data;
}
// final listener = SearchSuggestSessionSuggestListener;
// Future<void> get() async {
//   await searchMonuments();
// }

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

Future<void> checkDB() async {
  var path = join(await getDatabasesPath(), "assets/db/db_local.db");
  var exists = await databaseExists(path);

  if (!exists) {
    createFillTable();
  }
}

Future<void> createFillTable() async {
  createTable();
  database = await openDatabase(join(await getDatabasesPath(), "assets/db/db_local.db"));
  insertMarker(MarkerMap(latitude: 56.838104, longitude: 60.603722,  typePoint: 2, isChecked: 0, name: 'Исторический сквер', description: '''"Историческим сквером" это место стало лишь в 1973-75 годах, когда к 250-летию города здесь, вместо старинных цехов Екатеринбургского завода, появилось открытое общественное пространство для проведения городских гуляний и праздников.

  История Екатеринбурга, как и история большинства других уральских городов, начиналась в 1723 году со строительства завода. Екатеринбургский завод стал главным государственным заводом всей Сибири и в течение долгого времени являлся «образцом» для строительства новых заводов. К ноябрю 1723 года, в рекордно короткие сроки, была возведена заводская плотина на реке Исети, фабрики, строения и регулярная крепость. Проходившая через специальные прорезы в плотине вода шла на многочисленные водяные мельничные колеса, которые приводили в движение заводские молоты и воздушные меха доменных печей.

  Из всего первоначального сегодня сохранилась лишь сама плотина – старейшее рукотворное сооружение Екатеринбурга, сердце Исторического сквера, именуемого в народе "Плотинкой". Плотина построена на сваях из лиственницы, которая под водой не гниёт, а каменеет, если находится там без доступа воздуха. Гранитную рубашку плотина приобрела при реконструкции 1830-50-х гг. На подпорной стене плотины, слева от створа, расположен барельеф "Рождение города", созданный в 1973 году. Напротив створа установлена огромная родонитовая глыба – символ минералогического богатства Уральских гор.

  Помимо обычных для заводов XVIII века металлургических фабрик, здесь были особые, уникальные производства, принесшие немалую славу Екатеринбургу: Монетный двор и, позднее, в XIX веке - Императорская гранильная фабрика. В течение 140 лет здесь чеканилась львиная доля всей Российской медной монеты, а продукция гранильной фабрики и сегодня украшает Эрмитаж и Мраморный дворец в Санкт-Петербурге и Екатерининский дворец в Царском селе.

  Больше всего исторических зданий уцелело по восточной границе "Плотинки", сейчас там располагаются музеи – архитектурный и музей природы. В западной части "Плотинки" находится «Геологическая аллея», где под открытым небом выставлены образцы горных пород: железная руда, розовый и голубой мрамор, родонит, гранит, вермикулит, - огромные глыбы, символизирующие богатство Уральского края.'''));
}

Future<void>createTable() async {
  // ignore: unused_local_variable
  var database_ = openDatabase(join(await getDatabasesPath(), "assets/db/db_local.db"),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE markers_data (latitude REAL NOT NULL, longitude	REAL NOT NULL, type_point	INTEGER NOT NULL DEFAULT 0 CHECK(type_point >= 0 AND type_point < 3), is_checked	BLOB NOT NULL, name	TEXT,	description	TEXT,	PRIMARY KEY(latitude, longitude))',
      );
    },
    version: 1,
  );
}

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