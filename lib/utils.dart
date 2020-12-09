import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

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

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

Image getImage(String src, {BoxFit fit, double height, double width}) {
  if (src.startsWith("http")) {
    return Image.network(src, fit: fit, height: height, width: width);
  } else {
    return Image.asset(src, fit: fit, height: height, width: width);
  }
}
