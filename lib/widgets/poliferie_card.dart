import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/models/card.dart';

class PoliferieCard extends StatelessWidget {
  final CardInfo card;

  const PoliferieCard(@required this.card);

  Widget _buildCard(BuildContext context) {
    final _height = MediaQuery.of(context).size.width * 0.55;
    return Container(
      height: _height,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                card.imagePath,
                fit: BoxFit.cover,
                height: _height * 0.50,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(card.shortName, style: Styles.cardHead),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }
}
