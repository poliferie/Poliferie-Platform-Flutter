import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

class PoliferieIconBox extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const PoliferieIconBox(this.icon, {this.iconSize, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.poliferieVeryLightGrey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
