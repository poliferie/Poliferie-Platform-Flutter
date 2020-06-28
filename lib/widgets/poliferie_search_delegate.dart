import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/styles.dart';

import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/models/suggestion.dart';
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
    //                    provide it to the results screen
    return ResultsScreen(query);
  }

  // TODO(@amerlo): Make bold substring possible in all string
  _buildSuggestionEntry(
      BuildContext context, SearchSuggestion suggestion, String query) {
    Widget _title = Text(suggestion.shortName, style: Styles.suggestionTitle);
    if (suggestion.shortName.startsWith(query) && query != '') {
      _title = RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: query,
              style: Styles.suggestionTitleBold,
            ),
            TextSpan(
              text: suggestion.shortName.split(query)[1],
              style: Styles.suggestionTitle,
            ),
          ],
        ),
      );
    }
    return ListTile(
      leading: Icon(
        suggestion.isCourse() ? AppIcons.course : AppIcons.university,
        size: 28,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemScreen(suggestion.id),
          ),
        );
      },
      title: _title,
      subtitle: suggestion.isCourse()
          ? Text(suggestion.provider)
          : Text(suggestion.location),
    );
  }

  Widget _buildSuggestionsList(
      List<SearchSuggestion> suggestions, String query) {
    return Container(
      color: Styles.poliferieWhite,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) =>
            _buildSuggestionEntry(context, suggestions[index], query),
      ),
    );
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
          Widget suggestionListWidget =
              _buildSuggestionsList(state.suggestions, query);
          searchBloc.close();
          return suggestionListWidget;
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        return Text('This widget should never be reached');
      },
    );
  }
}
