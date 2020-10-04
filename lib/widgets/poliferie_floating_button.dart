import 'package:flutter/material.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';

class PoliferieFloatingButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final Color activeColor;
  final Function onPressed;
  final Widget leading;
  final double borderRadius;
  final TextStyle textStyle;

  PoliferieFloatingButton(
      {this.onPressed,
      this.leading,
      this.text = "",
      this.isActive: false,
      this.activeColor,
      this.borderRadius: AppDimensions.widgetBorderRadius,
      this.textStyle: Styles.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: isActive ? activeColor : Styles.poliferieGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        onPressed: isActive ? onPressed : null,
        label: Row(
          children: [
            if (leading != null) leading,
            Text(text, style: textStyle)
          ],
        ),
      ),
    );
  }
}
