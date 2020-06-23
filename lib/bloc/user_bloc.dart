import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Poliferie.io/bloc/user_event.dart';
import 'package:Poliferie.io/bloc/user_state.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/models/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({this.userRepository}) : assert(userRepository != null);

  @override
  Stream<UserState> transformEvents(
    Stream<UserEvent> events,
    Stream<UserState> Function(UserEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  // TODO(@amerlo): Hook for state transition
  @override
  void onTransition(Transition<UserEvent, UserState> transition) {
    print(transition);
  }

  @override
  UserState get initialState => FetchStateLoading();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is FetchUser) {
      final String _userName = event.userName;
      yield FetchStateLoading();
      try {
        final User user = await userRepository.getByUsername(_userName);
        yield FetchStateSuccess(user);
      } catch (error) {
        yield FetchStateError(error.message);
      }
    }
  }
}
