import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/bloc/search_bloc.dart';
import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/repositories/repositories.dart';

import 'package:Poliferie.io/widgets/poliferie_item_card.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';

class ResultsScreen extends StatefulWidget {
  // TODO(@amerlo): We should create a search state object and pass it here
  /// This represents the search state request
  final String query;

  const ResultsScreen(this.query, {Key key}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class ResultsScreenBody extends StatefulWidget {
  // TODO(@amerlo): Could we avoid this?
  final String query;

  final FavoritesRepository favoritesRepository;

  ResultsScreenBody({this.query, @required this.favoritesRepository});

  @override
  _ResultsScreenBodyState createState() => _ResultsScreenBodyState();
}

class _ResultsScreenBodyState extends State<ResultsScreenBody> {
  /// List of favorite items
  List<int> _favoriteItems;

  /// Hack to flag first loading
  bool _initialized;

  @override
  void initState() {
    super.initState();
    _updateFavorites();
    _initialized = false;
  }

  void _updateFavorites({int toggleIndex}) async {
    if (toggleIndex != null)
      await widget.favoritesRepository.toggle(toggleIndex);
    final List<int> favorites = await widget.favoritesRepository.get();
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
            IconButton(icon: Icon(Icons.filter_list), onPressed: null),
            IconButton(icon: Icon(Icons.format_list_bulleted), onPressed: null)
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
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildTabBody(
                  context,
                  results
                      .where((item) => item.type == ItemType.course)
                      .toList(),
                  ItemType.course),
              _buildTabBody(
                  context,
                  results
                      .where((item) => item.type == ItemType.university)
                      .toList(),
                  ItemType.university),
            ],
          )
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Styles.poliferieWhite),
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
    // This is an hack not to re-fetch results once done once
    if (!_initialized) {
      BlocProvider.of<SearchBloc>(context)
          .add(FetchSearch(searchText: widget.query));
      setState(() {
        _initialized = true;
      });
    }

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        if (state is SearchStateLoading) {
          return CircularProgressIndicator();
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
        child: ResultsScreenBody(
            query: widget.query,
            favoritesRepository:
                RepositoryProvider.of<FavoritesRepository>(context)),
      ),
    );
  }
}
