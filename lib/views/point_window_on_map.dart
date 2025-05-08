import 'package:flutter/material.dart';
import 'package:my_mystery_city/controllers/map_state.dart';
import 'package:my_mystery_city/data/db_worker.dart';


class MarkerOverlay extends StatelessWidget {
  final MarkerMap marker;
  
  const MarkerOverlay({super.key, required this.marker});

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
        minChildSize: 0.00, 
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent <= 0.05) {
                tappedMarker = null;
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
                      children: getText(marker)
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
}

List<Widget> getText(MarkerMap marker){
  List<Widget> discriptionWidgets = [];
  if (marker.isChecked == 1) {
    for (var text in marker.description.split("\\n"))
    {
      discriptionWidgets.add(Text(text, style: TextStyle(fontSize: 12)));
    }

    return [
      Text(
        marker.name,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center
      ),
      SizedBox(height: 15),
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
                child: Image(
                  image: AssetImage(marker.imgLink),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(left: 13, right: 16, top: 4, bottom: 4),
                child : Expanded(
                  child: Text(
                    marker.shortDescription,
                    style: TextStyle(fontSize: 12)
                  ),
                ),
              )
            ),
          ],
        ),
      ),
      SizedBox(height: 15),
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10)),
        ),
        child: Padding(padding: EdgeInsets.only(left: 20, right: 12, top: 12, bottom: 12),
         child: Column(
          children: discriptionWidgets,
          ),
        ),
      ),
    ];
  }
  
  else {
    return [
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.circular(10))
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 46, top: 16, bottom: 16),
          child: Column(
            children: [
              Text("Неизведанное место", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), 
              Text(
                "Здесь скрывается тайна, которую ещё предстоит раскрыть. Отправляйся в путь, чтобы узнать, какие сюрпризы приготовило это место!",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Color.fromRGBO(246, 135, 99, 1)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child: Text(
                      "В путь!",
                      style: TextStyle(fontSize: 13, color: Colors.white)
                    ),
                  ),
                  SizedBox(width: 16),
                  TextButton(
                    onPressed: null,
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        BorderSide(
                          color: Color.fromRGBO(246, 135, 99, 1),
                          width: 1.5,
                        ),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child: Text(
                      "Составить маршрут",
                      style: TextStyle(fontSize: 13, color: Color.fromRGBO(246, 135, 99, 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
}