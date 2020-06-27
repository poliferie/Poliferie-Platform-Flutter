import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Poliferie.io/bloc/filter_event.dart';
import 'package:Poliferie.io/bloc/filter_state.dart';
import 'package:Poliferie.io/repositories/filter_repository.dart';
import 'package:Poliferie.io/models/filter.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final FilterRepository filterRepository;

  FilterBloc({this.filterRepository}) : assert(filterRepository != null);

  // @override
  // Stream<FilterState> transformEvents(
  //   Stream<FilterEvent> events,
  //   Stream<FilterState> Function(FilterEvent event) next,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(
  //       Duration(milliseconds: 500),
  //     ),
  //     next,
  //   );
  // }

  // TODO(@amerlo): Include more details for the transition here
  @override
  void onTransition(Transition<FilterEvent, FilterState> transition) {
    print(transition);
  }

  @override
  FilterState get initialState => FetchStateLoading();

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is FetchFilters) {
      yield FetchStateLoading();
      try {
        final List<Filter> filters = await filterRepository.getAll();
        yield FetchStateSuccess(filters);
      } catch (error) {
        yield FetchStateError(error.message);
      }
    }
  }
}
