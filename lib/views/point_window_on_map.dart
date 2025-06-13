import 'package:flutter/material.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/views/home_page.dart';


class MarkerOverlay extends StatelessWidget {
  final MarkerMap marker;
  final VoidCallback onClose;
  final VoidCallback onCreateRoot;
  final Function moreInfoFunc;

  const MarkerOverlay({
    super.key,
    required this.marker,
    required this.onClose,
    required this.onCreateRoot,
    required this.moreInfoFunc,
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
        initialChildSize: 0.5,
        minChildSize: 0.05, 
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent <= 0.1) {
                // tappedMarker = null;
                onClose();
                return true;
              }
              return false;
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(247, 245, 242, 1),
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
                      children: getText(marker, moreInfoFunc)
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


  List<Widget> getText(MarkerMap marker, Function moreInfoFunc){
    var shortDescription = marker.shortDescription;
    if (shortDescription == "") {
      final sentenses = marker.description.split(". ");
      shortDescription = sentenses.getRange(0, 2).join(". ");
      shortDescription += '.';
    } 
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
                  image: AssetImage(marker.imgLink),
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
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: TextButton(
                            onPressed: () {moreInfoFunc();},
                            style: ButtonStyle(
                               padding: WidgetStateProperty.all(EdgeInsets.zero),
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
                              )
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
            padding: WidgetStatePropertyAll(EdgeInsets.only(left: 65.5, right: 65.5, top: 14.5, bottom: 14.5)),
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
            padding: WidgetStatePropertyAll(EdgeInsets.only(left: 65.5, right: 65.5, top: 14.5, bottom: 14.5)),
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