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
    // Add search term to Bloc
    searchBloc.add(FetchSuggestions(searchText: query));

    return Text('here');
  }

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
          Widget list = ListView.builder(
            itemCount: state.suggestions.length,
            itemBuilder: (context, index) {
              var item = state.suggestions[index];
              return ListTile(
                leading: Icon(
                    item.isCourse() ? AppIcons.course : AppIcons.university),
                onTap: () {},
                title: Text(item.shortName),
              );
            },
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
  final SearchRepository searchRepository;

  SearchScreen({Key key, this.searchRepository}) : super(key: key);

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
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: filters.length,
      itemBuilder: (BuildContext context, int index) {
        return filters[index];
      },
    );
  }

  Widget _buildFloatingButton() {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 50.0),
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
          _buildFloatingButton(),
        ],
      ),
    );
  }

  Widget _buildSearchScreenBody(BuildContext context) {
    return Container(
      padding: AppDimensions.searchBodyPadding,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildFilterHeading(),
          _buildFilterIntro(),
          _buildTabBar(),
          _buildTabBarBody(context),
        ],
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PoliferieAppBar(
          icon: AppIcons.search,
          onPressed: _onPressedSearch,
        ),
        body: _buildSearchScreenBody(context),
      ),
    );
  }
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) =>
          SearchBloc(searchRepository: widget.searchRepository),
      child: SearchScreenBody(),
    );
  }
}
