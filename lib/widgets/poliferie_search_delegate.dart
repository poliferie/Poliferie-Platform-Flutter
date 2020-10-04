import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/styles.dart';

import 'package:Poliferie.io/bloc/search.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item_search.dart';
import 'package:Poliferie.io/screens/item.dart';

import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';

/// [SearchDelegate] helper class.
class PoliferieSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;
  final Widget Function(ItemSearch) onSearch;
  final dynamic Function(SearchSuggestion) onSuggestionTap;

  dynamic _onSuggestionTapDefault(
      BuildContext context, SearchSuggestion suggestion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemScreen(suggestion.id),
      ),
    );
  }

  PoliferieSearchDelegate(
      {this.searchBloc, this.onSearch, this.onSuggestionTap});

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
    // TODO(@amerlo): This is a very dirty hack to not update the view in case of
    //                null onSearch() function.
    if (onSearch != null) {
      return onSearch(ItemSearch(query: query));
    } else {
      return buildSuggestions(context);
    }
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
        if (onSuggestionTap != null) {
          onSuggestionTap(suggestion);
          // TODO(@amerlo): This close() call should be located in onSuggestionTap
          close(context, null);
        } else {
          _onSuggestionTapDefault(context, suggestion);
        }
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
          return PoliferieProgressIndicator();
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
