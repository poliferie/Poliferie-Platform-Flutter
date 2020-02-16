// TODO(@amerlo): Add LICENSE

import 'package:flutter/widgets.dart';

abstract class Styles {
  /// Define UI colors.
  /// Primary color Swatch based on Poliferie Red.
  static const Color poliferieRedAccent = Color.fromRGBO(234, 46, 66, 1.0);

  /// Texts.
  static const Color poliferieLightGrey = Color.fromRGBO(0, 0, 0, 0.25);
  static const Color poliferieDarkGrey = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color poliferieBlack = Color.fromRGBO(0, 0, 0, 1.0);
  static const Color poliferieLightBlack = Color.fromRGBO(0, 0, 0, 0.87);

  /// Background.
  static const Color poliferieWhite = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color poliferieLightWhite = Color.fromRGBO(255, 255, 255, 0.87);
  static const Color poliferieBackground = Color.fromRGBO(225, 228, 229, 1.0);

  /// Define UI text styles.
  static const headline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 48,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  /// Home subheadline text style.
  static const subHeadline = TextStyle(
    color: poliferieDarkGrey,
    fontFamily: 'Lato',
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const headingTab = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const feedPostTitle = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato',
    fontSize: 18.0,
    color: poliferieLightBlack,
  );

  static const feedPostHandle = TextStyle(
    color: poliferieDarkGrey,
    fontFamily: 'Lato',
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
  );

  static const searchTabTitle = TextStyle(
    color: poliferieRedAccent,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    fontSize: 14.0,
  );

  static const profileUserName = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 32,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const profileUserInfoLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    color: poliferieLightGrey,
  );

  static const badgeHeading = TextStyle(
    color: poliferieWhite,
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const badgeDescription = TextStyle(
    color: poliferieWhite,
    fontFamily: 'Lato',
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const courseHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const courseSubHeadline = TextStyle(
    color: poliferieRedAccent,
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const courseApplyButton = TextStyle(
    color: poliferieWhite,
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const courseTabTitle = TextStyle(
    color: poliferieBlack,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    fontSize: 18.0,
  );

  static const courseDataHeading = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Lato',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const courseDataValue = TextStyle(
    color: poliferieLightGrey,
    fontFamily: 'Lato',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const cardDescription = TextStyle(
    color: poliferieLightBlack,
    fontSize: 14.0,
    fontFamily: 'Lato',
    fontStyle: FontStyle.normal,
  );

  static const cardHead = TextStyle(
    color: Styles.poliferieLightBlack,
    fontSize: 25.0,
    height: 1.1,
    fontFamily: 'Lato',
  );

  static const cardLeading = TextStyle(
    color: Styles.poliferieRedAccent,
    fontSize: 17.0,
    height: 1.5,
    fontFamily: 'Lato',
  );

  static const profileStats =
      TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold);

  static const bottomNavBarSelected = TextStyle(fontFamily: 'Lato');

  static const bottomNavBarUnselected = TextStyle(color: poliferieBlack);

  // Set UI Icons as a map
  // TODO(@amerlo): Add icon map

}
