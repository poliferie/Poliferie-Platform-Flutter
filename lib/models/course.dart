import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int id;
  final String shortName;
  final String shortDescription;
  final String longDescription = '';
  final String university;
  final String region;
  final String universityLogoPath;
  final String universityImagePath;
  final bool isBookmarked;
  final int students;
  final int salary;
  final double satisfaction;
  final int duration;
  final String language;
  final String requirements;
  final String owner;
  final String access;
  final String education;
  final Map<String, double> facilities;

  const CourseModel({
    this.id,
    this.shortName,
    this.university,
    this.region,
    this.shortDescription,
    this.universityLogoPath,
    this.universityImagePath,
    this.isBookmarked,
    this.students,
    this.salary,
    this.satisfaction,
    this.duration,
    this.language,
    this.requirements,
    this.owner,
    this.access,
    this.education,
    this.facilities,
  });

  @override
  List<Object> get props => [id, shortName];

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['index'],
      shortName: json['shortName'],
      shortDescription: json['shortDescription'],
      university: json["university"],
      region: json["region"],
      universityImagePath: json["universityImagePath"],
      isBookmarked: json["isBookmarked"],
      education: json["education"],
      duration: json["duration"],
      language: json["language"],
      requirements: json["requirements"],
      access: json["access"],
      owner: json["owner"],
    );
  }
}
