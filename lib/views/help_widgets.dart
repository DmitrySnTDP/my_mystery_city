import 'package:flutter/material.dart';
import 'package:my_mystery_city/main.dart';


Widget startHelpWidget(String text, {double? leftPos, double? rightPos, double? topPos, double? bottomPos, double height = 50}) {
  return Positioned(
    left: leftPos,
    right: rightPos,
    top: topPos,
    bottom: bottomPos,
    height: height,
    child: Container(
      margin: EdgeInsets.only(left: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)), 
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 225,
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Icon(Icons.arrow_forward),
        ],
      ) 
    ) 
  );
}

Widget errorHelpWidget(String text, {double? leftPos, double? rightPos, double? topPos, double? bottomPos, double height = 50, VoidCallback? buttonFunc}) {
  return Positioned(
    left: leftPos,
    right: rightPos,
    top: topPos,
    bottom: bottomPos,
    height: height,
    child: Container(
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)), 
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 225,
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          if (buttonFunc != null)
            TextButton(
              onPressed: buttonFunc,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(orangeColor),
                
              ),
              child: Text(
                "Понятно",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ) 
    ) 
  );
}