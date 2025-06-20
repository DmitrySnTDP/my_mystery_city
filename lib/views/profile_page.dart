import 'package:flutter/material.dart';
import 'package:my_mystery_city/controllers/profile_state.dart';
import 'package:my_mystery_city/main.dart';


const goldenColor = Color.fromRGBO(244, 162, 89, 1);

class ProfilePage extends StatefulWidget {
  final List<BadgeData> badges;
  final List<QuestData> quests;

  const ProfilePage({super.key, required this.badges, required this.quests});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final lvlName = "Путешественник-новичок";
  final currentXP = 240;
  final fullXP = 500;
  final profileImg = AssetImage("assets/images/widgets_imgs/profile_img_placeholder.png");


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              height: 321,
              width: 394,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 90, left: 141, right: 141, bottom: 17),
                    child: Image(
                      image: profileImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    lvlName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14, bottom: 6, left: 58, right: 58),
                    child: LinearProgressIndicator(
                      value: currentXP / fullXP,
                      valueColor: AlwaysStoppedAnimation(goldenColor),
                      backgroundColor: Color.fromRGBO(224, 224, 224, 1),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      minHeight: 10,
                    ),
                  ),
                  Text(
                    "$currentXP/$fullXP XP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      
                    ),
                  ),
                ],
              )
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: 394,
              height: 188,
              padding: EdgeInsets.symmetric(horizontal: 19),
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Значки",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,

                        ),
                      ),
                      IconButton(
                        onPressed: () {

                        },
                        icon: Icon(Icons.arrow_forward)
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getBadgesWithText(widget.badges),
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10),),
              ),
              width: 394,
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getQuestsWidget(widget.quests),
              ),
            )
          ]
        )
      )
    );
  }
}


List<Widget> getBadgesWithText(List<BadgeData> badges) {
  List<Widget> widgets = [];
  for (var i = 0; i < 4; i++) {
    widgets.add(
      SizedBox(
        width: 80,
        child: Column(
          
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: badges[i].isDiscovered? badges[i].imageDiscovered : badges[i].image,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            if (badges[i].isDiscovered)
              Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                badges[i].name,
                style: TextStyle(
                  fontSize: 12,
                ),
              )
          ],
        )
      )
    );
  }
  return widgets;
}

List<Widget> getQuestsWidget(List<QuestData> quests) {
  List<Widget> widgets = [];
  widgets.add(
    Padding(
      padding: EdgeInsets.only(left: 18, top: 18, bottom: 15),
      child: Text(
        "Квесты",
        
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        )
      )
    )
  );

  for (var quest in quests) {
    final xp = quest.xp;
    widgets.add(
      Container(
        decoration: const BoxDecoration(
          color: backgroundColorCustom,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: 358,
        height: 67,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 18, right: 18, bottom: 10),
        child: Row(
          children: [
            Image(
              image: quest.icon,
              width: 47,
              height: 47,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 72),
              child: SizedBox(
                width: 147,
                height: 50,
                child: Text(
                  quest.name,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Text(
              "+$xp XP",
              style: TextStyle(

              ),
            )
          ],
        ),
      )
    );
  }

  return widgets;
}