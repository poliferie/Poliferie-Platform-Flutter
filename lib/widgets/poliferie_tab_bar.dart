import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

class PoliferieTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PoliferieTabBar({Key key}) : super(key: key);

  @override
  Size get preferredSize {
    return Size.fromHeight(AppBar().preferredSize.height);
  }

  // TODO(@amerlo): Set logo dimensions and padding
  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Styles.poliferieRedAccent,
      unselectedLabelColor: Styles.poliferieWhite,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white),
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
