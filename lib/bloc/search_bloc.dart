import 'package:Poliferie.io/models/models.dart';
import 'package:bloc/bloc.dart';

import 'package:Poliferie.io/bloc/search_event.dart';
import 'package:Poliferie.io/bloc/search_state.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/models/item.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({this.searchRepository}) : assert(searchRepository != null);

  // TODO(@amerlo): Format all transition.
  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    print(transition);
  }

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
        yield SearchStateError('$error');
      }
    } else if (event is FetchSearch) {
      final String searchText = event.searchText;
      final Map<String, dynamic> filters = event.filters;
      final Map<String, dynamic> order = event.order;
      final int limit = event.limit;
      yield SearchStateLoading();

      try {
        final List<ItemModel> results = await searchRepository
            .search(searchText, filters: filters, order: order, limit: limit);
        yield SearchStateSuccess(results);
      } catch (error) {
        yield SearchStateError('$error');
      }
    }
  }
}
