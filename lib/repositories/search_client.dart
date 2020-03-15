import 'dart:convert';
import 'dart:async';
import 'package:Poliferie.io/models/course.dart';
import 'package:Poliferie.io/models/university.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:Poliferie.io/models/suggestion.dart';

// TODO(@amerlo): Implement API call
class SearchClient {
  final String baseUrl;
  final bool useLocalJson;
  SearchClient(
      {this.baseUrl = "https://api.poliferie.org/user?q=",
      this.useLocalJson = false});

  // TODO(@amerlo): Implement list builder
  Future<List<SearchSuggestion>> fetchSuggestions(String searchText) async {
    if (useLocalJson) {
      String _data =
          await rootBundle.loadString("assets/data/mockup/suggestions.json");
      final _suggestionList = json.decode(_data).toList();
      return <SearchSuggestion>[
        SearchSuggestion.fromJson(_suggestionList[0]),
        SearchSuggestion.fromJson(_suggestionList[1]),
      ];
    } else {
      return <SearchSuggestion>[];
    }
  }

  // TODO(@amerlo): Implement list builder
  Future<List> fetchSearch(String searchText) async {
    if (useLocalJson) {
      String _coursesData =
          await rootBundle.loadString("assets/data/mockup/courses.json");
      String _universitiesData =
          await rootBundle.loadString("assets/data/mockup/universities.json");
      final _coursesList = json.decode(_coursesData).toList();
      final _universitiesList = json.decode(_universitiesData).toList();
      return <Object>[
        <CourseModel>[CourseModel.fromJson(_coursesList[0])],
        <UniversityModel>[UniversityModel.fromJson(_universitiesList[1])],
      ];
    } else {
      return <SearchSuggestion>[];
    }
  }
}
