import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:Poliferie.io/models/article.dart';
import 'package:Poliferie.io/styles.dart';

class PoliferieArticle extends StatelessWidget{
  final Article article;

  const PoliferieArticle({
    Key key,
    this.article
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20), 
      child: Column(
        children: <Widget>[
          SizedBox(height: 25),
          ...((article.image != null) ? <Widget>[
            Image(
              image: article.image, 
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20,)
          ] : <Widget>[]),
          Text(
            article.title,
            style: Styles.headline,
          ),
          ...((article.subtitle != null) ? <Widget>[
            SizedBox(height: 10,),
            Text(
              article.subtitle,
              style: Styles.subHeadline,
            ),
          ] : <Widget>[]),
          Divider(height: 40,),
          MarkdownBody(
            data: article.bodyMarkdownSource,
            styleSheet: MarkdownStyleSheet(textScaleFactor: 1.5),
            fitContent: false,
            // selectable: true, // TODO(@ferrarodav): understand why if selectable "textScaleFactor" doesn't work
          ),
        ],
      ),
    );
  }

  void Function() bottomSheetCaller(BuildContext context) {
    return () {
      showModalBottomSheet(
        context: context, 
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController controller) {
              return SingleChildScrollView(controller: controller, child: this);
            }
          );
        }
      );
    };
  }
} 