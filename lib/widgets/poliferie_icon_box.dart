import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/dimensions.dart';

class PoliferieIconBox extends StatelessWidget {
  final dynamic child;
  final double iconSize;
  final Color iconColor;
  final Color iconBackgroundColor;

  const PoliferieIconBox(this.child,
      {this.iconSize, this.iconColor, this.iconBackgroundColor});

  Widget _childWidget() {
    if (child is IconData) {
      return Icon(
        child,
        size: iconSize,
        color: iconColor,
      );
    } else if (child is String) {
      return Image.asset(child, height: iconSize, width: iconSize);
    } else {
      return null;
    }
  }

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
              offset: Offset(0, 1)),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.iconBoxBorderRadius),
      ),
      child: _childWidget(),
    );
  }
}
