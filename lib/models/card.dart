import 'package:equatable/equatable.dart';

class CardInfo extends Equatable {
  final int id;
  final String image;
  final String title;
  final String subtitle;
  final String text;

  const CardInfo(this.id, {this.image, this.title, this.subtitle, this.text});

  @override
  List<Object> get props => [id];

  // Constructor from Json file
  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      json['id'],
      image: json['image'],
      title: json['title'],
      subtitle: json['subtitle'],
      text: json['text'],
    );
  }
}
