import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/icons.dart';

import 'package:Poliferie.io/models/filter.dart';
import 'package:Poliferie.io/models/item.dart';
import 'package:Poliferie.io/bloc/search_event.dart';
import 'package:Poliferie.io/bloc/search_state.dart';
import 'package:Poliferie.io/repositories/search_client.dart';
import 'package:Poliferie.io/bloc/search_bloc.dart';
import 'package:Poliferie.io/repositories/search_repository.dart';
import 'package:Poliferie.io/screens/item.dart';
import 'package:Poliferie.io/screens/results.dart';

import 'package:Poliferie.io/widgets/poliferie_filter.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';

// TODO(@amerlo): Move from here
// TODO(@amerlo): Add repository and client to filters
Future<List<Filter>> fetchFilters() async {
  String filterData =
      await rootBundle.loadString("assets/data/mockup/filters.json");
  List<dynamic> suggestions = json.decode(filterData).toList();
  return suggestions.map((e) => Filter.fromJson(e)).toList();
}

/// [SearchDelegate] helper class.
class PoliferieSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;

  PoliferieSearchDelegate({this.searchBloc});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
    // TODO(@ferrarodav): Here we should include the whole search state and
    //                provide it to the results screen
    return ResultsScreen(query);
  }

  // TODO(@amerlo): Add the feature to highlight with bold the search text
  //                in the suggestion name
  @override
  Widget buildSuggestions(BuildContext context) {
    searchBloc.add(FetchSuggestions(searchText: query));

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (BuildContext context, SearchState state) {
        if (state is SearchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is SuggestionStateSuccess) {
          Widget list = Container(
            color: Styles.poliferieWhite,
            child: ListView.builder(
              itemCount: state.suggestions.length,
              itemBuilder: (context, index) {
                var item = state.suggestions[index];
                return ListTile(
                  leading: Icon(
                      item.isCourse() ? AppIcons.course : AppIcons.university),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemScreen(item.id),
                      ),
                    );
                  },
                  title: Text(item.shortName),
                );
              },
            ),
          );
          searchBloc.close();
          return list;
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        return Text('This widget should never be reached');
      },
    );
  }
}

final SearchRepository searchRepository =
    SearchRepository(searchClient: SearchClient(useLocalJson: true));

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class SearchScreenBody extends StatefulWidget {
  @override
  _SearchScreenBodyState createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<SearchScreenBody> {
  // TODO(@amerlo): Use BLoC approach
  /// Map of all [Filter]
  Map<int, Filter> allFilters = Map();
  Map<int, FilterStatus> allStatus = Map();
  Map<int, Function> allUpdate = Map();

  /// Map of course [Filter]
  Map<int, Filter> courseFilters = Map();
  Map<int, FilterStatus> courseStatus = Map();
  Map<int, Function> courseUpdate = Map();

  /// Map of university [Filter]
  Map<int, Filter> universityFilters = Map();
  Map<int, FilterStatus> universityStatus = Map();
  Map<int, Function> universityUpdate = Map();

  // TODO(@amerlo): Could we avoid to duplicate code between here and the
  //                status inside PoliferieFilter?
  void updateFilterStatus(int index, FilterType type, dynamic newValue) {
    setState(() {
      if (type == null) {
        allStatus[index].selected = newValue as bool;
      } else if (type == FilterType.dropDown) {
        if (newValue == null) {
          allStatus[index].values = [];
        } else {
          String newStringValue = newValue as String;
          if (allStatus[index].values.contains(newStringValue)) {
            allStatus[index].values.remove(newStringValue);
          } else {
            allStatus[index].values.add(newStringValue);
          }
        }
      } else if (type == FilterType.selectRange) {
        if (newValue == null) {
          allStatus[index].values =
              FilterStatus.initStatus(type, allFilters[index].range).values;
        } else {
          RangeValues newRangeValues = (newValue as RangeValues);
          allStatus[index].values = [newRangeValues.start, newRangeValues.end];
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFilters().then((l) => setState(() {
          allFilters = l.asMap();
          allStatus = allFilters.map(
              (i, f) => MapEntry(i, FilterStatus.initStatus(f.type, f.range)));
          allUpdate = allStatus.map((i, s) => MapEntry(
              i,
              (FilterType type, dynamic newValue) =>
                  updateFilterStatus(i, type, newValue)));
          allFilters.forEach((key, value) {
            if (value.applyTo.contains(ItemType.course)) {
              courseFilters[key] = value;
              courseStatus[key] = allStatus[key];
              courseUpdate[key] = allUpdate[key];
            }
            if (value.applyTo.contains(ItemType.university)) {
              universityFilters[key] = value;
              universityStatus[key] = allStatus[key];
              universityUpdate[key] = allUpdate[key];
            }
          });
        }));
  }

  // TODO(@amerlo): Should we use the full width for the filters?
  Widget _buildFilterList(
      BuildContext context,
      Map<int, Filter> filters,
      Map<int, FilterStatus> status,
      Map<int, Function> updates,
      ItemType tabType) {
    final double containerWidth = MediaQuery.of(context).size.width -
        AppDimensions.searchBodyPadding.left -
        AppDimensions.searchBodyPadding.right;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          top: 10, bottom: MediaQuery.of(context).padding.bottom + 56),
      child: Wrap(
        children: <Widget>[
          for (var i in filters.keys)
            ClipRect(
              child: SizedBox(
                width: containerWidth > 280
                    ? (containerWidth / 2).floor().toDouble()
                    : containerWidth,
                child: PoliferieFilter(filters[i], status[i],
                    updateValue: updates[i]),
              ),
            )
        ],
      ),
    );
  }

  // TODO(@amerlo): Input select state given filter states
  Widget _buildFloatingButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.of(context).padding.bottom + 10),
      child: PoliferieFloatingButton(
        text: Strings.searchExplore,
        activeColor: Styles.poliferieBlue,
        onPressed: () {},
      ),
    );
  }

  Widget _buildFilterHeading() {
    return Text(
      Strings.searchFilterHeading,
      style: Styles.tabHeading,
    );
  }

  Widget _buildFilterIntro() {
    return Padding(
      padding: AppDimensions.subHeadlinePadding,
      child: Text(
        Strings.searchFilterIntro,
        style: Styles.tabDescription,
      ),
    );
  }

  Widget _buildTabBar() {
    return PoliferieTabBar();
  }

  Widget _buildTabBarBody(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildFilterList(context, courseFilters, courseStatus,
                  courseUpdate, ItemType.course),
              _buildFilterList(context, universityFilters, universityStatus,
                  universityUpdate, ItemType.university),
            ],
          ),
          _buildFloatingButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchScreenBody(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: AppDimensions.searchBodyPadding,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildFilterHeading(),
            _buildFilterIntro(),
            SizedBox(height: 20),
            _buildTabBar(),
            _buildTabBarBody(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onPressedSearch() {
      showSearch(
        context: context,
        delegate: PoliferieSearchDelegate(
            searchBloc: BlocProvider.of<SearchBloc>(context)),
      );
    }

    return Scaffold(
      appBar: PoliferieAppBar(
        icon: AppIcons.search,
        onPressed: _onPressedSearch,
      ),
      body: _buildSearchScreenBody(context),
    );
  }
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(searchRepository: searchRepository),
      child: SearchScreenBody(),
    );
  }
}
