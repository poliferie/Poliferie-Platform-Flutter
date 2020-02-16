import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:poliferie_platform_flutter/bloc/test.dart';
import 'package:poliferie_platform_flutter/repositories/test_repository.dart';
import 'package:poliferie_platform_flutter/repositories/test_user_client.dart';

class TestUserBloc extends Bloc<TestUserEvent, TestUserState> {
  final TestUserRepository usersRepository;

  TestUserBloc({@required this.usersRepository})
      : assert(usersRepository != null);

  @override
  Stream<TestUserState> transformEvents(
    Stream<TestUserEvent> events,
    Stream<TestUserState> Function(TestUserEvent event) next,
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
  void onTransition(Transition<TestUserEvent, TestUserState> transition) {
    print(transition);
  }

  @override
  TestUserState get initialState => SearchStateEmpty();

  @override
  Stream<TestUserState> mapEventToState(TestUserEvent event) async* {
    if (event is TextChanged) {
      final String _term = event.text;
      if (_term.isEmpty) {
        // TODO(@amerlo): Add empty search state
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          final List<SearchResultItem> users =
              await usersRepository.search(_term);
          yield SearchStateSuccess(users);
        } catch (error) {
          print(error);
          yield SearchStateError(error.message);
        }
      }
    }
  }
}
