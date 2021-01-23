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

class CombinationAlgorithmDynamics {
  final List<List<dynamic>> elements;

  CombinationAlgorithmDynamics(this.elements);

  List<List<dynamic>> combinations() {
    List<List<dynamic>> perms = [];
    generateCombinations(elements, perms, 0, []);
    return perms;
  }

  void generateCombinations(List<List<dynamic>> lists,
      List<List<dynamic>> result, int depth, List<dynamic> current) {
    if (depth == lists.length) {
      result.add(current);
      return;
    }

    for (int i = 0; i < lists[depth].length; i++) {
      generateCombinations(
          lists, result, depth + 1, [...current, lists[depth][i]]);
    }
  }
}

/// Parse the data structure from a stat values.
/// TODO(@amerlo): Implement as a repository.
dynamic parseStatValue(dynamic stat) {
  // If null, return it.
  if (stat == null) return stat;

  // If single value, return it.
  if (stat is int || stat is String || stat is double) {
    return stat;
  }

  // Extract metadata from stat
  Map<String, dynamic> bins = stat["bins"];
  List<dynamic> values = stat["values"];

  // TODO(@amerlo): implement as a repository.
  int isee;
  getPrefereceKey("ISEE").then((v) {
    isee = int.parse(v);
  });

  // Assume higher isee.
  int iseeIndex = values.length - 1;
  if (bins.containsKey("isee")) {
    iseeIndex = bins["isee"].length;
  }
  // TODO(@amerlo): uncomment once repository is ready.
  // if (isee != null) {
  //   for (dynamic i in bins["isee"]) {
  //     if (isee < (i as int)) {
  //       break;
  //     }
  //     isee_index += 1;
  //   }
  // }

  // If stat is a cost, values is indexed only by ISEE.
  if (!bins.containsKey("ispe")) {
    return values[iseeIndex];
  }

  // Assume higher ispee bin.
  int ispeeIndex = bins["ispe"].length;

  // Cap has to be implemented.
  int capIndex = 0;

  // TODO(@amerlo): Include caps lenght.
  // Compute index
  // int index = cap_index +
  //     isee_index * bins["cap"].length +
  //     ispee_index * bins["cap"].length * (bins["isee"].length + 1);
  int index = iseeIndex + ispeeIndex * (bins["isee"].length + 1);
  return values[index];
}
