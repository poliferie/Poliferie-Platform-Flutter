import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'package:Poliferie.io/models/card.dart';

// TODO(@amerlo): Implement API call
class CardClient {
  final String baseUrl;
  final bool useLocalJson;
  CardClient(
      {this.baseUrl = "https://api.poliferie.org/user?q=",
      this.useLocalJson = false});

  Future<List<CardInfo>> fetch() async {
    if (useLocalJson) {
      String cardData =
          await rootBundle.loadString("assets/data/mockup/cards.json");
      final List<dynamic> cards = json.decode(cardData).toList();
      return cards.map((e) => CardInfo.fromJson(e)).toList();
    } else {
      return <CardInfo>[];
    }
  }
}
