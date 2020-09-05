import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/item.dart';

abstract class ItemState extends Equatable {
  const ItemState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class FetchStateLoading extends ItemState {}

class FetchStateSuccess extends ItemState {
  final List<ItemModel> items;

  const FetchStateSuccess(this.items);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'FetchStateSuccess { item: $items}';
}

class FetchStateError extends ItemState {
  final String error;

  const FetchStateError(this.error);

  @override
  List<Object> get props => [error];
}
