import 'package:equatable/equatable.dart';

class CardInfo extends Equatable {
  final String id;
  final String image;
  final String title;
  final String subtitle;
  final String linksTo;

  const CardInfo(this.id,
      {this.image, this.title, this.subtitle, this.linksTo});

  @override
  List<Object> get props => [id];

  // Constructor from Json file
  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      json['id'],
      image: json['image'],
      title: json['title'],
      subtitle: json['subtitle'],
      linksTo: json['linksTo'],
    );
  }
}
