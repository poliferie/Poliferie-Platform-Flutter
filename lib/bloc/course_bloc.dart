import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Poliferie.io/bloc/course_event.dart';
import 'package:Poliferie.io/bloc/course_state.dart';
import 'package:Poliferie.io/repositories/course_repository.dart';
import 'package:Poliferie.io/models/course.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository courseRepository;

  CourseBloc({this.courseRepository}) : assert(courseRepository != null);

  @override
  Stream<CourseState> transformEvents(
    Stream<CourseEvent> events,
    Stream<CourseState> Function(CourseEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  // TODO(@amerlo): Include more details for the transition here
  @override
  void onTransition(Transition<CourseEvent, CourseState> transition) {
    print(transition);
  }

  @override
  CourseState get initialState => FetchStateLoading();

  @override
  Stream<CourseState> mapEventToState(CourseEvent event) async* {
    if (event is FetchCourse) {
      yield FetchStateLoading();
      try {
        final CourseModel course = await courseRepository.fetch(event.courseId);
        yield FetchStateSuccess(course);
      } catch (error) {
        yield FetchStateError(error.message);
      }
    }
  }
}
