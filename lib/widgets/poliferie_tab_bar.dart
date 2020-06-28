import 'package:Poliferie.io/dimensions.dart';
import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

class PoliferieTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PoliferieTabBar({Key key}) : super(key: key);

  final double _borderRadius = AppDimensions.widgetBorderRadius;

  @override
  Size get preferredSize {
    return Size.fromHeight(AppBar().preferredSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: Styles.poliferieVeryLightGrey,
          width: 2,
        ),
      ),
      child: TabBar(
        labelColor: Styles.poliferieWhite,
        unselectedLabelColor: Styles.poliferieRed,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
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
      ),
    );
  }
}
