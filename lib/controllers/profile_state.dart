

import 'package:flutter/material.dart';

class BadgeData {
  final String name;
  final String description;
  final ImageProvider image;
  final ImageProvider imageDiscovered;
  var isDiscovered = false;

  BadgeData({required this.name, required this.description, required this.image, required this.imageDiscovered,});
}

class QuestData {
  final String name;
  final ImageProvider icon;
  final int xp;
  int maxProgress;
  int currentProgress = 0;
  var isComplete = false;

  QuestData({required this.name, required this.icon, required this.xp, required this.maxProgress});
}

final List<BadgeData> badgesList = [
  BadgeData(
    name: "Глаз города",
    description: "За обнаружение скрытой точки на карте",
    image: AssetImage("assets/icons/badges/sity_eye.png"),
    imageDiscovered: AssetImage("assets/icons/badges/sity_eye_discovered.png"),
  )..isDiscovered = true,
  BadgeData(
    name: "Следопыт",
    description: "За пройденный квест или длинный маршрут",
    image: AssetImage("assets/icons/badges/pathfinder.png"),
    imageDiscovered: AssetImage("assets/icons/badges/pathfinder_discovered.png"),
  )..isDiscovered = true,
  BadgeData(
    name: "Фотоохотник",
    description: "За 3 посещённые фотогеничные локации",
    image: AssetImage("assets/icons/badges/wildlife_photographer.png"),
    imageDiscovered: AssetImage("assets/icons/badges/wildlife_photographer_discovered.png"),
  ),
  BadgeData(
    name: "Архитектурный след",
    description: "За 5 изученных архитектурных объектов",
    image: AssetImage("assets/icons/badges/architectural_trace.png"),
    imageDiscovered: AssetImage("assets/icons/badges/architectural_trace_discovered.png"),
  ),
  BadgeData(
    name: "Покоритель центра",
    description: "Получается за посещение 5 объектов в историческом центре",
    image: AssetImage("assets/icons/badges/center_lord.png"),
    imageDiscovered: AssetImage("assets/icons/badges/center_lord_discovered.png"),
  ),
  BadgeData(
    name: "Любитель легенд",
    description: "За 3 локации с историей или мистикой",
    image: AssetImage("assets/icons/badges/legend_lover.png"),
    imageDiscovered: AssetImage("assets/icons/badges/legend_lover_discovered.png"),
  ),
  // BadgeData(
  //   name: "",
  //   description: "",
  //   image: AssetImage(""),
  //   imageDiscovered: AssetImage(""),
  // ),

];

final List<QuestData> questsList = [
  QuestData(
    name: "Пройди первый маршрут",
    icon: AssetImage("assets/icons/quests/quest1_icon.png"),
    xp: 250,
    maxProgress: 100,
  ),
  QuestData(
    name: "Изучи 5 объектов архитектуры",
    icon: AssetImage("assets/icons/quests/quest2_icon.png"),
    xp: 250,
    maxProgress: 100,
  ),
  // QuestData(
  //   name: "",
  //   icon: AssetImage(""),
  //   xp: 250,
  //   maxProgress: 100,
  // ),
];