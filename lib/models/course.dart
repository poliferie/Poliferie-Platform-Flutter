import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int index;
  final String shortName;
  final String shortDescription;
  final String longDescription = '';
  final String university;
  final String universityLogoPath;
  final bool isBookmarked;
  final int students;
  final int salary;
  final double satisfaction;
  final Map<String, double> info;
  final Map<String, double> facilities;

  const CourseModel({
    this.index,
    this.shortName,
    this.university,
    this.shortDescription,
    this.universityLogoPath,
    this.isBookmarked,
    this.students,
    this.salary,
    this.satisfaction,
    this.info,
    this.facilities,
  });

  @override
  List<Object> get props => [index, shortName];

  // Constructor from Json file
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      index: json['index'],
      shortName: json['shortName'],
      shortDescription: json['shortDescription'],
    );
  }
}
