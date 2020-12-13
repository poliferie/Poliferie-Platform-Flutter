import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/utils.dart';
import 'package:Poliferie.io/configs.dart';

import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/bloc/filter.dart';
import 'package:Poliferie.io/models/filter.dart';
import 'package:Poliferie.io/models/item_search.dart';
import 'package:Poliferie.io/repositories/search_repository.dart';
import 'package:Poliferie.io/repositories/filter_repository.dart';
import 'package:Poliferie.io/screens/results.dart';
import 'package:Poliferie.io/screens/item.dart';

import 'package:Poliferie.io/widgets/poliferie_filter.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';
import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';
import 'package:Poliferie.io/widgets/poliferie_search_bar.dart';

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

  FiltersBody({@required this.filters, Key key}) : super(key: key);

  @override
  _FiltersBodyState createState() => _FiltersBodyState();
}

class _FiltersBodyState extends State<FiltersBody> {
  /// Map of all [Filter]
  Map<int, Filter> allFilters = Map();
  Map<int, FilterStatus> allStatus = Map();
  Map<int, Function> allUpdate = Map();

  // TODO(@amerlo): Could we avoid to duplicate code between here and the
  //                status inside PoliferieFilter?
  void updateFilterStatus(int index, FilterType type, dynamic newValue) {
    setState(() {
      if (type == null) {
        allStatus[index].selected = newValue as bool;
        if (allFilters[index].type == FilterType.selectRange) {
          if ((newValue as bool) == true) {
            disableAllRangesBut(index);
          } else {
            enableAllRanges();
          }
        }
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

  void disableAllRangesBut(int index) {
    allFilters.forEach((i, filter) {
      if (i != index && filter.type == FilterType.selectRange) {
        allStatus[i].available = false;
      }
    });
  }

  void enableAllRanges() {
    allFilters.forEach((i, filter) {
      if (filter.type == FilterType.selectRange) {
        allStatus[i].available = true;
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

  Widget _buildFilterList(BuildContext context, Map<int, Filter> filters,
      Map<int, FilterStatus> status, Map<int, Function> updates) {
    return Wrap(
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
    );
  }

  Map<String, dynamic> _getFilters() {
    Map<String, dynamic> filters = Map();

    // Build Firebase filters map
    allStatus.forEach((i, status) {
      if (status.selected) {
        filters.putIfAbsent(allFilters[i].field,
            () => getFirebaseFilter(allFilters[i], status));
      }
    });

    return filters;
  }

  /// Call search delegate with selected filters and order query
  void _onPressedExplore() {
    Map<String, dynamic> filters = _getFilters();
    Map<String, dynamic> order;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          ItemSearch(
            query: "",
            filters: filters,
            order: order,
            limit: Configs.firebaseItemsLimit,
          ),
        ),
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
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.of(context).padding.bottom + 56,
                ),
                child: _buildFilterList(
                    context, allFilters, allStatus, allUpdate)),
          ),
          _buildFloatingButton(context),
        ],
      ),
    );
  }
}

class _SearchScreenBodyState extends State<SearchScreenBody> {
  final TextEditingController searchController = TextEditingController();

  // Global key to retrieve filters state.
  final GlobalKey<_FiltersBodyState> _filtersState =
      GlobalKey<_FiltersBodyState>();

  Widget _buildFilterHeading() {
    return Text(
      Strings.searchFilterHeading,
      style: Styles.tabHeading,
    );
  }

  Widget _buildFiltersBody(BuildContext context) {
    BlocProvider.of<FilterBloc>(context).add(FetchFilters());
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (BuildContext context, FilterState state) {
        if (state is FetchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is FetchStateSuccess) {
          return FiltersBody(filters: state.filters, key: _filtersState);
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        return Text('This widget should never be reached');
      },
    );
  }

  Widget _buildSearchScreenBody(BuildContext context) {
    return Container(
      padding: AppDimensions.bodyPadding,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildFilterHeading(),
          SizedBox(height: 10),
          _buildFiltersBody(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        child: PoliferieSearchBar(
          label: Strings.searchBarCopy,
          controller: searchController,
          loadSuggestions: () async {
            return await RepositoryProvider.of<SearchRepository>(context).suggest(
                searchController.text,
                filters: _filtersState.currentState._getFilters(),
                // TODO(@amerlo): Indices have to be created for each filter field.
                // order: {
                //   "type": {"descending": true}
                // },
                limit: Configs.firebaseSuggestionsLimit);
          },
          suggestionCallback: (suggestion) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(suggestion.id),
              ),
            );
          },
          onSearch: (query) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(
                  ItemSearch(
                    query: query,
                    filters: _filtersState.currentState._getFilters(),
                    limit: Configs.firebaseItemsLimit,
                  ),
                ),
              ),
            );
            searchController.text = "";
            searchController.notifyListeners();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return keyboardDismisser(
        child: Scaffold(
          appBar: PoliferieAppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + 10),
              //child: _buildSearchBar(),
              child: _buildSearchBar(context),
            ),
          ),
          body: _buildSearchScreenBody(context),
        ),
        context: context);
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
