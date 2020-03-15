import 'package:equatable/equatable.dart';

class SearchSuggestion extends Equatable {
  final String type;
  final String shortName;

  const SearchSuggestion({this.type, this.shortName});

  @override
  List<Object> get props => [type, shortName];

  bool isCourse() => type == "course";

  bool isUniversity() => type == "university";

  // Constructor from Json file
  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      type: json['type'],
      shortName: json['shortName'],
    );
  }
}
