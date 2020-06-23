import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Poliferie.io/bloc/article_event.dart';
import 'package:Poliferie.io/bloc/article_state.dart';
import 'package:Poliferie.io/repositories/article_repository.dart';
import 'package:Poliferie.io/models/article.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository articleRepository;

  ArticleBloc({this.articleRepository}) : assert(articleRepository != null);

  @override
  Stream<ArticleState> transformEvents(
    Stream<ArticleEvent> events,
    Stream<ArticleState> Function(ArticleEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  // TODO(@amerlo): Include more details for the transition here
  @override
  void onTransition(Transition<ArticleEvent, ArticleState> transition) {
    print(transition);
  }

  @override
  ArticleState get initialState => FetchStateLoading();

  @override
  Stream<ArticleState> mapEventToState(ArticleEvent event) async* {
    if (event is FetchArticle) {
      yield FetchStateLoading();
      try {
        final Article article = await articleRepository.getById(event.articleId);
        yield FetchStateSuccess(article);
      } catch (error) {
        yield FetchStateError(error.message);
      }
    }
  }
}
