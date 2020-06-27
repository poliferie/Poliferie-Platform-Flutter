import 'package:Poliferie.io/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Poliferie.io/bloc/search_event.dart';
import 'package:Poliferie.io/bloc/search_state.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({this.searchRepository});// : assert(searchRepository != null);

  // @override
  // Stream<SearchState> transformEvents(
  //   Stream<SearchEvent> events,
  //   Stream<SearchState> Function(SearchEvent event) next,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(
  //       Duration(milliseconds: 500),
  //     ),
  //     next,
  //   );
  // }

  // TODO(@amerlo): Hook for state transition
  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    print(transition);
  }

  // TODO(@amerlo): Possibly add search cache and include here latest items
  @override
  SearchState get initialState => SearchStateLoading();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is FetchSuggestions) {
      final String searchText = event.searchText;
      yield SearchStateLoading();
      try {
        final List<SearchSuggestion> suggestions =
            await searchRepository.suggest(searchText);
        yield SuggestionStateSuccess(suggestions);
      } catch (error) {
        yield SearchStateError(error.message);
      }
    } else if (event is FetchSearch) {
      final String searchText = event.searchText;
      yield SearchStateLoading();
      try {
        final List<ItemModel> results =
            await searchRepository.search(searchText);
        yield SearchStateSuccess(results);
      } catch (error) {
        yield SearchStateError(error.message);
      }
    }
  }
}
