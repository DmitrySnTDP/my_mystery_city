import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 150,
                child: ElevatedButton(
                  onPressed: () {},
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
                      // Иконка состоит из трёх картинок, поэтому они объеденены в Row
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/routes-1.png',
                            width: 100,
                            height: 100,
                          ),
                          Image.asset(
                            'assets/icons/routes-2.png',
                            width: 100,
                            height: 100,
                          ),
                          Image.asset(
                            'assets/icons/routes-3.png',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
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
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: ElevatedButton(
                      onPressed: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
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
