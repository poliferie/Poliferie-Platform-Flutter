import 'package:Poliferie.io/bloc/search_bloc.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/screens/results.dart';
import 'package:Poliferie.io/widgets/poliferie_search_delegate.dart';
import 'package:flutter/material.dart';

import 'package:Poliferie.io/models/card.dart';

import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';

import 'package:Poliferie.io/widgets/poliferie_article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CardOrientation { horizontal, vertical }

class PoliferieCard extends StatelessWidget {
  final CardInfo card;
  final Function onTap;
  final CardOrientation orientation;
  final Color color;

  const PoliferieCard(this.card,
      {this.onTap: _dummyTapFn,
      this.orientation: CardOrientation.vertical,
      this.color: Styles.poliferieWhite});

  static void _dummyTapFn() {}

  void Function() handleTap(BuildContext context) {
    if (onTap == _dummyTapFn) {
      if (card.linksTo.length > 0) {
        // TODO(@ferrarodav): Could you check if this is in line with your idea?
        // Hack to split only on first occurrence of ':'
        int indexToSplit = card.linksTo.indexOf(':');
        List<String> link = [
          card.linksTo.substring(0, indexToSplit),
          card.linksTo.substring(indexToSplit + 1)
        ];
        if (link[0] == 'articles') {
          return PoliferieArticle.lazyBottomSheetCaller(
              context, int.parse(link[1]));
        } else if (link[0] == 'search') {
          if (link[1] != "{}") {
            // navigate to search with filter status specified as json string. As for example:
            //
            // search:{"itemType":"course","satisfaction":{"from":80,"to":100}}
            // Then pass the json string directly to the ResultsScreen, like:
            // ResultsScreen(link[1])
            // TODO(@amerlo): At the moment, redirect to ResultsScreen with just the keyword arg.
            // TODO(@amerlo): All these "\""" are really needed?
            Map<String, String> keys = link[1]
                .replaceAll("{", "")
                .replaceAll("}", "")
                .split(",")
                .asMap()
                .map((k, v) => MapEntry(v.split(":")[0].replaceAll("\"", ""),
                    v.split(":")[1].replaceAll("\"", "")));
            if (keys.containsKey("query")) {
              // TODO(@amerlo): Here we should pass the SearchDelegate, taking the SearchBloc from the home.
              return () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsScreen(keys["query"]),
                  ),
                );
              };
            }
          }
        }
      }
      return () {};
    }
    return onTap;
  }

  Widget _buildCard(BuildContext context) {
    // Build child for vertical extended card
    final double _width = MediaQuery.of(context).size.width * 0.33;
    Widget _child = Container(
      width: _width,
      height: _width * 1.33,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Column(
        children: <Widget>[
          getImage(card.image),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            // TODO(@amerlo): Multi-lines text has to be centered
            child: Text(
              card.title,
              style: Styles.cardHeadVertical,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
    // Build child for horizontal extended card
    if (orientation == CardOrientation.horizontal) {
      _child = Container(
        // TODO(@amerlo): Fix card width
        // TODO(@ferrarodav): Make scrollable horizontal? (like spotify app)
        height: MediaQuery.of(context).size.width * 0.33,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Text(card.title,
                      style: color == Styles.poliferieRed
                          ? Styles.cardHeadHorizontalWhite
                          : Styles.cardHeadHorizontal),
                  Text(
                      card.subtitle == null
                          ? Strings.cardDefaultSubTitle
                          : card.subtitle,
                      style: color == Styles.poliferieRed
                          ? Styles.cardSubHeadingWhite
                          : Styles.cardSubHeading),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
            Expanded(
              flex: 2,
              child: getImage(card.image),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: handleTap(context),
      child: Card(
        color: color,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: _child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }
}

Image getImage(String src) {
  if (src.startsWith("http")) {
    return Image.network(src, fit: BoxFit.cover);
  } else {
    return Image.asset(src, fit: BoxFit.cover);
  }
}
