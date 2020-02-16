import 'package:flutter/material.dart';
import 'package:poliferie_platform_flutter/models/models.dart';
import 'package:poliferie_platform_flutter/strings.dart';

import 'package:poliferie_platform_flutter/styles.dart';

class CourseScreen extends StatefulWidget {
  final CourseModel course;

  CourseScreen({this.course, Key key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  static const _padding = 20.0;

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Styles.poliferieRedAccent),
      title: Text('Corso'.toUpperCase(), style: Styles.searchTabTitle),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          color: Styles.poliferieRedAccent,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCourse(BuildContext context, CourseModel course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(course.university.toUpperCase(), style: Styles.courseSubHeadline),
        Text(course.name, style: Styles.courseHeadline),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(course.descriptionShort),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: IconButton(
                  icon: Icon(
                    course.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: course.isBookmarked
                        ? Styles.poliferieRedAccent
                        : Styles.poliferieDarkGrey,
                  ),
                  onPressed: () {},
                ),
                flex: 1,
              ),
              Expanded(
                // TODO(@amerlo): Update splash color
                child: FlatButton(
                  color: Styles.poliferieRedAccent,
                  textColor: Colors.white,
                  disabledColor: Styles.poliferieLightGrey,
                  disabledTextColor: Styles.poliferieDarkGrey,
                  padding: EdgeInsets.all(8.0),
                  // TODO(@amerlo): Open external URL
                  onPressed: () {},
                  child: Text(
                    Strings.courseHowToApply.toUpperCase(),
                    style: Styles.courseApplyButton,
                  ),
                ),
                flex: 4,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _buildInfo(context, Strings.courseInfo, course.info, null),
              _buildInfo(context, Strings.courseExamination, {},
                  Strings.courseExaminationDesc),
              _buildInfo(
                  context, Strings.courseFacilities, course.facilities, null),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context, String title,
      Map<String, double> courseData, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Styles.poliferieWhite,
            borderRadius: BorderRadius.circular(25.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(description != null ? Icons.info : Icons.storage,
                        color: Styles.poliferieRedAccent),
                    Padding(
                      child: Text(title, style: Styles.courseTabTitle),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    GestureDetector(
                      // TODO(@amerlo): Add showDialag()
                      onTap: () {},
                      child: Icon(Icons.info,
                          color: Styles.poliferieLightGrey, size: 16.0),
                    ),
                  ],
                ),
              ),
              if (description != null)
                RichText(
                  text: TextSpan(
                      text: description, style: Styles.courseDataValue),
                ),
              ...courseData.entries.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: item.key,
                              style: Styles.courseDataHeading,
                              children: <TextSpan>[
                                TextSpan(
                                    text: "\t\t\t${item.value.toString()}",
                                    style: Styles.courseDataValue),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            // TODO(@amerlo): Change with max value
                            child: Text('100'.toString(),
                                style: Styles.courseDataValue),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: LinearProgressIndicator(
                          value: item.value / 100,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CourseModel course) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: _buildCourse(context, widget.course),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, widget.course),
    );
  }
}
