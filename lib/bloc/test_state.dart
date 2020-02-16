import 'package:equatable/equatable.dart';
import 'package:poliferie_platform_flutter/repositories/test_user_client.dart';

abstract class TestUserState extends Equatable {
  const TestUserState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends TestUserState {}

class SearchStateLoading extends TestUserState {}

class SearchStateSuccess extends TestUserState {
  final List<SearchResultItem> items;

  const SearchStateSuccess(this.items);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends TestUserState {
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}
