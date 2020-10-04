import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/icons.dart';

import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/bloc/filter.dart';
import 'package:Poliferie.io/models/filter.dart';
import 'package:Poliferie.io/models/item.dart';
import 'package:Poliferie.io/models/item_search.dart';
import 'package:Poliferie.io/repositories/search_repository.dart';
import 'package:Poliferie.io/repositories/filter_repository.dart';
import 'package:Poliferie.io/screens/results.dart';

import 'package:Poliferie.io/widgets/poliferie_filter.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';
import 'package:Poliferie.io/widgets/poliferie_search_delegate.dart';
import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class SearchScreenBody extends StatefulWidget {
  @override
  _SearchScreenBodyState createState() => _SearchScreenBodyState();
}

class FiltersBody extends StatefulWidget {
  final List filters;

  FiltersBody({@required this.filters});

  @override
  _FiltersBodyState createState() => _FiltersBodyState();
}

class _FiltersBodyState extends State<FiltersBody> {
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
      } else if (type == FilterType.selectValue) {
        if (newValue == null) {
          allStatus[index].values = [];
        } else {
          allStatus[index].values.replaceRange(0, 1, newValue);
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
    setState(() {
      allFilters = widget.filters.asMap();
      allStatus = allFilters
          .map((i, f) => MapEntry(i, FilterStatus.initStatus(f.type, f.range)));
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
    });
  }

  // TODO(@amerlo): Should we allow explore session with no filters selected?
  bool couldWeSearch() {
    bool isActive = false;
    for (FilterStatus status in allStatus.values) {
      if (status.selected == true) {
        isActive = true;
        break;
      }
    }
    return isActive;
  }

  Widget _buildFilterList(
      BuildContext context,
      Map<int, Filter> filters,
      Map<int, FilterStatus> status,
      Map<int, Function> updates,
      ItemType tabType) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 56,
      ),
      child: Wrap(
        children: <Widget>[
          ...filters.keys
              .toList()
              .map(
                (key) => PoliferieFilter(
                  filters[key],
                  status[key],
                  updateValue: updates[key],
                ),
              )
              .toList()
        ],
      ),
    );
  }

  /// Call search delegate with selected filters and order query
  void _onPressedExplore() {
    Map<String, dynamic> filters = Map();
    Map<String, dynamic> order = Map();

    // Build Firebase filters map
    allStatus.forEach((i, status) {
      if (status.selected) {
        filters.putIfAbsent(
            allFilters[i].name, () => getFirebaseFilter(allFilters[i], status));
      }
    });

    // Call search delegate
    showSearch(
      context: context,
      delegate: PoliferieSearchDelegate(
        searchBloc: BlocProvider.of<SearchBloc>(context),
        onSearch: (ItemSearch search) {
          // Overwrites search filters and order.
          search =
              ItemSearch(query: search.query, filters: filters, order: order);
          return ResultsScreen(search);
        },
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: PoliferieFloatingButton(
        isActive: couldWeSearch(),
        text: Strings.searchExplore,
        activeColor: Styles.poliferieBlue,
        onPressed: _onPressedExplore,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
}

class _SearchScreenBodyState extends State<SearchScreenBody> {
  Widget _buildFilterHeading() {
    return Text(
      Strings.searchFilterHeading,
      style: Styles.tabHeading,
    );
  }

  Widget _buildTabBar() {
    return PoliferieTabBar();
  }

  Widget _buildTabBarBody(BuildContext context) {
    BlocProvider.of<FilterBloc>(context).add(FetchFilters());
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (BuildContext context, FilterState state) {
        if (state is FetchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is FetchStateSuccess) {
          return FiltersBody(filters: state.filters);
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        return Text('This widget should never be reached');
      },
    );
  }

  Widget _buildSearchScreenBody(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: AppDimensions.bodyPadding,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildFilterHeading(),
            SizedBox(height: 10),
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
          searchBloc: BlocProvider.of<SearchBloc>(context),
          onSearch: (ItemSearch search) => ResultsScreen(search),
        ),
      );
    }

    Widget _buildSearchBar() {
      return Padding(
        padding: EdgeInsets.fromLTRB(AppDimensions.bodyPaddingLeft, 0.0,
            AppDimensions.bodyPaddingRight, 10.0),
        child: PoliferieFloatingButton(
          onPressed: _onPressedSearch,
          text: Strings.searchBarCopy,
          textStyle: Styles.buttonText,
          activeColor: Styles.poliferieWhite,
          isActive: true,
          leading: Icon(
            AppIcons.search,
            color: Styles.poliferieBlack,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PoliferieAppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: _buildSearchBar(),
        ),
      ),
      body: _buildSearchScreenBody(context),
    );
  }
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(
          create: (BuildContext context) => SearchBloc(
              searchRepository:
                  RepositoryProvider.of<SearchRepository>(context)),
        ),
        BlocProvider<FilterBloc>(
          create: (BuildContext context) => FilterBloc(
              filterRepository:
                  RepositoryProvider.of<FilterRepository>(context)),
        ),
      ],
      child: SearchScreenBody(),
    );
  }
}
