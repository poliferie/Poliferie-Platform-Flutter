import 'package:Poliferie.io/bloc/search_bloc.dart';
import 'package:Poliferie.io/widgets/poliferie_item_card.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/utils.dart';

import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';

enum TabType { course, university }

// TODO(@amerlo): Where the repositories have to be declared?
final SearchRepository searchRepository =
    SearchRepository(searchClient: SearchClient(useLocalJson: true));

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

  ResultsScreenBody(this.query);

  @override
  _ResultsScreenBodyState createState() => _ResultsScreenBodyState();
}

class _ResultsScreenBodyState extends State<ResultsScreenBody> {
  List<dynamic> _favoriteItems = null;

  @override
  void initState() {
    super.initState();
    _setFavoriteItems();
  }

  void _setFavoriteItems() async {
    final List<dynamic> storedFavorites = await getPersistenceList('favorites');
    setState(() {
      _favoriteItems = storedFavorites;
    });
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 20.0,
      left: -10.0,
      child: MaterialButton(
          color: Styles.poliferieWhite,
          shape: CircleBorder(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Styles.poliferieLightGrey,
          ),
          onPressed: () {
            {
              Navigator.pop(context);
            }
          }),
    );
  }

  // TODO(@amerlo): This needs to be moved up in the stack
  // TODO(@amerlo): How to avoid having redundant list
  Widget _buildFavorite(int id) {
    bool _isFavorite = _favoriteItems.contains(id);
    return MaterialButton(
      color: Styles.poliferieWhite,
      shape: CircleBorder(),
      padding: EdgeInsets.all(6.0),
      child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Styles.poliferieRed, size: 40),
      onPressed: () {
        setState(() {
          if (!_isFavorite) {
            _favoriteItems.add(id);
            addToPersistenceList('favorites', id);
          } else {
            _favoriteItems.remove(id);
            removeFromPersistenceList('favorites', id);
          }
        });
      },
    );
  }

  Widget _buildResultsList(List<ItemModel> results) {
    List<Widget> items = List<Widget>();
    for (ItemModel item in results) {
      Widget card = Padding(
        child: PoliferieItemCard(item),
        padding: EdgeInsets.only(bottom: 10.0),
      );
      items.add(card);
    }

    // TODO(@amerlo): How to take all the available space here?
    return Container(
      height: 400,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          ...items,
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
      BuildContext context, List<ItemModel> results, TabType tabType) {
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
                  results.where((item) => item.type == 'course').toList(),
                  TabType.course),
              _buildTabBody(
                  context,
                  results.where((item) => item.type == 'university').toList(),
                  TabType.university),
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
        padding: AppDimensions.searchBodyPadding,
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
    BlocProvider.of<SearchBloc>(context)
        .add(FetchSearch(searchText: widget.query));

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
      body: BlocProvider<SearchBloc>(
        create: (context) => SearchBloc(searchRepository: searchRepository),
        child: ResultsScreenBody(widget.query),
      ),
    );
  }
}