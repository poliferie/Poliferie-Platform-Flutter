import 'package:flutter/widgets.dart';

/// Class which holds text styles and colors for the entire app.
abstract class Styles {
  // Colors used for UI components.
  static const Color poliferieRed = Color.fromRGBO(234, 46, 66, 1.0);
  static const Color poliferieBlue = Color.fromRGBO(0, 140, 211, 1.0);
  static const Color poliferieWhite = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color poliferieLightWhite = Color.fromRGBO(255, 255, 255, 0.87);
  static const Color poliferieBackground = Color.fromRGBO(255, 255, 255, 0.75);
  static const Color poliferieGreen = Color.fromRGBO(113, 193, 179, 1.0);
  static const Color poliferieYellow = Color.fromRGBO(248, 192, 43, 1.0);
  static const Color poliferieGrey = Color.fromRGBO(226, 226, 226, 1.0);
  static const Color poliferiePink = Color.fromRGBO(229, 99, 153, 1.0);

  // Colors used for texts.
  static const Color poliferieLightGrey = Color.fromRGBO(0, 0, 0, 0.25);
  static const Color poliferieVeryLightGrey = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color poliferieDarkGrey = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color poliferieBlack = Color.fromRGBO(0, 0, 0, 1.0);
  static const Color poliferieLightBlack = Color.fromRGBO(0, 0, 0, 0.87);

  // Text styles.
  static const headline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 48,
    height: 1.3,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const subHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const headlineWhite = TextStyle(
    color: poliferieWhite,
    fontFamily: 'Montserrat',
    fontSize: 48,
    height: 1.3,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const subHeadlineWhite = TextStyle(
    color: poliferieWhite,
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const articleHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 36,
    height: 1.2,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const articleSubHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const tabHeading = TextStyle(
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
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    fontSize: 14.0,
  );

  static const tabDescription = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Lato',
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
  );

  static const filterValueBoxText = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
  );

  static const filterValueBoxValue = TextStyle(
    color: poliferieRed,
    fontFamily: 'Montserrat',
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  static const buttonTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    fontSize: 22.0,
  );

  static const buttonText = TextStyle(
    fontWeight: FontWeight.bold,
    color: poliferieBlack,
    fontFamily: 'Montserrat',
    fontSize: 16.0,
  );

  static const filterName = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static const filterHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 22.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const profileUserName = TextStyle(
    color: poliferieWhite,
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const profileSubHeadline = TextStyle(
    color: poliferieWhite,
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static const profileUserInfoLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    color: poliferieLightGrey,
  );

  static const profileExpandAll = TextStyle(
    color: poliferieRed,
    fontFamily: 'Lato',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const suggestionTitleBold = TextStyle(
    color: poliferieBlack,
    fontFamily: 'Lato',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const suggestionTitle = TextStyle(
    color: poliferieBlack,
    fontFamily: 'Lato',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
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

  static const resultHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const resultSubHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const courseHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const courseSubHeadline = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const courseLocation = TextStyle(
    color: poliferieLightGrey,
    fontFamily: 'Lato',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const courseInfoStats = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 14.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
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

  static const cardHeadVertical = TextStyle(
    color: Styles.poliferieLightBlack,
    fontSize: 15.0,
    height: 1.2,
    fontFamily: 'Montserrat',
  );

  static const cardHeadHorizontal = TextStyle(
    color: Styles.poliferieLightBlack,
    fontSize: 18.0,
    height: 1.2,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static const cardHeadHorizontalWhite = TextStyle(
    color: Styles.poliferieWhite,
    fontSize: 18.0,
    height: 1.2,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static const cardHeadHorizontalGray = TextStyle(
    color: Styles.poliferieLightGrey,
    fontSize: 18.0,
    height: 1.2,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static const cardSubHeading = TextStyle(
    color: Styles.poliferieLightBlack,
    fontSize: 14.0,
    fontFamily: 'Lato',
  );

  static const cardSubHeadingWhite = TextStyle(
    color: Styles.poliferieWhite,
    fontSize: 14.0,
    fontFamily: 'Lato',
  );

  static const cardLeading = TextStyle(
    color: Styles.poliferieRed,
    fontSize: 17.0,
    height: 1.5,
    fontFamily: 'Lato',
  );

  static const profileStats = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static const statsTitle = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static const statsDescription = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const disabledStatsTitle = TextStyle(
    color: poliferieLightGrey,
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static const disabledStatsDescription = TextStyle(
    color: poliferieLightGrey,
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const statsValue = TextStyle(
    color: poliferieLightBlack,
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const bottomNavBarSelected = TextStyle(
    fontFamily: 'Lato',
  );

  static const bottomNavBarUnselected = TextStyle(
    color: poliferieBlack,
  );
}
