import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

class LocalProvider {
  SharedPreferences sharedPreferences;

  LocalProvider(); 

  Future<dynamic> get(String key, {dynamic returnDefault}) async {
    sharedPreferences ??= await SharedPreferences.getInstance();

    final String encoded = sharedPreferences.getString(key);
    if (encoded != null) return json.decode(encoded);
    return returnDefault;
  }

  Future<bool> save(String key, dynamic encodable) async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    return await sharedPreferences.setString(key, json.encode(encodable));
  }  

  Future<bool> addToList(String key, dynamic element) async {
    List list = await get(key, returnDefault: []);
    if (!list.contains(element)) {
      list.add(element);
    }
    return save(key, list);
  }

  Future<bool> removeFromList(String key, dynamic element) async {
    List list = await get(key, returnDefault: []);
    list.remove(element);
    return save(key, list);
  }
}