import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/configs.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/providers/local_provider.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item.dart';

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

    final returnedJson = await apiProvider.fetch(
        Configs.firebaseSuggestionsCollection,
        filters: filters,
        order: order,
        limit: limit);
    List<SearchSuggestion> suggestions = returnedJson
        .map((e) => SearchSuggestion.fromJson(e))
        .toList()
        .cast<SearchSuggestion>();

    // Orders results based on number of matched keywords.
    Set<String> searchKeywords = Set.from(
        searchText.contains(" ") ? searchText.split(" ") : [searchText]);
    int _countMatches(List<String> keywords, String searchText) {
      return Set.from(keywords).intersection(searchKeywords).length;
    }

    // Keeps ascending order.
    suggestions.sort((a, b) => -_countMatches(a.search, searchText)
        .compareTo(_countMatches(b.search, searchText)));

    return suggestions;
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

    final returnedJson = await apiProvider.fetch(
        Configs.firebaseItemsCollection,
        filters: filters,
        order: order,
        limit: limit);
    List<ItemModel> results = returnedJson
        .map((el) => ItemModel.fromJson(el))
        .toList()
        .cast<ItemModel>();

    return results;
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
