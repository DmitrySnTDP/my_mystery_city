import 'package:flutter/material.dart';
import 'package:my_mystery_city/enums/categories_enum.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/enums/type_point_enum.dart';
import 'package:my_mystery_city/views/more_info_point_page.dart';

List<MarkerMap> allMarkers = [];
List<MarkerMap> architectureMarkers = [];
List<MarkerMap> natureMarkers = [];
List<MarkerMap> monumentMarkers = [];
List<MarkerMap> historyMarkers = [];

var routesText = ["Маршруты", "Без описания."];
var architectureText = ["Архитектура Екатеринбурга", "Город — это музей под открытым небом. Исследуй шедевры разных эпох: от барокко до конструктивизма."];
var natureText = ["Природа Екатеринбурга", "Открой зелёную сторону города — от лесопарков и озёр до скрытых троп и панорамных видов. Природа Екатеринбурга удивляет даже среди городского ритма."];
var memorialText = ["Памятники Екатеринбурга", "Каждая скульптура — это история, застывшая в металле и камне. Прогуляйся по городу и узнай, кому и чему посвящены самые необычные и знаковые памятники Екатеринбурга."];
var historyText = ["Истории и легенды", "Улицы Екатеринбурга хранят тайны, мифы и удивительные события. Погрузись в атмосферу прошлого — от купеческих тайн до городских мистических историй."];

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  void _openCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailsPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(247, 245, 242, 1),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 375,
                height: 190,
                child: ElevatedButton(
                  onPressed: () => _openCategory(context, Category.route),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(244, 162, 89, 1),
                    foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/routes-fix.png',
                        width: 300,
                        height: 100,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Маршруты Екатеринбурга",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: ElevatedButton(
                      onPressed:
                          () => _openCategory(context, Category.architecture),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(203, 170, 203, 1),
                        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/architecture.png',
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "Архитектура",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: ElevatedButton(
                      onPressed: () => _openCategory(context, Category.nature),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(164, 196, 154, 1),
                        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/nature.png',
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "Природа",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: ElevatedButton(
                      onPressed:
                          () => _openCategory(context, Category.memorial),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(188, 138, 95, 1),
                        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/memorials.png',
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "Памятники",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: ElevatedButton(
                      onPressed: () => _openCategory(context, Category.history),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(106, 140, 175, 1),
                        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/history.png',
                            width: 100,
                            height: 100,
                          ),
                          //SizedBox(height: 8,),
                          Text(
                            "История и легенды",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> getPoints() async {
  final dbData = await getData();

  for (final marker in dbData) {
    if (marker.typePoint == TypePoint.architecture) {
      architectureMarkers.add(marker);
    } else if (marker.typePoint == TypePoint.nature) {
      natureMarkers.add(marker);
    } else if (marker.typePoint == TypePoint.monument) {
      monumentMarkers.add(marker);
    } else if (marker.typePoint == TypePoint.legends) {
      historyMarkers.add(marker);
    }
    allMarkers.add(marker);
  }
}

class CategoryDetailsPage extends StatefulWidget {
  final Category category;

  const CategoryDetailsPage({super.key, required this.category});

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<MarkerMap> selectedList;

    String navTitle = "";
    String title = "";
    String subtitle = "";

    switch (widget.category) {
      case Category.route:
        navTitle = '';
        title = routesText[0];
        subtitle = routesText[1];
        selectedList = allMarkers;
        break;
      case Category.architecture:
        navTitle = '';
        title = architectureText[0];
        subtitle = architectureText[1];
        selectedList = architectureMarkers;
        break;
      case Category.nature:
        navTitle = '';
        title = natureText[0];
        subtitle = natureText[1];
        selectedList = natureMarkers;
        break;
      case Category.memorial:
        navTitle = '';
        title = memorialText[0];
        subtitle = memorialText[1];
        selectedList = monumentMarkers;
        break;
      case Category.history:
        navTitle = '';
        title = historyText[0];
        subtitle = historyText[1];
        selectedList = historyMarkers;
        break;
    }

    final filteredList = selectedList.where((marker) {
      return marker.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    List<Widget> getText(MarkerMap marker) {
      final sentenses = marker.description.split(". ");
      var shortDescription = sentenses.getRange(0, 2).join(". ");
      shortDescription += '.';
      if (marker.isChecked == 1) {
        return [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 13,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image(
                    image: AssetImage(marker.imgLink.first),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marker.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 10,
                            child: Text(
                              shortDescription,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                openMoreInfo(context, marker);
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                                minimumSize: WidgetStateProperty.all(Size.zero),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Подробнее",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ];
      } 
      else {
        return [
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 13,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Image.asset("assets/images/widgets_imgs/lock.png"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100, width: 357),
                    Text(
                      "Откроется, когда изведаете локацию",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ];
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(navTitle),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            const SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                  hintText: "Поиск",
                  hintStyle: TextStyle(fontSize: 13),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: ImageIcon(const AssetImage("assets/icons/search.png")),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              filteredList.length,
              (index) => Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(25, 5, 242, 0),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 17),
                  child: Column(
                    children: getText(filteredList[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
