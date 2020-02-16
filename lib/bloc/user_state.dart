import 'package:equatable/equatable.dart';
import 'package:poliferie_platform_flutter/models/models.dart';

abstract class UserState extends Equatable {
  const UserState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

// TODO(@amerlo): Check if empty and loading are needed
class FetchStateEmpty extends UserState {}

class FetchStateLoading extends UserState {}

class FetchStateSuccess extends UserState {
  final User user;

  const FetchStateSuccess(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'SearchStateSuccess { user: $user }';
}

class FetchStateError extends UserState {
  final String error;

  const FetchStateError(this.error);

  @override
  List<Object> get props => [error];
}
