import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ApiProvider {
  final String baseUrl;
  final bool mockup;
  
  ApiProvider({this.baseUrl = 'https://api.poliferie.org/', this.mockup = true});

  static Map<String,String> postHeaders = {
    'Content-type' : 'application/json', 
    'Accept': 'application/json',
  };

  /// Fetches json data ƒrom the API, using a POST request if there is a payload, a GET request otherwise
  Future<dynamic> fetch(String url, {Map<String, dynamic> payload}) async {
    if (mockup) {
      final completeUrl = 'assets/data/mockup/' + url + '.json'; // url.replaceAll('/', '_') + '.json';
      final data = await rootBundle.loadString(completeUrl);
      return json.decode(data);
    } else {
      final completeUrl = baseUrl + url;
      http.Response response;
      if (payload == null) {
        response = await http.get(completeUrl);
      } else {
        response = await http.post(completeUrl, body: json.encode(payload), headers: postHeaders);
      }
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('API Error "$completeUrl"');
      }
    }
  }
}