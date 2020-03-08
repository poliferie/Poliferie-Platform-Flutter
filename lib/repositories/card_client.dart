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
      String _data = await rootBundle.loadString("assets/data/cards.json");
      final _cardList = json.decode(_data).toList();
      return <CardInfo>[
        CardInfo.fromJson(_cardList[0]),
        CardInfo.fromJson(_cardList[1]),
      ];
    } else {
      return <CardInfo>[];
    }
  }
}