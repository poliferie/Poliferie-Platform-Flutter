import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Poliferie.io/bloc/item_event.dart';
import 'package:Poliferie.io/bloc/item_state.dart';
import 'package:Poliferie.io/repositories/item_repository.dart';
import 'package:Poliferie.io/models/item.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository itemRepository;

  ItemBloc({this.itemRepository}) : assert(itemRepository != null);

  @override
  Stream<ItemState> transformEvents(
    Stream<ItemEvent> events,
    Stream<ItemState> Function(ItemEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  // TODO(@amerlo): Include more details for the transition here,
  //                log them somewhere.
  @override
  void onTransition(Transition<ItemEvent, ItemState> transition) {
    print(transition);
  }

  @override
  ItemState get initialState => FetchStateLoading();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is FetchItem) {
      yield FetchStateLoading();
      try {
        final ItemModel item = await itemRepository.fetch(event.itemId);
        yield FetchStateSuccess(item);
      } catch (error) {
        yield FetchStateError(error.message);
      }
    }
  }
}
