import 'package:equatable/equatable.dart';

class UniversityModel extends Equatable {
  final int index;
  final String shortName;
  final String shortDescription;
  final String imagePath;

  const UniversityModel({
    this.index,
    this.shortName,
    this.shortDescription,
    this.imagePath,
  });

  @override
  List<Object> get props => [shortName, index, shortDescription, imagePath];

  // Constructor from Json file
  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      index: json['index'],
      shortName: json['shortName'],
      shortDescription: json['shortDescription'],
      imagePath: json['imagePath'],
    );
  }
}
