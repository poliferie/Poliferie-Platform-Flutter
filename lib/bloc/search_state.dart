import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/models.dart';

abstract class SearchState extends Equatable {
  const SearchState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class SearchStateLoading extends SearchState {}

class SearchStateSuccess extends SearchState {
  final List<ItemModel> results;

  const SearchStateSuccess(this.results);

  @override
  List<Object> get props => [results];

  @override
  String toString() => 'SearchStateSuccess { results: $results}';
}

class SuggestionStateSuccess extends SearchState {
  final List<SearchSuggestion> suggestions;

  const SuggestionStateSuccess(this.suggestions);

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'SuggestionsStateSuccess { suggestions: $suggestions}';
}

class SearchStateError extends SearchState {
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}
