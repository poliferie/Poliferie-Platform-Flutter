import 'package:flutter/material.dart';

import 'package:Poliferie.io/models/card.dart';

import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';

import 'package:Poliferie.io/widgets/poliferie_article.dart';

// TODO(@amerlo): Add support for card and text color

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
      if (card.linksTo.length > 0 && card.linksTo.split(':').length == 2) {
        List link = card.linksTo.split(':');
        if (link[0] == 'articles') {
          return PoliferieArticle.lazyBottomSheetCaller(context, int.parse(link[1]));
        } else if (link[0] == 'search') {
          // navigate to search with some preset (ex. search:regione -> go to search with same regione filter)
        }
      }
      return () {};
    }
    return onTap;
  }

  Widget _buildCard(BuildContext context) {
    // Build child for vertical extended card
    Widget _child = Container(
      // TODO(@amerlo): Fix width with the number of horizontal cards
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            card.image,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(card.title, style: Styles.cardHeadVertical),
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
              child: Image.asset(
                card.image,
                fit: BoxFit.cover,
              ),
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
