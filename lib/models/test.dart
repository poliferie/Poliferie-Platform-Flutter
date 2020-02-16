import 'package:equatable/equatable.dart';

class TestUser extends Equatable {
  final String login;
  final String avatarUrl;

  const TestUser({this.login, this.avatarUrl});

  @override
  List<Object> get props => [login, avatarUrl];

  // Constructor from Json file
  factory TestUser.fromJson(Map<String, dynamic> json) {
    return TestUser(login: json['login'], avatarUrl: json['avatar_url']);
  }
}
