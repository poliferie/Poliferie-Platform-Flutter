import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
// TODO(@amerlo): http package has to be checked, revert to mockup now
//import 'package:http/http.dart' as http;

import 'package:poliferie_platform_flutter/models/models.dart';

// Mockup flag
final bool _mockup = true;

class UserClient {
  final String baseUrl;
  //final http.Client httpClient;

  // TODO(@amerlo): Update true API base url
  UserClient(
      { //this.httpClient,
      this.baseUrl = "https://api.github.com/search/repositories?q="});
  //: assert(httpClient != null);

  Future<User> fetch(String userName) async {
    //final _response = await httpClient.get(Uri.parse("$baseUrl$userName"));
    final String _path = await rootBundle.loadString('assets/data/user.json');
    var _result = json.decode(_path);
    if (!_mockup) {
      //  _result = json.decode(_response.body);
    }
    final _user = User.fromJson(_result);

    // TODO(@amerlo): Implement error message
    return _user;
/*     if (_response.statusCode == 200) {
      return _user;
    } else {
      throw _result['message'] as String;
    }
 */
  }
}
