import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/providers/local_provider.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item.dart';
import 'package:Poliferie.io/utils.dart';
import 'package:Poliferie.io/configs.dart';

class SearchRepository {
  final ApiProvider apiProvider;
  final LocalProvider localProvider;

  SearchRepository({@required this.apiProvider, this.localProvider})
      : assert(apiProvider != null);

  Future<List<SearchSuggestion>> suggest(String searchText) async {
    // TODO(@ferrarodav): how will this be with the complete api?
    final returnedJson =
        await apiProvider.fetch(Configs.firebaseSuggestionsCollection);
    List<SearchSuggestion> suggestions = returnedJson
        .map((el) => SearchSuggestion.fromJson(el))
        .toList()
        .cast<SearchSuggestion>();

    suggestions = repeat(suggestions, 20);
    suggestions.shuffle();
    return suggestions;
  }

  /// Returns the results for the Firebase query given the [searchText].
  ///
  /// A set of [filters] and a specifc [order] could be optionally given.
  Future<List<ItemModel>> search(String searchText,
      {Map<String, dynamic> filters, Map<String, dynamic> order}) async {
    // Builds the Firebase search query based on [searchText].
    // TODO(@amerlo): Evaluate how to order back the results if performed in this way.
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

    print(filters);

    final returnedJson = await apiProvider
        .fetch(Configs.firebaseItemsCollection, filters: filters, order: order);
    List<ItemModel> results = returnedJson
        .map((el) => ItemModel.fromJson(el))
        .toList()
        .cast<ItemModel>();

    // TODO(@amerlo): Remove this.
    // Repeats results list in order to mimic real data.
    results = repeat(results, 20);
    results.shuffle();

    return results;
  }
}
