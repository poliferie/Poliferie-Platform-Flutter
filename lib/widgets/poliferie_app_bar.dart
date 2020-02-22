import 'package:flutter/material.dart';

import 'package:poliferie_platform_flutter/icons.dart';
import 'package:poliferie_platform_flutter/styles.dart';

class PoliferieAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final void Function() onTap;

  // TODO(@amerlo): Add call to settings screen here
  static void emptyOnTap() {}

  const PoliferieAppBar(
      {Key key, this.icon = AppIcons.settings, this.onTap = emptyOnTap})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  // TODO(@amerlo): Set icon padding and set based on design screens
  Widget _actions(icon) {
    return IconButton(
      padding: EdgeInsets.all(5.0),
      icon: Icon(icon, color: Styles.poliferieWhite),
      onPressed: onTap,
    );
  }

  // TODO(@amerlo): Set logo dimensions and padding
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Styles.poliferieRedAccent,
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
      actions: <Widget>[_actions(icon)],
    );
  }
}
