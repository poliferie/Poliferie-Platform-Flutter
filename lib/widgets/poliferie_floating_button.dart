import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

class PoliferieFloatingButton extends StatelessWidget {
  final String text;
  final Color activeColor;
  final Function onPressed;

  PoliferieFloatingButton({this.text = "", this.onPressed, this.activeColor});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: activeColor,
      focusColor: activeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: onPressed,
      label: Text(text, style: Styles.buttonTitle),
    );
  }
}
