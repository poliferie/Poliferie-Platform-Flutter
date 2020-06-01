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

  Future<List<SearchSuggestion>> fetchSuggestions(String searchText) async {
    if (useLocalJson) {
      String suggestionData =
          await rootBundle.loadString("assets/data/mockup/suggestions.json");
      final List<dynamic> suggestions = json.decode(suggestionData).toList();
      return suggestions.map((e) => SearchSuggestion.fromJson(e)).toList();
    } else {
      return <SearchSuggestion>[];
    }
  }

  Future<List> fetchSearch(String searchText) async {
    if (useLocalJson) {
      String searchData =
          await rootBundle.loadString("assets/data/mockup/items.json");
      final List<dynamic> items = json.decode(searchData).toList();
      return items.map((e) => ItemModel.fromJson(e)).toList();
    } else {
      return <SearchSuggestion>[];
    }
  }
}
