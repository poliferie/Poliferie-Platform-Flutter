import 'models/item.dart';

List<T> repeat<T>(List<T> list, int iteration) {
  List<T> newList = [];
  for (int i = 0; i < iteration; i++) {
    newList.addAll(list);
  }
  return newList;
}

ItemType selectType(String type) {
  if (type == 'course') return ItemType.course;
  if (type == 'university') return ItemType.university;
}
