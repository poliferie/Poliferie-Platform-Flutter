import 'dart:async';
import 'package:meta/meta.dart';
import 'package:async/async.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/models/item.dart';

class ItemRepository {
  final ApiProvider apiProvider;
  final AsyncCache<ItemModel> Function() cacheConstructor;
  final Map<int, AsyncCache<ItemModel>> cache;

  ItemRepository({@required this.apiProvider, cacheDuration}) 
    : cacheConstructor = (() => AsyncCache<ItemModel>(Duration(hours: cacheDuration ?? 12))),
      cache = {}, 
      assert(apiProvider != null);

  Future<ItemModel> _getById(int id) async {
    final returnedJson = await apiProvider.fetch('items/$id');
    return ItemModel.fromJson(returnedJson);
  }

  Future<ItemModel> getById(int id) async {
    cache.putIfAbsent(id, cacheConstructor);
    return await cache[id].fetch(() => _getById(id));
  }
}