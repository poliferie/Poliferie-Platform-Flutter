import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

List<T> repeat<T>(List<T> list, int iteration) {
  List<T> newList = [];
  for (int i = 0; i < iteration; i++) {
    newList.addAll(list);
  }
  return newList;
}

Future<String> getPrefereceKey(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

void setPrefereceKey(String key, dynamic value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value as String);
}

Widget keyboardDismisser({BuildContext context, Widget child}) {
  final gesture = GestureDetector(
    onTap: () {
      FocusScope.of(context).requestFocus(new FocusNode());
    },
    child: child,
  );
  return gesture;
}
