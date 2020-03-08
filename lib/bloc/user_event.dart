import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent([List props = const []]) : super();
}

class FetchUser extends UserEvent {
  final String userName;

  const FetchUser({this.userName});

  @override
  List<Object> get props => [userName];
}
