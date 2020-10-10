import 'dart:async';
import 'package:Poliferie.io/configs.dart';
import 'package:meta/meta.dart';
import 'package:async/async.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/models/item.dart';

class ItemRepository {
  final ApiProvider apiProvider;
  final AsyncCache<ItemModel> Function() cacheConstructor;
  final Map<String, AsyncCache<ItemModel>> cache;

  ItemRepository({@required this.apiProvider, cacheDuration})
      : cacheConstructor =
            (() => AsyncCache<ItemModel>(Duration(hours: cacheDuration ?? 12))),
        cache = {},
        assert(apiProvider != null);

  Future<ItemModel> _getById(String id) async {
    final returnedJson =
        await apiProvider.fetch(Configs.firebaseItemsCollection + '/$id');
    return ItemModel.fromJson(returnedJson);
  }

  Future<ItemModel> getById(String id) async {
    cache.putIfAbsent(id, cacheConstructor);
    return await cache[id].fetch(() => _getById(id));
  }
}
