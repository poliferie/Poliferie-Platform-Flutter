import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';

class CompareScreen extends StatefulWidget {
  CompareScreen({Key key}) : super(key: key);

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  /// UI Elements for this page
  static const _headline =
      Text(Strings.compareHeadline, style: Styles.headline);
  static const _subHeadline = Text(
    Strings.compareSubHeadline,
    style: Styles.subHeadline,
  );

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: AppDimensions.bodyPadding,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _headline,
          _subHeadline,
        ],
      ),
    );
  }

  /// Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(icon: AppIcons.settings),
      body: _buildBody(context),
    );
  }
}
