import 'package:flutter/material.dart';

import 'package:Poliferie.io/models/card.dart';

import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';

// TODO(@amerlo): Add support for card and text color

enum CardOrientation { horizontal, vertical }

class PoliferieCard extends StatelessWidget {
  final CardInfo card;
  final Function onTap;
  final CardOrientation orientation;

  const PoliferieCard(this.card,
      {this.onTap, this.orientation: CardOrientation.vertical});

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
          height: MediaQuery.of(context).size.width * 0.33,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Text(card.title, style: Styles.cardHeadHorizontal),
                    Text(
                        card.subtitle == null
                            ? Strings.cardDefaultSubTitle
                            : card.subtitle,
                        style: Styles.cardSubHeading),
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
          ));
    }
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
