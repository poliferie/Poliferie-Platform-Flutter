import 'package:poliferie_platform_flutter/repositories/test_user_client.dart';

class TestUserCache {
  var _users = <String, List<SearchResultItem>>{};

  // Methods
  List<SearchResultItem> get(String term) => _users[term];

  void set(String term, List<SearchResultItem> data) => _users[term] = data;

  bool contains(String term) => _users.containsKey(term);

  void remove(String term) => _users.remove(term);

  void flush() => _users.clear();
}
