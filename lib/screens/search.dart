import 'package:flutter/material.dart';

import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/screens/course.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/widgets/poliferie_filter.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';

enum TabType { course, university }

///TODO(@amerlo): Mockup data to move
const List<String> _results = <String>[
  'Prova1',
  'Prova2',
];

class PoliferieSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        // TODO(@amerlo): Clear other filter status here
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO(@amerlo): Make API call and update SearchScreenState
    return Column(
      children: <Widget>[
        ListView.builder(
          itemCount: _results.length,
          itemBuilder: (context, index) {
            var _result = _results[index];
            return ListTile(
              title: Text('prv'),
            );
          },
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO(@amerlo): Display auto-complete suggestions
    return Container();
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // In the FrontEnd we just set the parameter for the Search API call to send
  // to the backend, thus we instantiate the filter and the search string text,
  // save into the state and then send the correct API request to the backend.
  // We wait for the reply and show it. We make a new request every time something
  // in the state change.

  // TODO(@amerlo): Remove from here
  static const _paddingItem = 4.0;

  Widget _buildCourseShort(BuildContext context, CourseModel course) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseScreen(course: course)),
        );
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(_paddingItem),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(course.universityLogoPath),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: _paddingItem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                maxLines: 2,
                                text: TextSpan(
                                  text: course.name,
                                  style: Styles.feedPostTitle,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' @ ' + course.university,
                                      style: Styles.feedPostHandle,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 5,
                            ),
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
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _paddingItem),
                        height: 2.0,
                        width: 50.0,
                        color: Styles.poliferieRedAccent,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: _paddingItem),
                        child: Text(
                          course.descriptionShort,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(
                              Icons.people,
                              color: Styles.poliferieLightGrey,
                            ),
                            onPressed: null,
                            label: Text(course.students.toString()),
                          ),
                          FlatButton.icon(
                            icon: Icon(
                              Icons.sentiment_very_satisfied,
                              color: Styles.poliferieLightGrey,
                            ),
                            onPressed: null,
                            label: Text(course.satisfaction.toString()),
                          ),
                          FlatButton.icon(
                            icon: Icon(
                              Icons.monetization_on,
                              color: Styles.poliferieLightGrey,
                            ),
                            onPressed: null,
                            label: Text(course.salary.toString() + ' € / m'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildUniversityShort(
      BuildContext context, UniversityModel university) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(university.imagePath),
      ),
      title: Text(university.name),
      subtitle: Text(university.descriptionShort),
      isThreeLine: true,
      onTap: () {},
      trailing: Icon(Icons.bookmark_border),
    );
  }

  Widget _buildFilterHeading() {
    return Text(
      "Filtri",
      style: Styles.headingTab,
    );
  }

  Widget _buildFilterIntro() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        Strings.searchFilterIntro,
        style: Styles.searchFilterIntro,
      ),
    );
  }

  // Widget _buildFilterList(BuildContext context, List<PoliferieFilter> filters) {
  //   return Container(
  //     height: 50.0,
  //     child: ListView.builder(
  //       physics: BouncingScrollPhysics(),
  //       scrollDirection: Axis.horizontal,
  //       itemCount: filters.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return filters[index];
  //       },
  //     ),
  //   );
  // }

  Widget _buildFilterList(BuildContext context, List<PoliferieFilter> filters) {
    return Expanded(
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: filters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2,
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return filters[index];
        },
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: 50.0),
        child: FloatingActionButton.extended(
          backgroundColor: Styles.poliferieBlue,
          focusColor: Styles.poliferieBlue,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          onPressed: () {},
          label: Text(Strings.searchExplore, style: Styles.searchExplore),
        ),
      ),
    );
  }

  Widget _buildSearchView(
      BuildContext context, List<PoliferieFilter> filters, TabType tabType) {
    return Container(
      height: double.infinity,
      padding: AppDimensions.searchBodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildFilterHeading(),
          _buildFilterIntro(),
          _buildFilterList(context, filters),
          _buildFloatingButton(),
        ],
      ),
    );
  }

  //   Expanded(
  //   child: ListView.builder(
  //     itemCount: _items.length,
  //     itemBuilder: (context, position) {
  //       if (courses != null)
  //         return _buildCourseShort(context, _items[position]);
  //       else
  //         return _buildUniversityShort(context, _items[position]);
  //     },
  //   ),
  // ),

  Widget _buildTabSearchView(BuildContext context) {
    return TabBarView(
      children: [
        _buildSearchView(context, courseFilterList, TabType.course),
        _buildSearchView(context, courseFilterList, TabType.university),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onPressedSearch() {
      showSearch(
        context: context,
        delegate: PoliferieSearchDelegate(),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PoliferieAppBar(
          icon: AppIcons.search,
          bottom: PoliferieTabBar(),
          onPressed: _onPressedSearch,
        ),
        body: _buildTabSearchView(context),
      ),
    );
  }
}
