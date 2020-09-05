import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent([List props = const []]) : super();
}

class FetchItems extends ItemEvent {
  final List<int> itemIds;

  const FetchItems(this.itemIds);

  @override
  List<Object> get props => [itemIds];
}
