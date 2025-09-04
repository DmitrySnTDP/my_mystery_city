import 'package:flutter/material.dart';
import 'package:my_mystery_city/controllers/map_state.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/main.dart';
import 'package:my_mystery_city/views/more_info_point_page.dart';


class MarkerOverlay extends StatelessWidget {
  final MarkerMap marker;
  final VoidCallback onClose;
  final VoidCallback onCreateRoot;

  const MarkerOverlay({
    super.key,
    required this.marker,
    required this.onClose,
    required this.onCreateRoot,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 200,
      bottom: 0,
      left: 0,
      right: 0,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: marker.isChecked == 1? 0.8: showOtherRoutePageId.value.isEmpty? 0.5: 0.35,
        minChildSize: 0.05, 
        maxChildSize: marker.isChecked == 1? 1.0: 0.5,
        builder: (context, scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent <= 0.1) {
                onClose();
                return true;
              }
              return false;
            },
            child: Container(
              decoration: const BoxDecoration(
                color: backgroundColorCustom,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: getText(marker, context)
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
    );
  }


  List<Widget> getText(MarkerMap marker, BuildContext context){
    final sentenses = marker.description.split(". ");
    var shortDescription = marker.description;
    if (sentenses.length > 2) {
      shortDescription = sentenses.getRange(0, 2).join(". ");
    }
    
    shortDescription += '.';
    if (marker.isChecked == 1) {
      return [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
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
        if (showOtherRoutePageId.value.isEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 17, bottom: 0),
            child: TextButton(
              onPressed: onCreateRoot,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(orangeColor),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 65.5, vertical: 14.5)),
              ),
              child: Text(
                "Составить маршрут",
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
            ),
          ),
      ];
    }
    
    else {
      return [
        Stack(
          children: [
            Image.asset("assets/images/widgets_imgs/lock.png"),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                SizedBox(height: 100, width: 357), 
                Text(
                  "Откроется, когда изведаете локацию",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14)
                ),
              ]
            ),
          ]
        ),
        if (showOtherRoutePageId.value.isEmpty)
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 17, bottom: 0),
            child: TextButton(
              onPressed: onCreateRoot,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(orangeColor),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 65.5, vertical: 14.5)),
              ),
              child: Text(
                "Составить маршрут",
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
            ),
          ),
      ];
    }
  }
}