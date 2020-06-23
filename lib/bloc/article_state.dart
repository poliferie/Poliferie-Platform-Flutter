import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/models/article.dart';

abstract class ArticleState extends Equatable {
  const ArticleState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class FetchStateLoading extends ArticleState {}

class FetchStateSuccess extends ArticleState {
  final Article article;

  const FetchStateSuccess(this.article);

  @override
  List<Object> get props => [article];

  @override
  String toString() => 'FetchStateSuccess { article: ${article?.id}}';
}

class FetchStateError extends ArticleState {
  final String error;

  const FetchStateError(this.error);

  @override
  List<Object> get props => [error];
}
