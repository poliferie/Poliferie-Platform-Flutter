import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/utils.dart';

/// Type of items
enum ItemType { course, university }

/// Class which holds one [ItemModel] statistic
class ItemStat {
  final String name;
  final String desc;
  final dynamic value;
  final String type;

  const ItemStat(this.name, this.desc, this.value, this.type);
}

/// Class which holds an [ItemModel]
class ItemModel extends Equatable {
  final int id;
  final ItemType type;
  final String shortName;
  final String longName;
  final String provider;
  final String region;
  final String city;
  final String shortDescription;
  final String longDescription;
  final String providerLogo;
  final String providerImage;
  final bool isBookmarked;
  final int duration;
  final int students;
  final String language;
  final String requirements;
  final String owner;
  final String access;
  final String education;
  final Map<String, List<ItemStat>> stats;

  const ItemModel(
      {this.id,
      this.type,
      this.shortName,
      this.longName,
      this.provider,
      this.region,
      this.city,
      this.shortDescription,
      this.longDescription,
      this.providerLogo,
      this.providerImage,
      this.isBookmarked,
      this.duration,
      this.students,
      this.language,
      this.requirements,
      this.owner,
      this.access,
      this.education,
      this.stats});

  @override
  List<Object> get props => [id];

  factory ItemModel.fromJson(Map<String, dynamic> json) {
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

    return ItemModel(
        id: json['id'],
        type: selectType(json['type'] as String),
        shortName: json['shortName'],
        longName: json['longName'],
        provider: json['provider'],
        region: json['region'],
        city: json['city'],
        shortDescription: json['shortDescription'],
        longDescription: json['longDescription'],
        providerLogo: json['providerLogo'],
        providerImage: json['providerImage'],
        isBookmarked: json["isBookmarked"],
        duration: json["duration"],
        language: json["language"],
        requirements: json["requirements"],
        owner: json["owner"],
        access: json["access"],
        education: json["education"],
        students: json["students"],
        stats: map);
  }
}
