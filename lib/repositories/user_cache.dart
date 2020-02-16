import 'package:poliferie_platform_flutter/models/models.dart';

class UserCache {
  User _user = User();

  // Methods
  User get() => _user;

  void set(User user) => _user = user;

  bool isEmpty() => _user == User();

  void flush() => _user = User();
}
