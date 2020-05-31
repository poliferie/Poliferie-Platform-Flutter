import 'dart:async';
import 'package:Poliferie.io/models/item.dart';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/repositories/search_client.dart';

class SearchRepository {
  final SearchClient searchClient;

  SearchRepository({@required this.searchClient})
      : assert(searchClient != null);

  Future<List<SearchSuggestion>> fetchSuggestions(String searchText) async {
    return await searchClient.fetchSuggestions(searchText);
  }

  Future<List<ItemModel>> fetchSearch(String searchText) async {
    return await searchClient.fetchSearch(searchText);
  }
}
