import 'dart:async';
import 'package:meta/meta.dart';
import 'package:async/async.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/models/card.dart';

class CardRepository {
  final ApiProvider apiProvider;
  final AsyncCache<List<CardInfo>> cache;

  CardRepository({@required this.apiProvider, cacheDuration})
      : cache =
            AsyncCache<List<CardInfo>>(Duration(hours: cacheDuration ?? 12)),
        assert(apiProvider != null);

  Future<List<CardInfo>> _getAll() async {
    final allCards = await apiProvider.fetch('cards');
    return [for (var card in (allCards as List)) CardInfo.fromJson(card)];
  }

  Future<List<CardInfo>> getAll() async {
    return await cache.fetch(() => _getAll());
  }
}
