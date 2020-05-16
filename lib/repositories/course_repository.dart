import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/models/course.dart';
import 'package:Poliferie.io/repositories/course_client.dart';

class CourseRepository {
  final CourseClient courseClient;

  CourseRepository({@required this.courseClient})
      : assert(courseClient != null);

  Future<CourseModel> fetch(int id) async {
    return await courseClient.fetch(id);
  }
}
