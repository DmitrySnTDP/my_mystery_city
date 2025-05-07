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
        minChildSize: 0.15, 
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent <= 0.25) {
                // Navigator.pop(context);
                tappedMarker = null;
                return true;
              }
              return false;
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
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
                    padding: const EdgeInsets.all(16.0),
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
  if (marker.isChecked == 1) {
    return [Text(marker.name, style: TextStyle(fontSize: 20, fontWeight :FontWeight.bold)),
    Text(marker.description, style: TextStyle(fontSize: 14))];
  }
  else {
    return [Text("Неизведанное место", style: TextStyle(fontSize: 20, fontWeight :FontWeight.bold)), 
    Text("Здесь скрывается тайна, которую ещё предстоит раскрыть. Отправляйся в путь, чтобы узнать, какие сюрпризы приготовило это место!", style: TextStyle(fontSize: 14))];
  }
}