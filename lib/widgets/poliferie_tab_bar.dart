import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

class PoliferieTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PoliferieTabBar({Key key}) : super(key: key);

  final double _borderRadius = 10.0;

  @override
  Size get preferredSize {
    return Size.fromHeight(AppBar().preferredSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Styles.poliferieWhite,
      unselectedLabelColor: Styles.poliferieRed,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_borderRadius),
          topRight: Radius.circular(_borderRadius),
          bottomLeft: Radius.circular(_borderRadius),
          bottomRight: Radius.circular(_borderRadius),
        ),
        color: Styles.poliferieRed,
      ),
      tabs: [
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              Strings.searchTabCourse.toUpperCase(),
              style: Styles.searchTabTitle,
            ),
          ),
        ),
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              Strings.searchTabUniversity.toUpperCase(),
              style: Styles.searchTabTitle,
            ),
          ),
        ),
      ],
    );
  }
}
