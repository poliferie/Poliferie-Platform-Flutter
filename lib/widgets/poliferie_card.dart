import 'dart:convert' show json;
import 'package:flutter/material.dart';

import 'package:Poliferie.io/models/card.dart';
import 'package:Poliferie.io/models/item_search.dart';
import 'package:Poliferie.io/screens/results.dart';
import 'package:Poliferie.io/screens/item.dart';

import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/configs.dart';

import 'package:Poliferie.io/widgets/poliferie_article.dart';

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
        int indexToSplit = card.linksTo.indexOf('/');
        List<String> link = [
          card.linksTo.substring(0, indexToSplit),
          card.linksTo.substring(indexToSplit + 1)
        ];

        // Links to article.
        if (link[0] == 'articles') {
          return PoliferieArticle.lazyBottomSheetCaller(context, link[1]);
        }

        if (link[0] == Configs.firebaseItemsCollection) {
          // Links to item.
          if (!link[1].contains("{")) {
            return () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // TODO(@amerlo): To be migrated to string id.
                  builder: (context) => ItemScreen(int.parse(link[1])),
                ),
              );
            };
          }

          // Links to all collections.
          if (link[1] == "{}") {
            return () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // TODO(@amerlo): To be migrated to string id.
                  builder: (context) => ResultsScreen(ItemSearch()),
                ),
              );
            };
          }

          // Perform search.
          final Map<String, dynamic> search = json.decode(link[1]);
          String query = search.containsKey("query") ? search["query"] : null;
          final Map<String, dynamic> filters =
              search.containsKey("filters") ? search["filters"] : null;
          final Map<String, dynamic> order =
              search.containsKey("order") ? search["order"] : null;

          return () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(
                    ItemSearch(query: query, filters: filters, order: order)),
              ),
            );
          };
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
