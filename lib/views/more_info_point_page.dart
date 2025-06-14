import 'package:flutter/material.dart';
import 'package:my_mystery_city/controllers/map_state.dart';
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

class MoreInfoPointPage extends StatefulWidget {
  final MarkerMap point;
  const MoreInfoPointPage({super.key, required this.point,});

  @override
  State<MoreInfoPointPage> createState() => _MoreInfoPointPageState();

}
class _MoreInfoPointPageState extends State<MoreInfoPointPage> {
  int indexImg = 0;
  late ImageProvider img;

  @override
  Widget build(BuildContext context) {
    var category = 'без категории';
    switch (widget.point.typePoint) {
      case TypePoint.intrestingPlace:
        category = 'без категории';
        break;
      case TypePoint.architecture:
        category = 'архитектура ';
        break;
      case TypePoint.nature:
        category = 'природа';
        break;
      case TypePoint.monument:
        category = 'памятники';
        break;
      case TypePoint.legends:
        category = 'истории и легенды';
        break;
    }

    img = AssetImage(widget.point.imgLink[indexImg]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 25),
          child: TextButton(
            onPressed: () {
              setState(() {
                tappedMarker.value = widget.point;
                if (selectedIndex.value != 1) {
                  selectedIndex.value = 1;
                }
              });
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(orangeColor),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image(
                    image: img,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (indexImg > 0) {
                            setState(() {
                              img = AssetImage(widget.point.imgLink[indexImg]);
                              indexImg--;
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_back),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          iconColor: indexImg > 0? orangeColor: Colors.grey,
                          shape: CircleBorder(),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (indexImg < widget.point.imgLink.length - 1) {
                            setState(() {
                              indexImg++;
                              img = AssetImage(widget.point.imgLink[indexImg]);
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_forward),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          iconColor: indexImg < widget.point.imgLink.length-1? orangeColor: Colors.grey ,
                          shape: CircleBorder(),
                        ),
                      ),
                    ]
                  )
                )
              ]
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.point.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Категория: $category",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.point.description,
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