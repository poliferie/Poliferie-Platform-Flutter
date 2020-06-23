import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:Poliferie.io/models/item.dart';

enum FilterType { dropDown, selectRange }

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
    return FilterType.selectRange;
  }

  // Constructor from Json file
  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
        icon: IconData(int.parse(json['icon']), fontFamily: 'MaterialIcons'),
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
    if (type == FilterType.selectRange) {
      final List<int> rangeCasted = range.cast<int>();
      double min = rangeCasted[0].toDouble();
      double max = rangeCasted[1].toDouble();
      double spread = max - min;
      return FilterStatus([min + 0.1 * spread, max - spread * 0.1]);
    }
  }
}
