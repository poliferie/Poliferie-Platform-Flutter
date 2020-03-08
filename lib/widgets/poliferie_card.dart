import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

// TODO(@amerlo): Remove from here and create json file
final discoverCardList = <PoliferieCard>[
  PoliferieCard('assets/images/squadra.png', 'Migliori Università in Piemonte'),
  PoliferieCard('assets/images/squadra.png', 'Migliori Università in Sicilia'),
];

class PoliferieCard extends StatelessWidget {
  final String imagePath;
  final String heading;

  const PoliferieCard(this.imagePath, this.heading);

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
                imagePath,
                fit: BoxFit.cover,
                height: _height * 0.50,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(heading, style: Styles.cardHead),
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
