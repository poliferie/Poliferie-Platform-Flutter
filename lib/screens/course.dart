import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/widgets/poliferie_animated_list.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/course.dart';
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';

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
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
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

Widget _buildStats(CourseModel course) {
  final Map<String, dynamic> infoMap = {
    course.duration.toString(): Icons.looks_one,
    course.language: Icons.language,
    course.requirements: Icons.card_membership,
    course.owner: Icons.lock,
    course.access: Icons.check_circle,
    course.education: Icons.recent_actors,
  };
  // TODO(@amerlo): How to scale height dynamically?
  return Container(
    height: 120,
    child: GridView.count(
      padding: EdgeInsets.all(0.0),
      crossAxisCount: 3,
      childAspectRatio: 2,
      children: infoMap.keys.map((String text) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: PoliferieIconBox(
                infoMap[text],
                iconColor: Styles.poliferieRed,
                iconSize: 18.0,
              ),
            ),
            Text(
              text,
              style: Styles.courseInfoStats,
            ),
          ],
        );
      }).toList(),
    ),
  );
}

Widget _buildDescription(CourseModel course) {
  return Padding(
    padding: AppDimensions.betweenTabs,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(Strings.courseDescription, style: Styles.tabHeading),
        Text(course.shortDescription, style: Styles.tabDescription),
      ],
    ),
  );
}

Widget _buildCourseBody(BuildContext context, CourseModel course) {
  // TODO(@amerlo): Move to an helper class to build the list from course stats.
  List<Card> opportunity = <Card>[
    Card(
      elevation: 0.0,
      child: ListTile(
        title: Text('Soddisfazione', style: Styles.statsTitle),
        subtitle: Text('Percentuale di soddisfazione per il corso di laurea',
            style: Styles.statsDescription),
        trailing: CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 3.0,
          percent: course.satisfaction / 100,
          center: Text(
            course.satisfaction.toString(),
            style: Styles.statsValue,
          ),
          progressColor: Colors.green,
        ),
      ),
    ),
    Card(
      elevation: 0.0,
      child: ListTile(
        title: Text('Stipendio mensile netto', style: Styles.statsTitle),
        subtitle: Text('Stipendio mensile netto medio a 5 anni dal titolo',
            style: Styles.statsDescription),
        trailing:
            Text(course.salary.toString() + '€', style: Styles.statsValue),
      ),
    ),
  ];

  return Container(
    padding: EdgeInsets.fromLTRB(AppDimensions.bodyPaddingLeft, 0.0,
        AppDimensions.bodyPaddingRight, AppDimensions.bodyPaddingBottom),
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
        _buildStats(course),
        _buildDescription(course),
        PoliferieAnimatedList(title: 'Opportunità', items: opportunity),
        PoliferieAnimatedList(title: 'Mobilità', items: opportunity),
      ],
    ),
  );
}

class _CourseScreenBodyState extends State<CourseScreenBody> {
  Widget _buildBody(BuildContext context, CourseModel course) {
    return ListView(
      scrollDirection: Axis.vertical,
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
