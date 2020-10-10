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
  bool _initialized;

  /// Results order
  String _selectedOrder;

  @override
  void initState() {
    super.initState();
    _updateFavorites();
    _initialized = false;
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
                    padding: EdgeInsets.only(bottom: 10.0),
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

  Widget _buildTabBody(
      BuildContext context, List<ItemModel> results, ItemType tabType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSearchActions(),
        _buildResultsList(results),
      ],
    );
  }

  Widget _buildTabBar() {
    return PoliferieTabBar();
  }

  Widget _buildResultsBody(BuildContext context, List<ItemModel> results) {
    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildTabBody(
              context,
              results.where((item) => item.type == ItemType.course).toList(),
              ItemType.course),
          _buildTabBody(
              context,
              results
                  .where((item) => item.type == ItemType.university)
                  .toList(),
              ItemType.university),
        ],
      ),
    );
  }

  // TODO(@amerlo): Change results to courseResults and providerResults
  Widget _buildBody(BuildContext context, List<ItemModel> results) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: AppDimensions.bodyPadding,
        height: double.infinity,
        color: Styles.poliferieWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTabBar(),
            _buildResultsBody(context, results),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is an hack not to re-fetch results once done once.
    if (!_initialized) {
      BlocProvider.of<SearchBloc>(context).add(FetchSearch(
          searchText: widget.search.query,
          filters: widget.search.filters,
          order: widget.search.order,
          limit: widget.search.limit));
      setState(() {
        _initialized = true;
      });
    }

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        if (state is SearchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return _buildBody(context, state.results);
        }
        return Text('This widge should never be reached');
      },
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
                .suggest(searchController.text);
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
                  ItemSearch(query: query, limit: Configs.firebaseItemsLimit),
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              searchRepository:
                  RepositoryProvider.of<SearchRepository>(context),
            ),
          )
        ],
        child: keyboardDismisser(
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
      ),
    );
  }
}
