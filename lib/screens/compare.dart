import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";

import 'package:poliferie_platform_flutter/icons.dart';
import 'package:poliferie_platform_flutter/strings.dart';
import 'package:poliferie_platform_flutter/styles.dart';
import 'package:poliferie_platform_flutter/widgets/poliferie_app_bar.dart';

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
      padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
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
