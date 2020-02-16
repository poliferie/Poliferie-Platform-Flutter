import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:poliferie_platform_flutter/bloc/user_event.dart';
import 'package:poliferie_platform_flutter/bloc/user_state.dart';
import 'package:poliferie_platform_flutter/repositories/repositories.dart';
import 'package:poliferie_platform_flutter/models/user.dart';

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
  UserState get initialState => FetchStateEmpty();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is ViewScreen) {
      final String _userName = event.userName;
      yield FetchStateLoading();
      try {
        final User user = await userRepository.fetch(_userName);
        yield FetchStateSuccess(user);
      } catch (error) {
        print(error);
        yield FetchStateError(error.message);
      }
    }
  }
}
