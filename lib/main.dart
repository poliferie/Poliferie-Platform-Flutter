import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/screens/base.dart';

class PoliferieApp extends StatelessWidget {
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
          backgroundColor: Styles.poliferieBackground,
          scaffoldBackgroundColor: Styles.poliferieBackground),
      home: BaseScreen(),
    );
  }
}

void main() => runApp(PoliferieApp());
