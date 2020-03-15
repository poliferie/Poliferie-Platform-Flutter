import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent([List props = const []]) : super();
}

class FetchSuggestions extends SearchEvent {
  final String searchText;

  const FetchSuggestions({this.searchText});

  @override
  List<Object> get props => [searchText];
}

class FetchSearch extends SearchEvent {
  final String searchText;

  const FetchSearch({this.searchText});

  @override
  List<Object> get props => [searchText];
}
