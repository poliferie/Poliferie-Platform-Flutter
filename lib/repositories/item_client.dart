import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'package:Poliferie.io/models/item.dart';

// TODO(@amerlo): Move this to single client
// TODO(@amerlo): Implement API call
class ItemClient {
  final String baseUrl;
  final bool useLocalJson;

  ItemClient(
      {this.baseUrl = "https://api.poliferie.org/course?q=",
      this.useLocalJson = false});

  Future<ItemModel> fetch(int itemId) async {
    if (useLocalJson) {
      String _data =
          await rootBundle.loadString("assets/data/mockup/items.json");
      final items = json.decode(_data).toList();
      for (var item in items) {
        if (item["id"] == itemId) {
          return ItemModel.fromJson(item);
        }
      }
      // TODO(@amerlo): Add log warning
      return ItemModel();
    } else {
      return ItemModel();
    }
  }
}
