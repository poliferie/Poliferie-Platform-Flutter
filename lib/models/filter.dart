import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:Poliferie.io/models/item.dart';

enum FilterType { dropDown, selectRange, selectValue }

class Filter extends Equatable {
  final IconData icon;
  final String name;
  final String description;
  final String hint;
  final FilterType type;
  final String unit;

  /// Set of [ItemType] to which it applies
  final List<ItemType> applyTo;

  /// Set of possible values, it depends on [FilterType]
  final List range;

  Filter(
      {this.icon,
      this.name,
      this.hint,
      this.description,
      this.type,
      this.range,
      this.applyTo,
      this.unit = ""});

  @override
  List<Object> get props => [name];

  static FilterType getFilterType(String type) {
    if (type == 'dropDown') {
      return FilterType.dropDown;
    }
    if (type == 'selectRange') {
      return FilterType.selectRange;
    }
    if (type == 'selectValue') {
      return FilterType.selectValue;
    }
    return FilterType.selectRange;
  }

  static IconData getIconFromString(String icon) {
    if (icon == 'location_city') {
      return Icons.location_city;
    }
    if (icon == 'supervisor_account') {
      return Icons.supervisor_account;
    }
    if (icon == 'attach_money') {
      return Icons.attach_money;
    }
    if (icon == 'plus_one') {
      return Icons.plus_one;
    }
    if (icon == 'bookmark') {
      return Icons.bookmark;
    }
    if (icon == 'work') {
      return Icons.work;
    }
    if (icon == 'language') {
      return Icons.language;
    }
  }

  // Constructor from Json file
  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
        icon: getIconFromString(json['icon']),
        name: json['name'],
        hint: json['hint'],
        description: json['description'],
        type: Filter.getFilterType(json['type']),
        range: json['range'],
        applyTo: (json['applyTo'] as List<dynamic>)
            .cast<String>()
            .map((e) => ItemModel.selectType(e))
            .toList(),
        unit: json['unit']);
  }
}

class FilterStatus {
  bool selected;
  List<dynamic> values;

  FilterStatus(this.values, {this.selected = false});

  static FilterStatus initStatus(FilterType type, List<dynamic> range) {
    if (type == FilterType.dropDown) {
      return FilterStatus([]);
    }
    if (type == FilterType.selectValue) {
      return FilterStatus([]);
    }
    if (type == FilterType.selectRange) {
      final List<int> rangeCasted = range.cast<int>();
      double min = rangeCasted[0].toDouble();
      double max = rangeCasted[1].toDouble();
      double spread = max - min;
      return FilterStatus([min + 0.1 * spread, max - spread * 0.1]);
    }
  }
}

/// Build Firebase filter Map
/// TODO(@amerlo): Evaluate to put Filter and FilterStatus class together
Map<String, dynamic> getFirebaseFilter(Filter filter, FilterStatus status) {
  if (filter.type == FilterType.selectRange) {
    return {
      filter.name: {
        "op": "<=>=",
        "values": status.values,
      }
    };
  }
  if (filter.type == FilterType.dropDown) {
    return {
      filter.name: {
        "op": "in",
        "values": status.values,
      }
    };
  }
}
