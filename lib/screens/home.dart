import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";

import 'package:poliferie_platform_flutter/dimensions.dart';
import 'package:poliferie_platform_flutter/strings.dart';
import 'package:poliferie_platform_flutter/styles.dart';

import 'package:poliferie_platform_flutter/widgets/poliferie_app_bar.dart';
import 'package:poliferie_platform_flutter/widgets/poliferie_card.dart';
import 'package:poliferie_platform_flutter/widgets/poliferie_tile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildHeadline(String headline) {
    return Text(headline, style: Styles.headline);
  }

  Widget _buildSubHeadline(String subHeadline) {
    return Padding(
      padding: AppDimensions.subHeadlinePadding,
      child: Text(
        subHeadline,
        style: Styles.subHeadline,
      ),
    );
  }

  Widget _buildRowHeading(String heading) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        heading,
        style: Styles.headingTab,
      ),
    );
  }

  Widget _buildRowCards(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PoliferieCard('assets/images/squadra.png', Strings.cardCourses),
        PoliferieCard('assets/images/squadra.png', Strings.cardUniversities),
      ],
    ));
  }

  // TODO(@amerlo): To be removed
  Widget _buildList(BuildContext context, List<PoliferieTile> cards) {
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
    return ListView(
      padding: AppDimensions.bodyPadding,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildHeadline(Strings.homeHeadline),
        _buildSubHeadline(Strings.homeSubHeadline),
        _buildRowHeading(Strings.homeSearch),
        _buildRowCards(context),
        _buildRowHeading(Strings.homeDiscover),
        ...discoverCardList,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(),
      body: _buildBody(context),
    );
  }
}
