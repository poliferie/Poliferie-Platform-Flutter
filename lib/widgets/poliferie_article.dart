import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:Poliferie.io/models/article.dart';
import 'package:Poliferie.io/styles.dart';

class PoliferieArticle extends StatelessWidget {
  final Article article;

  const PoliferieArticle({Key key, this.article}) : super(key: key);

  Widget _buildImage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Image(
          image: article.image,
          height: 150,
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
      styleSheet: MarkdownStyleSheet(textScaleFactor: 1.5),
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
          if (article.image != null) _buildImage(),
          _buildTitle(),
          if (article.subtitle != null) _buildSubTitle(),
          _buildDivider(),
          _buildArticle(),
        ],
      ),
    );
  }

  void Function() bottomSheetCaller(BuildContext context) {
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
                      controller: controller, child: this);
                });
          });
    };
  }
}
