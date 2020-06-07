import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

class PoliferieFloatingButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final Color activeColor;
  final Function onPressed;

  PoliferieFloatingButton(
      {this.text = "", this.onPressed, this.isActive: false, this.activeColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FloatingActionButton.extended(
        backgroundColor: isActive ? activeColor : Styles.poliferieGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: onPressed,
        label: Text(text, style: Styles.buttonTitle),
      ),
    );
  }
}
