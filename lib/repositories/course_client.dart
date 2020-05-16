import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'package:Poliferie.io/models/course.dart';

// TODO(@amerlo): Implement API call
class CourseClient {
  final String baseUrl;
  final bool useLocalJson;
  CourseClient(
      {this.baseUrl = "https://api.poliferie.org/course?q=",
      this.useLocalJson = false});

  Future<CourseModel> fetch(int courseId) async {
    if (useLocalJson) {
      String _data =
          await rootBundle.loadString("assets/data/mockup/courses.json");
      final _courses = json.decode(_data).toList();
      for (var course in _courses) {
        if (course["id"] == courseId) {
          return CourseModel.fromJson(course);
        }
      }
      // TODO(@amerlo): Add log warning
      return CourseModel();
    } else {
      return CourseModel();
    }
  }
}
