import 'dart:async';
import 'package:meta/meta.dart';
import 'package:async/async.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/models/user.dart';

class UserRepository {
  final ApiProvider apiProvider;
  final AsyncCache<User> Function() cacheConstructor;
  final Map<String, AsyncCache<User>> cache;

  UserRepository({@required this.apiProvider, cacheDuration})
      : cacheConstructor =
            (() => AsyncCache<User>(Duration(hours: cacheDuration ?? 12))),
        cache = {},
        assert(apiProvider != null);

  Future<User> _getByUsername(String username) async {
    final returnedJson = await apiProvider.fetch('users/$username');
    if (returnedJson == null) {
      throw ("The profile does not exist");
    }
    return User.fromJson(returnedJson);
  }

  Future<User> getByUsername(String username) async {
    cache.putIfAbsent(username, cacheConstructor);
    return await cache[username].fetch(() => _getByUsername(username));
  }
}
