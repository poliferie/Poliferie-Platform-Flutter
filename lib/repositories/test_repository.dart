import 'dart:async';
import 'package:meta/meta.dart';
import 'package:poliferie_platform_flutter/repositories/test_user_client.dart';
import 'package:poliferie_platform_flutter/repositories/test_user_cache.dart';
import 'package:poliferie_platform_flutter/models/models.dart';

// TODO(@amerlo): Add mock-up data here, via a swith in the getUsers() call

class TestUserRepository {
  final TestUserApiClient usersApiClient;
  final TestUserCache usersCache;

  TestUserRepository({@required this.usersApiClient, @required this.usersCache})
      : assert(usersApiClient != null);

  Future<List<SearchResultItem>> search(String term) async {
    if (usersCache.contains(term)) {
      return usersCache.get(term);
    } else {
      final _users = await usersApiClient.search(term);
      usersCache.set(term, _users);
      return _users;
    }
  }
}
