import 'package:flutter/material.dart';
import 'package:my_mystery_city/data/db_worker.dart';
import 'package:my_mystery_city/views/home_page.dart';

class MoreInfoPointPage extends StatelessWidget {
  final MarkerMap point;
  final VoidCallback onClose;

  const MoreInfoPointPage({
    super.key,
    required this.point,
    required this.onClose,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(10.0),
        children:[ 
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            style: ButtonStyle(alignment: Alignment.topLeft),
            onPressed: onClose
          ),
          Padding(padding: EdgeInsets.only(left: 100, right: 100), child: 
          TextButton(
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
          ),)
        ]
      ),
    );
  }
}