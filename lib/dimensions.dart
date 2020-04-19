import 'package:flutter/widgets.dart';

/// Class which holds layout parameters for the entire app.
class AppDimensions {
  // Values
  static const double bodyPaddingLeft = 30.0;
  static const double bodyPaddingTop = 50.0;
  static const double bodyPaddingRight = 30.0;
  static const double bodyPaddingBottom = 70.0;

  static const double bottomSheetPaddingHorizontal = 10.0;
  static const double bottomSheetPaddingVertical = 20.0;

  // Paddings
  static const EdgeInsets bodyPadding = EdgeInsets.fromLTRB(
      bodyPaddingLeft, bodyPaddingTop, bodyPaddingRight, bodyPaddingBottom);
  static const EdgeInsets subHeadlinePadding =
      EdgeInsets.fromLTRB(0, 20.0, 0, 20.0);

  static const EdgeInsets searchBodyPadding =
      EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0);

  static const EdgeInsets bottomSheetPadding =
      EdgeInsets.symmetric(horizontal: bottomSheetPaddingHorizontal);

  static const EdgeInsets iconBoxPadding = EdgeInsets.all(8.0);

  // Sizes
  static const double bottomNavigationBarIconSize = 32.0;

  static const double iconBoxBorderRadius = 6.0;
  static const double iconBoxBorderWidth = 2.0;
}
