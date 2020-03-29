import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/screens/card.dart';

/// TODO(@amerlo): Move this to BLoC
final studyingTabList = <PoliferieTile>[
  PoliferieTile(
      'assets/images/squadra.png',
      'Sardegna',
      'Migliori Università in Sardegna',
      "SASSARI. Le università sarde sono tra le migliori d’Italia. "
          "La classifica annuale stilata dal Censis, infatti, ha premiato"
          " gli atenei di Sassari e Cagliari piazzandoli ai vertici delle"
          " categorie di riferimento: l’università di Sassari è seconda "
          "nella graduatoria degli atenei di medie dimensioni, ovvero"
          " quelli che hanno un numero di iscritti compreso tra i diecimila e i ventimila studenti,"
          " mentre Cagliari è quinta nella classifica dei “grandi atenei”, che"
          " contano tra i ventimila e i quarantamila iscritti."),
  PoliferieTile('assets/images/squadra.png', 'Piemonte',
      'Migliori Università in Piemonte', 'Piemonte'),
  PoliferieTile('assets/images/squadra.png', 'Università', 'Entrare a Medicina',
      'Medicina'),
  PoliferieTile('assets/images/squadra.png', 'Università',
      'Entrare a Giurisprudenza', 'Giurisprudenza'),
  PoliferieTile('assets/images/squadra.png', 'Università',
      'Le Unviersità Private', 'Università')
];

class PoliferieTile extends StatelessWidget {
  final String imagePath;
  final String leading;
  final String head;
  final String body;

  const PoliferieTile(this.imagePath, this.leading, this.head, this.body);

  Widget _buildTile(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 55.0,
      ),
      title: Text(head),
      subtitle: Text(leading, style: TextStyle(color: Styles.poliferieRed)),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PageScreen(card: this)),
        );
      },
    );
  }

  Widget _buildCardTile(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: _buildTile(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardTile(context);
  }
}
