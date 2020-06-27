import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/models.dart';

abstract class FilterState extends Equatable {
  const FilterState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class FetchStateLoading extends FilterState {}

class FetchStateSuccess extends FilterState {
  final List<Filter> filters;

  const FetchStateSuccess(this.filters);

  @override
  List<Object> get props => [filters];

  @override
  String toString() => 'FetchStateSuccess { filter: $filters}';
}

class FetchStateError extends FilterState {
  final String error;

  const FetchStateError(this.error);

  @override
  List<Object> get props => [error];
}
