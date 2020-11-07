import 'dart:async';
import 'package:meta/meta.dart';
import 'package:async/async.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/models/article.dart';
import 'package:Poliferie.io/configs.dart';

class ArticleRepository {
  final ApiProvider apiProvider;
  final AsyncCache<Article> Function() cacheConstructor;
  final Map<String, AsyncCache<Article>> cache;

  ArticleRepository({@required this.apiProvider, cacheDuration})
      : cacheConstructor =
            (() => AsyncCache<Article>(Duration(hours: cacheDuration ?? 12))),
        cache = {},
        assert(apiProvider != null);

  Future<Article> _getById(String id) async {
    final returnedJson =
        await apiProvider.fetch(Configs.firebaseArticlesCollection + '/$id');
    if (returnedJson == null) {
      throw ("This article does not exist");
    }
    return Article.fromJson(returnedJson);
  }

  Future<Article> getById(String id) async {
    cache.putIfAbsent(id, cacheConstructor);
    return await cache[id].fetch(() => _getById(id));
  }
}
