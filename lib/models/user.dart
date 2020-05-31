import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String city;
  final String school;
  final int followers;
  final List<String> badges;

  const User({this.name, this.city, this.school, this.followers, this.badges});

  @override
  List<Object> get props => [name, city, followers, badges];

  // Constructor from Json file
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      city: json['city'],
      school: json['school'],
      followers: json['followers'],
      badges: List<String>.from(json['badges']),
    );
  }
}
