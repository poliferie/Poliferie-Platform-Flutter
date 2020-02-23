import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'package:Poliferie.io/models/models.dart';

// TODO(@amerlo): Implement API call
class UserClient {
  final String baseUrl;
  final bool useLocalJson;
  UserClient(
      {this.baseUrl = "https://api.poliferie.org/user?q=",
      this.useLocalJson = false});

  Future<User> fetch(String userName) async {
    if (useLocalJson) {
      String _data = await rootBundle.loadString("assets/data/user.json");
      Map<String, dynamic> _result = json.decode(_data);
      return User.fromJson(_result);
    }
  }
}
