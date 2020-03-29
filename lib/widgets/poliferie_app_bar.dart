import 'package:flutter/material.dart';

import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/styles.dart';

class PoliferieAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final PreferredSizeWidget bottom;
  final void Function() onPressed;

  // TODO(@amerlo): Add call to settings screen here
  static void emptyOnTap() {}

  const PoliferieAppBar(
      {Key key,
      this.icon = AppIcons.settings,
      this.bottom = null,
      this.onPressed = emptyOnTap})
      : super(key: key);

  @override
  Size get preferredSize {
    if (bottom == null) return Size.fromHeight(AppBar().preferredSize.height);
    return Size.fromHeight(AppBar().preferredSize.height * 2);
  }

  // TODO(@amerlo): Set icon padding and set based on design screens
  Widget _actions(icon) {
    return IconButton(
      padding: EdgeInsets.all(5.0),
      icon: Icon(icon, color: Styles.poliferieWhite),
      onPressed: onPressed,
    );
  }

  // TODO(@amerlo): Set logo dimensions and padding
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Styles.poliferieRed,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/images/PF_Logo_White.png',
            fit: BoxFit.cover,
            height: 35.0,
          )
        ],
      ),
      bottom: bottom,
      actions: <Widget>[_actions(icon)],
    );
  }
}
