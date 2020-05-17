import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/dimensions.dart';

class PoliferieIconBox extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color iconBackgroundColor;

  const PoliferieIconBox(this.icon, {this.iconSize, this.iconColor, this.iconBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.iconBoxPadding,
      decoration: BoxDecoration(
        color: this.iconBackgroundColor ?? Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(0, 1)
          ),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.iconBoxBorderRadius),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
