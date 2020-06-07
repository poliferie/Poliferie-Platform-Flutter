import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/item.dart';
import 'package:Poliferie.io/utils.dart';

class SearchSuggestion extends Equatable {
  final int id;
  final ItemType type;
  final String shortName;
  final String shortDescription;
  final Map<String, List<ItemStat>> stats;

  const SearchSuggestion(this.id,
      {this.type, this.shortName, this.shortDescription, this.stats});

  @override
  List<Object> get props => [id, shortName, type];

  bool isCourse() => type == ItemType.course;

  bool isUniversity() => type == ItemType.university;

  // Constructor from Json file
  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    final List<dynamic> stats = json["stats"];

    Map<String, List<ItemStat>> map = Map<String, List<ItemStat>>();
    for (Map<String, dynamic> stat in stats) {
      if (map.containsKey(stat["tag"])) {
        map[stat["tag"]].add(
            ItemStat(stat["name"], stat["desc"], stat["value"], stat["type"]));
      } else {
        map[stat["tag"]] = [
          ItemStat(stat["name"], stat["desc"], stat["value"], stat["type"])
        ];
      }
    }

    return SearchSuggestion(
      json['id'],
      type: selectType(json['type'] as String),
      shortName: json['shortName'],
      shortDescription: json['shortDescription'],
      stats: map,
    );
  }
}
