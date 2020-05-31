import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';

import 'package:Poliferie.io/bloc/search_event.dart';
import 'package:Poliferie.io/bloc/search_state.dart';
import 'package:Poliferie.io/repositories/search_client.dart';
import 'package:Poliferie.io/bloc/search_bloc.dart';
import 'package:Poliferie.io/repositories/search_repository.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/screens/item.dart';
import 'package:Poliferie.io/screens/results.dart';

import 'package:Poliferie.io/widgets/poliferie_filter.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';

enum TabType { course, university }

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
    // TODO(@amerlo): Here we should include the whole search state and
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
  /// List of [PoliferieFilter] for courses
  List<PoliferieFilter> courseFilters = courseFilterList;

  /// List of [PoliferieFilter] for universities
  List<PoliferieFilter> universityFilters = courseFilterList;

  Widget _buildFilterList(
      BuildContext context, List<PoliferieFilter> filters, TabType tabType) {
    final double containerWidth = MediaQuery.of(context).size.width -
        AppDimensions.searchBodyPadding.left -
        AppDimensions.searchBodyPadding.right;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          top: 10, bottom: MediaQuery.of(context).padding.bottom + 56),
      child: Wrap(
        children: <Widget>[
          for (var f in filters)
            ClipRect(
              child: SizedBox(
                width: containerWidth > 280
                    ? (containerWidth / 2).floor().toDouble()
                    : containerWidth,
                child: f,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.of(context).padding.bottom + 5),
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
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
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
              _buildFilterList(context, courseFilterList, TabType.course),
              _buildFilterList(context, courseFilterList, TabType.university),
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
