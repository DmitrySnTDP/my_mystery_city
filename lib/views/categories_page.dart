import 'package:flutter/material.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/enums/type_point_enum.dart';
import 'package:my_mystery_city/main.dart';
import 'package:my_mystery_city/views/more_info_point_page.dart';
import 'package:my_mystery_city/views/routes_page.dart';


Map<int, List<MarkerMap>> markersData = {};

Future<void> getPoints() async {
  for (final typePoint in TypePoint.values) {
    if (!markersData.containsKey(typePoint.indexType)) {
      markersData[typePoint.indexType] = await getMarkersMapOnType(typePoint);
    }
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  void _openCategory(BuildContext context, TypePoint category) {
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
          color: backgroundColorCustom,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 375,
                height: 190,
                child: ElevatedButton(
                  onPressed: () => openRoutesPage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(244, 162, 89, 1),
                    foregroundColor: Colors.white,
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
                          () => _openCategory(context, TypePoint.architecture),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(203, 170, 203, 1),
                        foregroundColor: Colors.white,
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
                      onPressed: () => _openCategory(context, TypePoint.nature),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(164, 196, 154, 1),
                        foregroundColor: Colors.white,
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
                          () => _openCategory(context, TypePoint.monument),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(188, 138, 95, 1),
                        foregroundColor: Colors.white,
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
                      onPressed: () => _openCategory(context, TypePoint.legends),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(106, 140, 175, 1),
                        foregroundColor: Colors.white,
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

class CategoryDetailsPage extends StatefulWidget {
  final TypePoint category;

  const CategoryDetailsPage({super.key, required this.category});

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    late final List<MarkerMap> selectedList;

    final title = "${widget.category.title} Екатеринбурга";
    final subtitle = widget.category.description;
    selectedList = markersData[widget.category.indexType]!;

    final filteredList = selectedList.where((marker) {
      return marker.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(),
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


  List<Widget> getText(MarkerMap marker) {
    final sentenses = marker.description.split(". ");
    var shortDescription = marker.description;
    if (sentenses.length > 2) {
    shortDescription = sentenses.getRange(0, 2).join(". ");
    shortDescription += '.';
    }
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
                color: Color.fromRGBO(0, 0, 0, 0.3),
                blurRadius: 13,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              child: Image(
                image: AssetImage(marker.imgLink[0]),
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    marker.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    shortDescription,
                    textAlign: TextAlign.start,
                    
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          openMoreInfo(context, marker);
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          minimumSize: WidgetStateProperty.all(Size.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Подробнее",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          )
                        )
                      )
                    ]
                  )
                ]
              )
            )
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
                color: Color.fromRGBO(0, 0, 0, 0.3),
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
}
