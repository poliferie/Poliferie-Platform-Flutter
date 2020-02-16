import 'package:flutter/material.dart';

import 'package:poliferie_platform_flutter/styles.dart';

class PoliferieAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final void Function() onTap;

  const PoliferieAppBar({Key key, this.icon, this.onTap}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  Widget _actions(icon) {
    return IconButton(
      padding: EdgeInsets.all(5.0),
      icon: Icon(icon, color: Styles.poliferieRedAccent),
      onPressed: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/images/PF_Logo_Rosso.png',
            fit: BoxFit.cover,
            height: 35.0,
          )
        ],
      ),
      actions: <Widget>[_actions(icon)],
    );
  }
}
