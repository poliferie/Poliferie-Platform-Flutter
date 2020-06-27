import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent([List props = const []]) : super();
}

class FetchFilters extends FilterEvent {
  const FetchFilters();

  @override
  List<Object> get props => [];
}
