import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent([List props = const []]) : super();
}

class FetchItem extends ItemEvent {
  final int itemId;

  const FetchItem(this.itemId);

  @override
  List<Object> get props => [itemId];
}
