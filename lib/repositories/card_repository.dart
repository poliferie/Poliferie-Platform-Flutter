import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/models/card.dart';
import 'package:Poliferie.io/repositories/card_client.dart';

class CardRepository {
  final CardClient cardClient;

  CardRepository({@required this.cardClient}) : assert(cardClient != null);

  Future<List<CardInfo>> fetch() async {
    return await cardClient.fetch();
  }
}
