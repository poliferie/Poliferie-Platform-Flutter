import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/item.dart';

class SearchSuggestion extends Equatable {
  final int id;
  final ItemType type;
  final String longName;
  final String provider;
  final String city;

  const SearchSuggestion(this.id,
      {this.type, this.longName, this.provider, this.city});

  @override
  List<Object> get props => [id, longName, type];

  bool isCourse() => type == ItemType.course;

  bool isUniversity() => type == ItemType.university;

  // Constructor from Json file
  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      json['id'],
      type: ItemModel.selectType(json['type'] as String),
      longName: json['longName'],
      city: json['city'],
      provider: json['provider'],
    );
  }
}
