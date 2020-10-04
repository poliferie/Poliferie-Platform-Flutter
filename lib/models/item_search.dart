import 'package:equatable/equatable.dart';

/// The state of the search which groups all its parameters.
class ItemSearch extends Equatable {
  /// The string query for this search.
  final String query;

  /// The filters selected for this search.
  final Map<String, dynamic> filters;

  /// The order selected for this search.
  final Map<String, dynamic> order;

  ItemSearch({this.query, this.filters, this.order});

  @override
  List<Object> get props => [query, filters, order];
}
