import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/providers/local_provider.dart';

class FavoritesRepository {
  final LocalProvider localProvider;

  FavoritesRepository({@required this.localProvider})
      : assert(localProvider != null);

  Future<List<String>> get() async {
    final List<dynamic> returnedJson =
        await localProvider.get('favorites', returnDefault: []);
    List<String> favorites = returnedJson.cast<String>();
    return favorites;
  }

  Future<bool> contains(String id) async {
    return (await get()).contains(id);
  }

  Future<bool> add(String id) async {
    return await localProvider.addToList('favorites', id);
  }

  Future<bool> remove(String id) async {
    return await localProvider.removeFromList('favorites', id);
  }

  Future<bool> toggle(String id) async {
    return (await contains(id)) ? remove(id) : add(id);
  }
}
