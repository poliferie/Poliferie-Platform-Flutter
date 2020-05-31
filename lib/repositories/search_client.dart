import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item.dart';

// TODO(@amerlo): Implement API call
class SearchClient {
  final String baseUrl;
  final bool useLocalJson;
  SearchClient(
      {this.baseUrl = "https://api.poliferie.org/user?q=",
      this.useLocalJson = false});

  // TODO(@amerlo): Implement list builder
  Future<List<SearchSuggestion>> fetchSuggestions(String searchText) async {
    if (useLocalJson) {
      String _data =
          await rootBundle.loadString("assets/data/mockup/suggestions.json");
      final _suggestionList = json.decode(_data).toList();
      return <SearchSuggestion>[
        SearchSuggestion.fromJson(_suggestionList[0]),
        SearchSuggestion.fromJson(_suggestionList[1]),
      ];
    } else {
      return <SearchSuggestion>[];
    }
  }

  // TODO(@amerlo): Implement list builder
  Future<List> fetchSearch(String searchText) async {
    if (useLocalJson) {
      String searchData =
          await rootBundle.loadString("assets/data/mockup/items.json");
      final items = json.decode(searchData).toList();
      return <ItemModel>[
        ItemModel.fromJson(items[0]),
        ItemModel.fromJson(items[1])
      ];
    } else {
      return <SearchSuggestion>[];
    }
  }
}
