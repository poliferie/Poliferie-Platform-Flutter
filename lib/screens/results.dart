import 'package:Poliferie.io/configs.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/utils.dart';

import 'package:Poliferie.io/bloc/search_bloc.dart';
import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/screens/item.dart';

import 'package:Poliferie.io/widgets/poliferie_item_card.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';
import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';
import 'package:Poliferie.io/widgets/poliferie_search_bar.dart';

final List<String> ordersResults = ['Popolare', 'Nuovo'];

class ResultsScreen extends StatefulWidget {
  final ItemSearch search;

  const ResultsScreen(this.search, {Key key}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class ResultsScreenBody extends StatefulWidget {
  final ItemSearch search;

  final FavoritesRepository favoritesRepository;

  ResultsScreenBody({this.search, @required this.favoritesRepository});

  @override
  _ResultsScreenBodyState createState() => _ResultsScreenBodyState();
}

class _ResultsScreenBodyState extends State<ResultsScreenBody> {
  /// List of favorite items
  List<String> _favoriteItems;

  /// Hack to flag first loading
  Map<ItemType, bool> _initialized;

  /// Hack to separate tab loadings
  Map<ItemType, SearchBloc> _searchBlocs;

  /// Results order
  String _selectedOrder;

  @override
  void initState() {
    super.initState();
    _updateFavorites();
    _initialized = {ItemType.course: false, ItemType.university: false};
    _selectedOrder = ordersResults[0];
  }

  void _updateFavorites({String toggleIndex}) async {
    if (toggleIndex != null)
      await widget.favoritesRepository.toggle(toggleIndex);
    final List<String> favorites = await widget.favoritesRepository.get();
    setState(() {
      _favoriteItems = favorites;
    });
  }

  Widget _buildResultsList(List<ItemModel> results) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          ...results
              .map((item) => Padding(
                    child: PoliferieItemCard(
                      item,
                      isFavorite: _favoriteItems.contains(item.id),
                      onSetFavorite: () =>
                          _updateFavorites(toggleIndex: item.id),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                  ))
              .toList(),
        ],
      ),
    );
  }

  // TODO(@amerlo): Can we re-use the code from poliferie_filter.dart?
  Widget _buildActionHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: AppDimensions.bottomSheetPadding,
          child: PoliferieIconBox(
            Icons.filter_list,
            iconColor: Styles.poliferieRed,
          ),
        ),
        Text(
          Strings.resultsOrderHeading,
          style: Styles.filterHeadline,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildActionDescription() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppDimensions.bottomSheetPaddingHorizontal,
          10.0, AppDimensions.bottomSheetPaddingHorizontal, 10.0),
      child: Text(
        Strings.resultsOrderDescription,
        style: Styles.tabDescription,
      ),
    );
  }

  Future<Null> updateBottomSheetState(
      StateSetter updateState, dynamic newOrder) async {
    updateState(() {
      _selectedOrder = newOrder;
    });
  }

  Widget _buildActionSelector(StateSetter updateState) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        itemCount: ordersResults.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                updateBottomSheetState(updateState, ordersResults[index]);
              },
              leading: _selectedOrder == ordersResults[index]
                  ? Icon(Icons.check_box, color: Styles.poliferieRed)
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Styles.poliferieVeryLightGrey,
                    ),
              title: Text(ordersResults[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheet(StateSetter updateState) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.bodyPaddingLeft,
        AppDimensions.bottomSheetPaddingVertical,
        AppDimensions.bodyPaddingRight,
        0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildActionHeading(),
          _buildActionDescription(),
          _buildActionSelector(updateState),
        ],
      ),
    );
  }

  void _onActionPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
              child: _buildBottomSheet(state),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Strings.resultsHeading,
          style: Styles.tabHeading,
        ),
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.filter_list), onPressed: _onActionPressed),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBody(BuildContext context, ItemType tabType) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBlocs[tabType],
      builder: (BuildContext context, SearchState state) {
        if (state is SearchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSearchActions(),
              _buildResultsList(state.results),
            ],
          );
        }
        return Text('This widge should never be reached');
      },
    );
  }

  Widget _buildTabBar() {
    return PoliferieTabBar();
  }

  _eventuallyInitTab(ItemType tabType) {
    // This is an hack not to re-fetch results once done once.
    if (!_initialized[tabType]) {
      Map<String, dynamic> _filters =
          Map<String, dynamic>.from(widget.search.filters ?? {});
      _filters['type'] = {
        "op": "==",
        "values": tabType == ItemType.university ? 'university' : 'course'
      };

      _searchBlocs[tabType].add(FetchSearch(
        searchText: widget.search.query,
        filters: _filters,
        order: widget.search.order,
        limit: widget.search.limit,
      ));
      setState(() {
        _initialized[tabType] = true;
      });
    }
  }

  Widget _buildResultsBody(BuildContext context) {
    TabController tabController = DefaultTabController.of(context);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        ItemType tabType =
            tabController.index == 0 ? ItemType.course : ItemType.university;
        _eventuallyInitTab(tabType);
      }
    });

    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildTabBody(context, ItemType.course),
          _buildTabBody(context, ItemType.university),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_searchBlocs == null) {
      _searchBlocs = {};
      _searchBlocs[ItemType.course] = SearchBloc(
          searchRepository: RepositoryProvider.of<SearchRepository>(context));
      _searchBlocs[ItemType.university] = SearchBloc(
          searchRepository: RepositoryProvider.of<SearchRepository>(context));
    }
    _eventuallyInitTab(ItemType.course);
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Container(
        padding: AppDimensions.bodyPadding,
        height: double.infinity,
        color: Styles.poliferieWhite,
        child: Builder(
          builder: (BuildContext context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTabBar(),
              _buildResultsBody(context),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsScreenState extends State<ResultsScreen> {
  final TextEditingController searchController = TextEditingController();

  Widget _buildSearchBar(BuildContext context) {
    searchController.text = widget.search.query;
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        child: PoliferieSearchBar(
          label: Strings.searchBarCopy,
          controller: searchController,
          loadSuggestions: () async {
            return await RepositoryProvider.of<SearchRepository>(context)
                .suggest(searchController.text,
                    order: {
                      "type": {"descending": true}
                    },
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
                      filters: widget.search.filters,
                      limit: Configs.firebaseItemsLimit),
                ),
              ),
            );
            searchController.text = widget.search.query;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: keyboardDismisser(
        context: context,
        child: Scaffold(
          appBar: PoliferieAppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + 10),
              child: _buildSearchBar(context),
            ),
          ),
          body: ResultsScreenBody(
              search: widget.search,
              favoritesRepository:
                  RepositoryProvider.of<FavoritesRepository>(context)),
        ),
      ),
    );
  }
}
