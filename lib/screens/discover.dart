// TODO(@amerlo): Add LICENSE

import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";

import 'package:poliferie_platform_flutter/widgets/poliferie_app_bar.dart';
import 'package:poliferie_platform_flutter/styles.dart';
import 'package:poliferie_platform_flutter/widgets/poliferie_card.dart';
import 'package:poliferie_platform_flutter/strings.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({Key key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  /// UI Elements for this page
  static const _headline =
      Text(Strings.discoverHeadline, style: Styles.headline);

  static const _subHeadline = Text(
    Strings.discoverSubHeadline,
    style: Styles.subHeadline,
  );

  Widget _headingTab(String heading) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        heading.toUpperCase(),
        style: Styles.headingTab,
      ),
    );
  }

  Widget _buildList(BuildContext context, List<PoliferieCard> cards) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: cards.length,
        itemBuilder: (BuildContext context, int index) {
          return cards[index];
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _headline,
          _subHeadline,
          _headingTab(Strings.discoverStudying),
          _buildList(context, studyingTabList),
          _headingTab(Strings.discoverLiving),
          _buildList(context, studyingTabList),
        ],
      ),
    );
  }

  /// Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(icon: Icons.menu),
      body: _buildBody(context),
    );
  }
}
