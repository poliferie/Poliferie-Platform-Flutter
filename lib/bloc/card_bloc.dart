import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Poliferie.io/bloc/card_event.dart';
import 'package:Poliferie.io/bloc/card_state.dart';
import 'package:Poliferie.io/repositories/card_repository.dart';
import 'package:Poliferie.io/models/card.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;

  CardBloc({this.cardRepository}) : assert(cardRepository != null);

  @override
  Stream<CardState> transformEvents(
    Stream<CardEvent> events,
    Stream<CardState> Function(CardEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  // TODO(@amerlo): Include more details for the transition here
  @override
  void onTransition(Transition<CardEvent, CardState> transition) {
    print(transition);
  }

  @override
  CardState get initialState => FetchStateLoading();

  @override
  Stream<CardState> mapEventToState(CardEvent event) async* {
    if (event is FetchCards) {
      yield FetchStateLoading();
      try {
        final List<CardInfo> cards = await cardRepository.getAll();
        yield FetchStateSuccess(cards);
      } catch (error) {
        yield FetchStateError(error.message);
      }
    }
  }
}
