import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent([List props = const []]) : super();
}

class FetchCards extends CardEvent {
  const FetchCards();

  @override
  List<Object> get props => [];
}
