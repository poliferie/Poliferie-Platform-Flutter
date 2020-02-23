import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/models/user.dart';
import 'package:Poliferie.io/repositories/user_client.dart';
import 'package:Poliferie.io/repositories/user_cache.dart';

class UserRepository {
  final UserClient userClient;
  final UserCache userCache;

  UserRepository({@required this.userClient, @required this.userCache})
      : assert(userClient != null),
        assert(userCache != null);

  // TODO(@amerlo): cache management:
  // * use tag for cache version control
  // * when something update the state, call flush function here
  Future<User> fetch(String userName) async {
    if (!userCache.isEmpty()) {
      return userCache.get();
    } else {
      final _user = await userClient.fetch(userName);
      userCache.set(_user);
      return _user;
    }
  }
}
