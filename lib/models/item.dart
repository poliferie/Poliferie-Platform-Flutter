import 'package:equatable/equatable.dart';

/// Type of items
enum ItemType { course, university }

/// Class which holds one [ItemModel] statistic
class ItemStat {
  final String name;
  final String desc;
  final dynamic value;
  final String unit;

  const ItemStat(this.name, this.desc, this.value, this.unit);
}

/// Class which holds an [ItemModel]
class ItemModel extends Equatable {
  final String id;
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
  final String groupName;
  final String groupLabel;
  final int duration;
  final int students;
  final String language;
  final String requirements;
  final String owner;
  final String access;
  final String education;
  final String website;
  final Map<String, List<ItemStat>> stats;
  final List<String> search;

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
      this.groupName,
      this.groupLabel,
      this.duration,
      this.students,
      this.language,
      this.requirements,
      this.owner,
      this.access,
      this.education,
      this.website,
      this.stats,
      this.search});

  @override
  List<Object> get props => [id];

  static ItemType selectType(String type) {
    if (type == 'course') return ItemType.course;
    if (type == 'university') return ItemType.university;
    return ItemType.course;
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    // Support both list and map data structure
    List<dynamic> stats;
    if (json["stats"] is List) {
      stats = json["stats"];
    } else {
      stats = (json["stats"] as Map<String, dynamic>).values.toList();
    }

    Map<String, List<ItemStat>> map = Map<String, List<ItemStat>>();
    for (Map<String, dynamic> stat in stats) {
      if (map.containsKey(stat["tag"])) {
        map[stat["tag"]].add(
            ItemStat(stat["name"], stat["desc"], stat["value"], stat["unit"]));
      } else {
        map[stat["tag"]] = [
          ItemStat(stat["name"], stat["desc"], stat["value"], stat["unit"])
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
        groupName: json["groupName"],
        groupLabel: json["groupLabel"],
        duration: json["duration"],
        language: json["language"],
        requirements: json["requirements"],
        owner: json["owner"],
        access: json["access"],
        education: json["education"],
        students: json["students"],
        website: json.containsKey("website") ? json["website"] : null,
        stats: map,
        search: (json['search'] as List<dynamic>)
            .map((e) => e.toString())
            .toList());
  }
}
