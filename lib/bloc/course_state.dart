import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/course.dart';

abstract class CourseState extends Equatable {
  const CourseState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class FetchStateLoading extends CourseState {}

class FetchStateSuccess extends CourseState {
  final CourseModel course;

  const FetchStateSuccess(this.course);

  @override
  List<Object> get props => [course];

  @override
  String toString() => 'FetchStateSuccess { course: $course}';
}

class FetchStateError extends CourseState {
  final String error;

  const FetchStateError(this.error);

  @override
  List<Object> get props => [error];
}
