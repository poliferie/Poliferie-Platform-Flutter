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

  const Filter({
    this.icon,
    this.name,
    this.hint,
    this.description,
    this.type,
    this.range,
    this.applyTo,
    this.unit = "",
  });

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
