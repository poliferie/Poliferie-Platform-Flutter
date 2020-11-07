import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Article extends Equatable {
  final String id;
  final ImageProvider image;
  final String title;
  final String subtitle;
  final String bodyMarkdownSource;

  const Article(
      {@required this.id,
      @required this.title,
      this.subtitle,
      this.image,
      @required this.bodyMarkdownSource // see https://github.github.com/gfm/
      });

  @override
  List<Object> get props => [id];

  // Constructor from Json file
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      image: json['image'].toString().startsWith('http')
          ? NetworkImage(json['image'], scale: 1.0)
          : AssetImage(json['image']),
      title: json['title'],
      subtitle: json['subtitle'],
      bodyMarkdownSource: rawToString(json['body']),
    );
  }
}

String rawToString(String raw) {
  return json.decode(r'{ "data":"' + raw + r'"}')['data'];
}
