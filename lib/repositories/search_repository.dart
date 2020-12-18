import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/configs.dart';
import 'package:Poliferie.io/utils.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/providers/local_provider.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item.dart';

// TODO(@amerlo): Define generic _fetch() method for both search and suggestion to fetch results.

///Orders [results] based on number of matched keywords given [searchText].
_orderResults(dynamic results, String searchText) {
  // Do not order results if there is no searchText.
  if (searchText == null) return results;

  Set<String> searchKeywords =
      Set.from(searchText.contains(" ") ? searchText.split(" ") : [searchText]);
  int _countMatches(List<String> keywords, String searchText) {
    return Set.from(keywords).intersection(searchKeywords).length;
  }

  // Keeps ascending order.
  results.sort((a, b) => -_countMatches(a.search, searchText)
      .compareTo(_countMatches(b.search, searchText)));

  return results;
}

class SearchRepository {
  final ApiProvider apiProvider;
  final LocalProvider localProvider;

  SearchRepository({@required this.apiProvider, this.localProvider})
      : assert(apiProvider != null);

  /// Returns the suggestions for the Firebase query given the [searchText].
  ///
  /// A set of [filters] and a specifc [order] could be optionally given.
  Future<List<SearchSuggestion>> suggest(String searchText,
      {Map<String, dynamic> filters,
      Map<String, dynamic> order,
      int limit}) async {
    // Returns empty list if search text lenght is less then required.
    // This hack avoid to make lots of requests to Firebase.
    if (searchText.length <= Configs.searchTextMinimumCharacters) return [];

    // Builds the Firebase search query based on [searchText].
    filters = Map<String, dynamic>.from(
        filters ?? {}); // clone so original it is not modified
    filters = _addSearchText(filters, searchText);

    List<SearchSuggestion> suggestions = [];

    // Search for "in" filters
    Map<String, dynamic> _inFilters = Map.from(filters ?? {})
      ..removeWhere((key, value) => (key == "search" || value["op"] != "in"));

    if (_inFilters.isEmpty ||
        (_inFilters.keys.length == 1 && !filters.containsKey("search"))) {
      // Query does not seem to be problematic, so perform single one.
      final returnedJson = await apiProvider.fetch(
          Configs.firebaseSuggestionsCollection,
          filters: filters,
          order: order,
          limit: limit);
      //suggestions.addAll(
      //    returnedJson.map((el) => ItemModel.fromJson(el)).cast<ItemModel>());
      suggestions.addAll(returnedJson
          .map((el) => SearchSuggestion.fromJson(el))
          .cast<SearchSuggestion>());

      return _orderResults(suggestions, searchText);
    }

    // TODO(@amerlo): Keep the one with the longest values list instead of the first one
    if (_inFilters.isNotEmpty && !filters.containsKey("search")) {
      _inFilters.remove(_inFilters.keys.toList()[0]);
    }

    // Remove _inFilters from filters
    for (String key in _inFilters.keys) {
      filters.remove(key);
    }

    CombinationAlgorithmDynamics _allValues = CombinationAlgorithmDynamics(
        _inFilters.values.map((e) => (e["values"] as List)).toList());

    for (List<dynamic> values in _allValues.combinations()) {
      Map<String, dynamic> _filters = Map.from(filters);
      for (var v in values) {
        _filters.putIfAbsent(_inFilters.keys.toList()[values.indexOf(v)],
            () => {"op": "==", "values": v});
      }
      final returnedJson = await apiProvider.fetch(
          Configs.firebaseSuggestionsCollection,
          filters: _filters,
          order: order,
          limit: limit);
      suggestions.addAll(returnedJson
          .map((el) => SearchSuggestion.fromJson(el))
          .cast<SearchSuggestion>());
    }

    return _orderResults(suggestions, searchText);
  }

  /// Returns the results for the Firebase query given the [searchText].
  ///
  /// A set of [filters] and a specifc [order] could be optionally given.
  Future<List<ItemModel>> search(String searchText,
      {Map<String, dynamic> filters,
      Map<String, dynamic> order,
      int limit}) async {
    // Builds the Firebase search query based on [searchText].
    filters = _addSearchText(filters, searchText);

    List<ItemModel> results = [];

    // Search for "in" filters
    Map<String, dynamic> _inFilters = Map.from(filters ?? {})
      ..removeWhere((key, value) => (key == "search" || value["op"] != "in"));

    if (_inFilters.isEmpty ||
        (_inFilters.keys.length == 1 && !filters.containsKey("search"))) {
      // Query does not seem to be problematic, so perform single one.
      final returnedJson = await apiProvider.fetch(
          Configs.firebaseItemsCollection,
          filters: filters,
          order: order,
          limit: limit);
      results.addAll(
          returnedJson.map((el) => ItemModel.fromJson(el)).cast<ItemModel>());

      return _orderResults(results, searchText);
    }

    // TODO(@amerlo): Keep the one with the longest values list instead of the first one
    if (_inFilters.isNotEmpty && !filters.containsKey("search")) {
      _inFilters.remove(_inFilters.keys.toList()[0]);
    }

    // Remove _inFilters from filters
    for (String key in _inFilters.keys) {
      filters.remove(key);
    }

    CombinationAlgorithmDynamics _allValues = CombinationAlgorithmDynamics(
        _inFilters.values.map((e) => (e["values"] as List)).toList());

    for (List<dynamic> values in _allValues.combinations()) {
      Map<String, dynamic> _filters = Map.from(filters);
      for (var v in values) {
        _filters.putIfAbsent(_inFilters.keys.toList()[values.indexOf(v)],
            () => {"op": "==", "values": v});
      }
      final returnedJson = await apiProvider.fetch(
          Configs.firebaseItemsCollection,
          filters: _filters,
          order: order,
          limit: limit);
      results.addAll(
          returnedJson.map((el) => ItemModel.fromJson(el)).cast<ItemModel>());
    }

    return _orderResults(results, searchText);
  }
}

/// Adds [searchText] as additional filter values to [filters].
///
/// At the moment it performs a naive text split and search against all words present in [searchText].
// TODO(@amerlo): Evaluate how to order back the results if performed in this way.
Map<String, dynamic> _addSearchText(
    Map<String, dynamic> filters, String searchText) {
  if (searchText != null && searchText != "") {
    // Sanitize filters in case of null map.
    filters = filters != null ? filters : Map();
    filters.putIfAbsent(
        "search",
        () => {
              "op": "array-contains-any",
              "values": searchText.contains(" ")
                  ? searchText.split(" ")
                  : [searchText]
            });
  }
  return filters;
}
