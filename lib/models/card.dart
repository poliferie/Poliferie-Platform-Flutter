import 'package:equatable/equatable.dart';

class CardInfo extends Equatable {
  final int id;
  final String imagePath;
  final String shortName;
  final String longName;
  final String fullText;

  const CardInfo(
      {this.id, this.imagePath, this.shortName, this.longName, this.fullText});

  @override
  List<Object> get props => [id, imagePath, shortName, longName, fullText];

  // Constructor from Json file
  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      id: json['id'],
      imagePath: json['imagePath'],
      shortName: json['shortName'],
      longName: json['longName'],
      fullText: json['fullText'],
    );
  }
}
