// TODO(@amerlo): Add LICENSE

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:poliferie_platform_flutter/styles.dart';
import 'package:poliferie_platform_flutter/strings.dart';

import 'package:poliferie_platform_flutter/screens/base.dart';

class PoliferieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appTitle,
      theme: ThemeData(
          // TODO(@amerlo): Create new color Swatch
          primarySwatch: Colors.red,
          primaryColor: Styles.poliferieRedAccent,
          fontFamily: 'Lato',
          backgroundColor: Styles.poliferieBackground,
          scaffoldBackgroundColor: Styles.poliferieBackground),
      home: BaseScreen(),
    );
  }
}

void main() => runApp(PoliferieApp());
