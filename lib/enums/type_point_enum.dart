enum TypePoint{
  intrestingPlace(1, "без категории"),
  architecture(2, "архитектура"),
  nature(3, "природа"),
  monument(4, "памятники"),
  legends(5, "легенды и истории");

  final int indexType;
  final String title;
  const TypePoint(this.indexType, this.title);
}
// типы точек: 1 - без типа (по умолчанию), 2 - архитектура, 3 - природа, 4 - памятники, 5 - легенды и истории
