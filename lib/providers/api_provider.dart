import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiProvider {
  final bool mockup;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  ApiProvider({this.mockup = true});

  /// Fetches data from Cloud Firetore or from mockup data
  Future<dynamic> fetch(String endPoint,
      {Map<String, dynamic> payload,
      Map<String, dynamic> filters,
      Map<String, dynamic> order,
      int limit}) async {
    if (mockup) {
      final completeUrl = 'assets/data/mockup/' + endPoint + '.json';
      final data = await rootBundle.loadString(completeUrl);
      await Future.delayed(Duration(seconds: 1));
      return json.decode(data);
    }

    // This is a WIP, please work on me.
    if (payload == null) {
      // Check for documentPath
      // TODO(@amerlo): implement more robust checks
      if (endPoint.contains("/")) {
        DocumentReference ref = db.doc(endPoint);
        return ref.get().then((d) => d.data());
      }

      // Get collections
      Query query = db.collection(endPoint);

      // Build filters
      if (filters != null && filters != {}) {
        query = _setFilters(query, _sanitizeFilters(filters));
      }

      // Set order
      if (order != null && order != {})
        query = _setOrder(query, _sanitizeOrder(order));

      // Limit results
      if (_isLimitValid(limit)) query = query.limit(limit);

      return query.get().then((c) => c.docs.map((d) => d.data()).toList());
    }

    // Set payload data
    // TODO(@amerlo): This has to be implemented
    return false;
  }
}

bool _isLimitValid(int limit) {
  return limit != null && limit > 0;
}

Query _setFilter(Query query, String field, Map<String, dynamic> filter) {
  // Get filter parameters
  String operation = filter["op"];
  var values = filter["values"];

  // Apply filter
  if (operation == "==") query = query.where(field, isEqualTo: values);
  if (operation == "in") query = query.where(field, whereIn: values);
  if (operation == ">") query = query.where(field, isGreaterThan: values);
  if (operation == "<") query = query.where(field, isLessThan: values);
  if (operation == "<>")
    query = query
        .where(field, isGreaterThan: values[0])
        .where(field, isLessThan: values[1]);
  if (operation == ">=")
    query = query.where(field, isGreaterThanOrEqualTo: values);
  if (operation == "<=")
    query = query.where(field, isLessThanOrEqualTo: values);
  if (operation == "<=>=")
    query = query
        .where(field, isGreaterThanOrEqualTo: values[0])
        .where(field, isLessThanOrEqualTo: values[1]);
  if (operation == "null") query = query.where(field, isNull: values);
  if (operation == "array-contains")
    query = query.where(field, arrayContains: values);
  if (operation == "array-contains-any")
    query = query.where(field, arrayContainsAny: values);

  return query;
}

Query _setFilters(Query query, List<MapEntry<String, dynamic>> filters) {
  for (MapEntry<String, dynamic> filter in filters) {
    query = _setFilter(query, filter.key, filter.value);
  }
  return query;
}

Query _setOrder(Query query, Map<String, dynamic> order) {
  // Set order by fields
  order.forEach((field, o) {
    query = query.orderBy(field, descending: o["descending"]);
  });

  // Set optional ranges
  List<dynamic> startAt = order.values
      .toList()
      .map((o) => o.containsKey("startAt") ? o["startAt"] : null)
      .toList();
  List<dynamic> endAt = order.values
      .toList()
      .map((o) => o.containsKey("endAt") ? o["endAt"] : null)
      .toList();

  if (!startAt.toSet().contains(null)) query = query.startAt(startAt);
  if (!endAt.toSet().contains(null)) query = query.endAt(endAt);

  return query;
}

/// Get a map of filters and returns a sanitized list of them.
List<MapEntry<String, dynamic>> _sanitizeFilters(Map<String, dynamic> filters) {
  // Map "in" filter in multiple "==" ones
  List<MapEntry<String, dynamic>> _inFilters = filters.entries
      .where((e) => (e.value["op"] == "in" && e.key != "search"))
      .toList();
  // Remove in filters
  for (String key in _inFilters.map((e) => e.key).toList()) {
    filters.remove(key);
  }

  List<MapEntry<String, dynamic>> _filters = filters.entries.toList();

  // Add the "==" filters
  for (MapEntry<String, dynamic> filter in _inFilters) {
    for (String value in filter.value["values"]) {
      _filters.add(MapEntry(filter.key, {"op": "==", "values": value}));
    }
  }

  return _filters;
}

Map<String, dynamic> _sanitizeOrder(Map<String, dynamic> order) {
  //TODO(@amerlo): To be implemented
  return order;
}
