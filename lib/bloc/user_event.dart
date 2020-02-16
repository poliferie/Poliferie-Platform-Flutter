import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

abstract class UserEvent extends Equatable {
  const UserEvent([List props = const []]) : super();
}

class ViewScreen extends UserEvent {
  final String userName;

  const ViewScreen({this.userName});

  @override
  List<Object> get props => [];
}
