import 'dart:convert';
import 'dart:async';
//import 'package:http/http.dart' as http;
import 'package:poliferie_platform_flutter/models/models.dart';

// Helper class
class SearchResultItem {
  final String fullName;
  final String htmlUrl;
  final TestUser owner;

  const SearchResultItem({this.fullName, this.htmlUrl, this.owner});

  static SearchResultItem fromJson(dynamic json) {
    return SearchResultItem(
      fullName: json['full_name'] as String,
      htmlUrl: json['html_url'] as String,
      owner: TestUser.fromJson(json['owner']),
    );
  }
}

/// TODO(@amerlo): This is just for testing, remove it later
class TestUserApiClient {
  final String baseUrl;
  //final http.Client httpClient;

  TestUserApiClient(
      { //this.httpClient,
      this.baseUrl = "https://api.github.com/search/repositories?q="});
  //: assert(httpClient != null);

  Future<List<SearchResultItem>> search(String term) async {
    /* final _response = await httpClient.get(Uri.parse("$baseUrl$term"));
    final _results = json.decode(_response.body);

    final _searchItems = (_results['items'] as List<dynamic>)
        .map((dynamic item) =>
            SearchResultItem.fromJson(item as Map<String, dynamic>))
        .toList();
 */
    final List<SearchResultItem> _searchItems = [];
    return _searchItems;
    // TODO(@amerlo): Implement error message
    /* if (_response.statusCode == 200) {
      return _searchItems;
    } else {
      throw _results['message'] as String;
    } */
  }
}
