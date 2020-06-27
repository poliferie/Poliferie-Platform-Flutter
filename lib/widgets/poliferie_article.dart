import 'package:Poliferie.io/bloc/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:Poliferie.io/models/article.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/article_bloc.dart';

class PoliferieArticle extends StatelessWidget {
  final Article article;

  const PoliferieArticle({Key key, this.article}) : super(key: key);

  Widget _buildImage(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.0),
        child: Image(
          image: article.image,
          width: MediaQuery.of(context).size.width * 0.6,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      article.title,
      style: Styles.articleHeadline,
    );
  }

  Widget _buildSubTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        article.subtitle,
        style: Styles.articleSubHeadline,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Styles.poliferieRed,
      thickness: 2.0,
      height: 40,
    );
  }

  Widget _buildArticle() {
    return MarkdownBody(
      data: article.bodyMarkdownSource,
      styleSheet: MarkdownStyleSheet(textScaleFactor: 1.1),
      fitContent: false,
      // TODO(@ferrarodav): textScaleFactor = 1.5 is not too much? I would leave 1.0...
      // selectable: true, // TODO(@ferrarodav): understand why if selectable "textScaleFactor" doesn't work
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (article.image != null) _buildImage(context),
          _buildTitle(),
          if (article.subtitle != null) _buildSubTitle(),
          _buildDivider(),
          _buildArticle(),
        ],
      ),
    );
  }

  static void Function() _bottomSheetCaller(BuildContext context, Widget body) {
    return () {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.5,
                minChildSize: 0.25,
                builder: (BuildContext context, ScrollController controller) {
                  return SingleChildScrollView(
                    controller: controller,
                    child: body,
                  );
                });
          });
    };
  }

  static Widget _lazyBodyBuilder(BuildContext context, int articleId) {
    return BlocProvider<ArticleBloc>(
      create: (context) {
        final ArticleBloc bloc = ArticleBloc(
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context));
        bloc.add(FetchArticle(articleId));
        return bloc;
      },
      child: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (BuildContext context, ArticleState state) {
          if (state is FetchStateLoading) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is FetchStateError) {
            return Text(state.error);
          }
          if (state is FetchStateSuccess) {
            return PoliferieArticle(article: state.article);
          }
          return Text('This widge should never be reached');
        },
      ),
    );
  }

  void Function() bottomSheetCaller(BuildContext context) {
    return _bottomSheetCaller(context, this);
  }

  static void Function() lazyBottomSheetCaller(
      BuildContext context, int articleId) {
    return _bottomSheetCaller(context, _lazyBodyBuilder(context, articleId));
  }
}
