import 'package:flutter/material.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/enums/type_point_enum.dart';
import 'package:my_mystery_city/views/home_page.dart';


void openMoreInfo(BuildContext context, MarkerMap point) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoreInfoPointPage(point: point,),
    ),
  );
}

class MoreInfoPointPage extends StatelessWidget {
  final MarkerMap point;

  const MoreInfoPointPage({
    super.key,
    required this.point,
    }
  );
  @override
  Widget build(BuildContext context) {
    var category = 'без категории';
    switch (point.typePoint) {
      case TypePoint.intrestingPlace:
        category = 'без категории';
        break;
      case TypePoint.architecture:
        category = 'архитектура ';
        break;
      case TypePoint.nature:
        category = 'природа Екатеринбурга';
        break;
      case TypePoint.monument:
        category = 'памятники Екатеринбурга';
        break;
      case TypePoint.legends:
        category = 'истории и легенды';
        break;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: 
        Padding(
          padding: EdgeInsets.only(left: 100, right: 100, top: 25, bottom: 25),
          child: TextButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(orangeColor),
              padding: WidgetStatePropertyAll(EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text(
              "Посмотреть на карте",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              )
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(18.0),
          children:[
            ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image(
                    image: AssetImage(point.imgLink),
                    fit: BoxFit.fitWidth,
                  ),
                ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Категория: $category",
                  ),
                  Text(
                    point.description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ]
              )
            ),
          ]
        ),
      )
    );
  }
}