import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void savePersistenceList(String key, List<dynamic> list) async {
  final prefs = await SharedPreferences.getInstance();
  final string = jsonEncode(list);

  await prefs.setString(key, string);
}

Future<List<dynamic>> getPersistenceList(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getString(key);

  if (list != null) return jsonDecode(list) as List<dynamic>;
  return null;
}

void addToPersistenceList(String key, dynamic element) async {
  List<dynamic> list = await getPersistenceList(key);
  if (!list.contains(element)) {
    list.add(element);
  }

  savePersistenceList(key, list);
}

void removeFromPersistenceList(String key, dynamic element) async {
  List<dynamic> list = await getPersistenceList(key);
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
