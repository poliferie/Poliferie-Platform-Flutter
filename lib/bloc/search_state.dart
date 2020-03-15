import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/models.dart';

abstract class SearchState extends Equatable {
  const SearchState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class SearchStateLoading extends SearchState {}

class SearchStateSuccess extends SearchState {
  final List<CourseModel> courses;
  final List<UniversityModel> universities;

  const SearchStateSuccess(this.courses, this.universities);

  @override
  List<Object> get props => [courses, universities];

  @override
  String toString() =>
      'SearchStateSuccess { courses: $courses, universities: $universities}';
}

class SuggestionStateSuccess extends SearchState {
  final List<SearchSuggestion> suggestions;

  const SuggestionStateSuccess(this.suggestions);

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'SuggestionsStateSuccess { suggestions: $suggestions}';
}

// Generic search state error
class SearchStateError extends SearchState {
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}
