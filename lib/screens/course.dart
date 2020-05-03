import 'package:Poliferie.io/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/course.dart';
import 'package:Poliferie.io/models/models.dart';

import 'package:Poliferie.io/styles.dart';

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

Widget _buildBackButton(BuildContext context) {
  return Positioned(
    top: 20.0,
    left: -10.0,
    child: MaterialButton(
        color: Styles.poliferieWhite,
        shape: CircleBorder(),
        child: Icon(
          Icons.arrow_back_ios,
          color: Styles.poliferieLightGrey,
        ),
        onPressed: () {
          {
            Navigator.pop(context);
          }
        }),
  );
}

Widget _buildImage(CourseModel course) {
  return Image(
    image: AssetImage(course.universityImagePath),
  );
}

Widget _buildCourseHeader(BuildContext context, CourseModel course) {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      _buildImage(course),
      _buildBackButton(context),
    ],
  );
}

// TODO(@amerlo): This needs to be moved up
Widget _buildFavorite(CourseModel course) {
  return Align(
    alignment: Alignment.topRight,
    child: MaterialButton(
      color: Styles.poliferieWhite,
      shape: CircleBorder(),
      padding: EdgeInsets.all(6.0),
      child: Icon(course.isBookmarked ? Icons.favorite : Icons.favorite_border,
          color: Styles.poliferieRed, size: 32),
      onPressed: () {},
    ),
  );
}

Widget _buildInfo(CourseModel course) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(course.shortName.toUpperCase(), style: Styles.courseHeadline),
      Text(course.university, style: Styles.courseSubHeadline),
      Padding(
        padding: EdgeInsetsDirectional.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.location_on, color: Styles.poliferieRed),
            Text(course.region, style: Styles.courseLocation)
          ],
        ),
      ),
    ],
  );
}

// TODO(@amerlo): Fix it!
Widget _buildStats(CourseModel course) {
  // final Map<String, dynamic> infoMap = {
  //   course.info.duration: Icons.looks_one,
  //   course.info.language: Icons.language,
  //   course.info.requirements: Icons.card_membership,
  //   course.info.owner: Icons.lock,
  //   course.info.access: Icons.check_circle,
  //   course.info.education: Icons.recent_actors,
  // };
  return Text("TODO");
  // return Container(
  //   height: 200,
  //   child: GridView.count(
  //     crossAxisCount: 3,
  //     children: infoMap.keys.map((String text) {
  //       return GridTile(
  //         header: Text(text),
  //         child: Text(text),
  //       );
  //     }).toList(),
  //   ),
  // );
}

Widget _buildCourseBody(BuildContext context, CourseModel course) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: AppDimensions.bodyPaddingLeft),
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Styles.poliferieWhite),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildFavorite(course),
        _buildInfo(course),
        _buildStats(course)
      ],
    ),
  );
}

class _CourseScreenBodyState extends State<CourseScreenBody> {
  Widget _buildBody(BuildContext context, CourseModel course) {
    return Column(
      children: <Widget>[
        _buildCourseHeader(context, course),
        _buildCourseBody(context, course)
      ],
    );
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
