import 'dart:async';
import 'package:meta/meta.dart';

import 'package:Poliferie.io/models/item.dart';
import 'package:Poliferie.io/repositories/item_client.dart';

class ItemRepository {
  final ItemClient itemClient;

  ItemRepository({@required this.itemClient}) : assert(itemClient != null);

  Future<ItemModel> fetch(int id) async {
    return await itemClient.fetch(id);
  }
}
