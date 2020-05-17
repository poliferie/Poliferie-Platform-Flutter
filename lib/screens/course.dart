import 'package:Poliferie.io/utils.dart';
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

class _CourseScreenBodyState extends State<CourseScreenBody> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _setFavoriteCourses();
  }

  void _setFavoriteCourses() async {
    final List<dynamic> favoriteCourses =
        await getPersistenceList('favorite_courses');
    setState(() {
      _isFavorite = favoriteCourses.contains(widget.id);
    });
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
        Positioned(child: _buildFavorite(course), right: 0, bottom: 0),
      ],
    );
  }

// TODO(@amerlo): This needs to be moved up
  Widget _buildFavorite(CourseModel course) {
    return MaterialButton(
      color: Styles.poliferieWhite,
      shape: CircleBorder(),
      padding: EdgeInsets.all(6.0),
      child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Styles.poliferieRed, size: 40),
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
          if (_isFavorite) {
            addToPersistenceList('favorite_courses', widget.id);
          } else {
            removeFromPersistenceList('favorite_courses', widget.id);
          }
        });
      },
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

  Widget _buildList(String title, List<Card> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Styles.tabHeading),
        PoliferieAnimatedList(items: items),
      ],
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
      padding: AppDimensions.bodyPadding,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Styles.poliferieWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildInfo(course),
          _buildStats(course),
          _buildDescription(course),
          _buildList('Opportunità', opportunity),
          _buildList('Mobilità', opportunity),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CourseModel course) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildCourseHeader(context, course),
        _buildCourseBody(context, course),
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
