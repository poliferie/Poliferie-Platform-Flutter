import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/course.dart';
import 'package:Poliferie.io/models/models.dart';

// TODO(@amerlo): Where the repositories have to be declared?
final CourseRepository courseRepository =
    CourseRepository(courseClient: CourseClient(useLocalJson: true));

class CourseScreen extends StatefulWidget {
  /// This [id] is the requested id from the frontend
  final int id;

  const CourseScreen(this.id, {Key key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class CourseScreenBody extends StatefulWidget {
  // TODO(@amerlo): Could we avoid this?
  final int id;

  CourseScreenBody(this.id);

  @override
  _CourseScreenBodyState createState() => _CourseScreenBodyState();
}

class _CourseScreenBodyState extends State<CourseScreenBody> {
  Widget _buildBody(BuildContext context, CourseModel course) {
    return Text(course.shortName);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CourseBloc>(context).add(FetchCourse(widget.id));

    return BlocBuilder<CourseBloc, CourseState>(
      builder: (BuildContext context, CourseState state) {
        if (state is FetchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        if (state is FetchStateSuccess) {
          return _buildBody(context, state.course);
        }
        return Text('This widge should never be reached');
      },
    );
  }
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CourseBloc>(
        create: (context) => CourseBloc(courseRepository: courseRepository),
        child: CourseScreenBody(widget.id),
      ),
    );
  }
}
