import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

class PoliferieValueBox extends StatelessWidget {
  final String text;
  final String value;

  const PoliferieValueBox(this.text, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(6.0, 6.0, 10.0, 6.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.poliferieVeryLightGrey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text, style: Styles.filterValueBoxText),
          Text(
            value,
            style: Styles.filterValueBoxValue,
          ),
        ],
      ),
    );
  }
}
