import 'package:equatable/equatable.dart';

abstract class TestUserEvent extends Equatable {
  const TestUserEvent([List props = const []]) : super();
}

class TextChanged extends TestUserEvent {
  final String text;

  const TextChanged({this.text});

  @override
  List<Object> get props => [];
}
