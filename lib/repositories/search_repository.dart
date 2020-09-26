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

    suggestions = repeat(suggestions, 20); // Repeat list to mimic real data
    suggestions.shuffle();
    return suggestions;
  }

  Future<List<ItemModel>> search(String searchText) async {
    // TODO(@ferrarodav): how will this be with the complete api?
    final returnedJson = await apiProvider
        .fetch(Configs.firebaseItemsCollection); // just for mockup
    List<ItemModel> results = returnedJson
        .map((el) => ItemModel.fromJson(el))
        .toList()
        .cast<ItemModel>();

    results = repeat(results, 20); // Repeat list to mimic real data
    results.shuffle();
    return results;
  }
}
