import 'package:bloc/bloc.dart';

import 'package:Poliferie.io/bloc/item_event.dart';
import 'package:Poliferie.io/bloc/item_state.dart';
import 'package:Poliferie.io/repositories/item_repository.dart';
import 'package:Poliferie.io/models/item.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository itemRepository;

  ItemBloc({this.itemRepository}) : assert(itemRepository != null);

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
    if (event is FetchItems) {
      yield FetchStateLoading();
      try {
        List<ItemModel> items = <ItemModel>[];
        for (String id in event.itemIds) {
          items.add(await itemRepository.getById(id));
        }
        yield FetchStateSuccess(items);
      } catch (error) {
        yield FetchStateError('$error');
      }
    }
  }
}
