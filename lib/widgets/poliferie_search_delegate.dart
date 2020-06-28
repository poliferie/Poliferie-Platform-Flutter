import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/styles.dart';

import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/screens/item.dart';
import 'package:Poliferie.io/screens/results.dart';

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
