import 'package:flutter/material.dart';

import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/styles.dart';

class PoliferieAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final PreferredSizeWidget bottom;
  final double bottomHeight;
  final void Function() onPressed;
  final bool sliverBar;

  // TODO(@amerlo): Add call to settings screen here
  static void emptyOnTap() {}

  const PoliferieAppBar(
      {Key key,
      this.icon = AppIcons.settings,
      this.bottom,
      this.bottomHeight = 0,
      this.sliverBar = false,
      this.onPressed = emptyOnTap})
      : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
  /*{
    if (bottom == null) return Size.fromHeight(AppBar().preferredSize.height);
    return Size.fromHeight(AppBar().preferredSize.height * 2);
  }*/

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
    final titleWidget = Image.asset(
      'assets/images/logo-banner-white.png',
      fit: BoxFit.cover,
      height: 35.0,
    );
    if (bottom == null || sliverBar == false) {
      return AppBar(
        backgroundColor: Styles.poliferieRed,
        title: titleWidget,
        automaticallyImplyLeading: false,
        bottom: bottom,
        actions: <Widget>[_actions(icon)],
      );
    } else {
      return SliverAppBar(
        pinned: true,
        expandedHeight: bottomHeight,
        backgroundColor: Styles.poliferieRed,
        title: titleWidget,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: bottom,
          collapseMode: CollapseMode.parallax,
        ),
        actions: <Widget>[_actions(icon)],
      );
    }
  }
}
