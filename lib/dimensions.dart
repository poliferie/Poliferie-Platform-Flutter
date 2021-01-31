import 'package:flutter/widgets.dart';

// TODO(@amerlo): Maybe is better to keep only raw double values here, and then
//                combine them in the widget

/// Class which holds layout parameters for the entire app.
class AppDimensions {
  // Values
  static const double bodyPaddingLeft = 30.0;
  static const double bodyPaddingTop = 20.0;
  static const double bodyPaddingRight = 30.0;
  static const double bodyPaddingBottom = 10.0;

  static const double bottomSheetPaddingHorizontal = 10.0;
  static const double bottomSheetPaddingVertical = 20.0;

  // Paddings
  static const EdgeInsets bodyPadding = EdgeInsets.fromLTRB(
      bodyPaddingLeft, bodyPaddingTop, bodyPaddingRight, bodyPaddingBottom);
  static const EdgeInsets subHeadlinePadding =
      EdgeInsets.fromLTRB(0, 20.0, 0, 0.0);

  static const EdgeInsets bottomSheetPadding =
      EdgeInsets.symmetric(horizontal: bottomSheetPaddingHorizontal);

  static const EdgeInsets iconBoxPadding = EdgeInsets.all(6.0);

  static const EdgeInsets betweenFiltersPadding =
      EdgeInsets.symmetric(vertical: 1.0);

  static const EdgeInsets betweenTabs = EdgeInsets.symmetric(vertical: 20.0);

  // Sizes
  static const double iconBoxBorderRadius = 6.0;
  static const double iconBoxBorderWidth = 2.0;

  static const double itemCardHeight = 72.0;
  static const double itemCardPaddingVertical = 6.0;

  static const double filterIconSize = 28;
  static const double filterTitleFontSize = 16;
  static const double filterCardBorderRadius = 10.0;

  static const double bottomNavigationBarBorderRadius = 30.0;
  static const double bottomNavigationBarIconSize = 32.0;

  static const double screenContainerBoxRadius = 20.0;

  static const double widgetBorderRadius = 30.0;
}
