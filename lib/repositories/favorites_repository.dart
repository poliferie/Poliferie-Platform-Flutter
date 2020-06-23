import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/providers/local_provider.dart';

class FavoritesRepository {
  final LocalProvider localProvider;

  FavoritesRepository({@required this.localProvider}) 
    : assert(localProvider != null);

  Future<List<int>> get() async {
    final List<dynamic> returnedJson = await localProvider.get('favorites');
    List<int> favorites = returnedJson.cast<int>();
    return favorites;
  }

  Future<bool> contains(int id) async {
    return (await get()).contains(id);
  }

  Future<bool> add(int id) async {
    return await localProvider.addToList('favorites', id);
  }

  Future<bool> remove(int id) async {
    return await localProvider.removeFromList('favorites', id);
  }  
}