import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/screens/onboarding.dart';
import 'package:Poliferie.io/screens/base.dart';

class PoliferieApp extends StatelessWidget {
  final bool showOnBoarding;

  const PoliferieApp({Key key, @required this.showOnBoarding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appTitle,
      theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Styles.poliferieRed,
          fontFamily: 'Lato',
          backgroundColor: Styles.poliferieWhite,
          scaffoldBackgroundColor: Styles.poliferieWhite),
      home: showOnBoarding ? OnBoardingScreen() : BaseScreen(),
    );
  }
}

Future<bool> isOnBoardingCompleted() async {
  return (await SharedPreferences.getInstance())
          .getBool('onBoardingIsComplted') ??
      false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool showOnBoarding = !(await isOnBoardingCompleted());
  // Comment line below for deploying
  showOnBoarding = false;

  return runApp(PoliferieApp(showOnBoarding: showOnBoarding));
}
