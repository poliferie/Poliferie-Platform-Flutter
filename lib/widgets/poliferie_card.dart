import 'package:flutter/material.dart';

import 'package:poliferie_platform_flutter/styles.dart';

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
    return Container(
      height: 250.0,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 120.0,
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
