import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent([List props = const []]) : super();
}

class FetchCourse extends CourseEvent {
  final int courseId;

  const FetchCourse(this.courseId);

  @override
  List<Object> get props => [courseId];
}
