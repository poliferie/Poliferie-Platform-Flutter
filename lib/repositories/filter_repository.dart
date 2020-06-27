import 'dart:async';
import 'package:meta/meta.dart';
import 'package:async/async.dart';

import 'package:Poliferie.io/providers/api_provider.dart';
import 'package:Poliferie.io/models/filter.dart';

class FilterRepository {
  final ApiProvider apiProvider;
  final AsyncCache<List<Filter>> cache;

  FilterRepository({@required this.apiProvider, cacheDuration}) 
    : cache = AsyncCache<List<Filter>>(Duration(hours: cacheDuration ?? 12)), 
      assert(apiProvider != null);

  Future<List<Filter>> _getAll() async {
    final allFilters = await apiProvider.fetch('filters');
    return [for (var filter in (allFilters as List)) Filter.fromJson(filter)];
  }

  Future<List<Filter>> getAll() async {
    return await cache.fetch(() => _getAll());
  }
}