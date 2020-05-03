import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int id;
  final String shortName;
  final String shortDescription;
  final String longDescription = '';
  final String university;
  final String universityLogoPath;
  final String universityImagePath;
  final bool isBookmarked;
  final int students;
  final int salary;
  final double satisfaction;
  final Map<String, double> info;
  final Map<String, double> facilities;

  const CourseModel({
    this.id,
    this.shortName,
    this.university,
    this.shortDescription,
    this.universityLogoPath,
    this.universityImagePath,
    this.isBookmarked,
    this.students,
    this.salary,
    this.satisfaction,
    this.info,
    this.facilities,
  });

  @override
  List<Object> get props => [id, shortName];

  // Constructor from Json file
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
        id: json['index'],
        shortName: json['shortName'],
        shortDescription: json['shortDescription'],
        university: json["university"],
        universityImagePath: json["universityImagePath"],
        isBookmarked: json["isBookmarked"]);
  }
}
