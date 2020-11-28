import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/configs.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/providers/local_provider.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item.dart';

// TODO(@amerlo): Define generic method for both search and suggestion fetch() ones.

///Orders [results] based on number of matched keywords given [searchText].
_orderResults(dynamic results, String searchText) {
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
    filters = _addSearchText(filters, searchText);

    List<SearchSuggestion> suggestions = [];

    // Search for in filter.
    MapEntry<String, dynamic> _inFilter = filters.entries
        .singleWhere((e) => e.value["op"] == "in", orElse: () => null);

    // See fetch() for reference.
    if (searchText != "" && _inFilter != null) {
      for (String value in _inFilter.value["values"]) {
        Map<String, dynamic> _filters = filters;
        _filters.remove(_inFilter.key);
        _filters[_inFilter.key] = {"op": "==", "values": value};
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

    final returnedJson = await apiProvider.fetch(
        Configs.firebaseSuggestionsCollection,
        filters: filters,
        order: order,
        limit: limit);
    suggestions = returnedJson
        .map((e) => SearchSuggestion.fromJson(e))
        .toList()
        .cast<SearchSuggestion>();

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

    // Firebase does not allow to perform some combination of queries.
    // Detect them here and combine multiple query results together.
    // This is an hack, but for now it works.
    //
    // Firebase not valid queries supported are:
    // * searchText (array-contains-any) with in

    // Search for in filter.
    MapEntry<String, dynamic> _inFilter = filters.entries
        .singleWhere((e) => e.value["op"] == "in", orElse: () => null);

    if (searchText != "" && _inFilter != null) {
      for (String value in _inFilter.value["values"]) {
        Map<String, dynamic> _filters = filters;
        _filters.remove(_inFilter.key);
        _filters[_inFilter.key] = {"op": "==", "values": value};
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
