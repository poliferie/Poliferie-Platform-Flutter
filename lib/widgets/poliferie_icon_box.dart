import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/dimensions.dart';

class PoliferieIconBox extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const PoliferieIconBox(this.icon, {this.iconSize, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.iconBoxPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.poliferieVeryLightGrey,
          width: AppDimensions.iconBoxBorderWidth,
        ),
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
