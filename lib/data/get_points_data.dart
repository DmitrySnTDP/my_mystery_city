// import 'dart:async';

// import 'package:yandex_maps_mapkit/mapkit.dart';
// import 'package:yandex_maps_mapkit/search.dart';


// class MonumentSearchResult {
//   final String name;
//   final String? description;
//   final Point point;
//   final String? address;

//   MonumentSearchResult({
//     required this.name,
//     required this.point,
//     this.description,
//     this.address,
//   });
// }

// Future<void> searchMonuments() async {
//   final searchManager = SearchFactory.instance.createSearchManager(SearchManagerType.Combined);
//   final suggestSession = searchManager.createSuggestSession();
//   final suggestOptions = SuggestOptions(suggestTypes: SuggestType.Geo);

//   final completer = Completer<List<MonumentSearchResult>>();
//   final results = <MonumentSearchResult>[];


//   final boundingBox = BoundingBox(
//     Point(latitude: 56.70, longitude: 60.45),
//     Point(latitude: 56.90, longitude: 60.70),
//   );

//   final suggestSessionListener = SearchSuggestSessionSuggestListener(
//     onResponse: (response) {
//       for (final item in response.items) {
//         if (item.center != null) {
//           final session = searchManager.submit(
//             Geometry.fromPoint(item.center!),
//             const SearchOptions(
//               searchTypes: SearchType.Geo,
//               resultPageSize: 1, // Нас интересует только первый результат
//             ),
//             SearchSuggestSessionSuggestListener(onResponse: (suggest) {}, onError: (error) {  }) as SearchSessionSearchListener,
//             text: item.title.toString(),
//           );

          // 6. Обрабатываем результаты детального поиска
          // for (final searchResult in session.resultStream) {
          //   if (searchResult.items != null && searchResult.items!.isNotEmpty) {
          //     final resultItem = searchResult.items!.first;
          //     results.add(MonumentSearchResult(
          //       name: resultItem.name ?? item.title,
          //       description: resultItem.descriptionText,
          //       point: resultItem.geometry.first.point!,
          //       address: resultItem.descriptionText,
          //     ));
          //   }
          // }
//         }
//       }
//       completer.complete(results);
//     },
//     onError: (error) {
//       completer.completeError(error);
//     },
//   );

//   suggestSession.suggest(
//   boundingBox,
//   suggestOptions,
//   suggestSessionListener,
//   text: "памятник",
//   );
// }