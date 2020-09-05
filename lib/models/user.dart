import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String image;
  final String city;
  final String school;
  final int followers;

  const User({
    this.name,
    this.image,
    this.city,
    this.school,
    this.followers,
  });

  @override
  List<Object> get props => [name, image, city, followers];

  // Constructor from Json file
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      image: json['image'],
      city: json['city'],
      school: json['school'],
      followers: json['followers'],
    );
  }
}
