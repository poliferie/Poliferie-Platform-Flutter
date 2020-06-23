import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent([List props = const []]) : super();
}

class FetchArticle extends ArticleEvent {
  final int articleId;

  const FetchArticle(this.articleId);

  @override
  List<Object> get props => [articleId];
}
