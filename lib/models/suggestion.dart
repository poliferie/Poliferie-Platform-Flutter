import 'package:equatable/equatable.dart';

class SearchSuggestion extends Equatable {
  final String type;
  final String shortName;
  final String id;

  const SearchSuggestion({this.id, this.shortName, this.type});

  @override
  List<Object> get props => [id, shortName, type];

  bool isCourse() => type == "course";

  bool isUniversity() => type == "university";

  // Constructor from Json file
  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      id: json['id'],
      type: json['type'],
      shortName: json['shortName'],
    );
  }
}
