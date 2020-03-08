import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/models.dart';

abstract class CardState extends Equatable {
  const CardState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class FetchStateLoading extends CardState {}

class FetchStateSuccess extends CardState {
  final List<CardInfo> cards;

  const FetchStateSuccess(this.cards);

  @override
  List<Object> get props => [cards];

  @override
  String toString() => 'SearchStateSuccess { card: $cards}';
}

class FetchStateError extends CardState {
  final String error;

  const FetchStateError(this.error);

  @override
  List<Object> get props => [error];
}
