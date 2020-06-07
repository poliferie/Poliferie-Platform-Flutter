import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void savePersistenceList(String key, List<int> list) async {
  final prefs = await SharedPreferences.getInstance();
  final String string = jsonEncode(list);

  await prefs.setString(key, string);
}

Future<List<int>> getPersistenceList(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final String encodedList = prefs.getString(key);

  //prefs.remove(key);
  if (encodedList != null) {
    final List<dynamic> list = jsonDecode(encodedList);
    return list.cast<int>();
  }

  return [];
}

void addToPersistenceList(String key, int element) async {
  List<int> list = await getPersistenceList(key);
  if (!list.contains(element)) {
    list.add(element);
  }

  savePersistenceList(key, list);
}

void removeFromPersistenceList(String key, int element) async {
  List<int> list = await getPersistenceList(key);
  list.remove(element);

  savePersistenceList(key, list);
}

List<T> repeat<T>(List<T> list, int iteration) {
  List<T> newList = [];
  for (int i = 0; i < iteration; i++) {
    newList.addAll(list);
  }
  return newList;
}
