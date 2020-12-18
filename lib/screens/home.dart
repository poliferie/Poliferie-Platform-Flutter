import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/bloc/card.dart';
import 'package:Poliferie.io/models/card.dart';
import 'package:Poliferie.io/screens/onboarding.dart';
import 'package:Poliferie.io/repositories/repositories.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/configs.dart';

import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_card.dart';
import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class HomeScreenBody extends StatelessWidget {
  HomeScreenBody({Key key}) : super(key: key);

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
        style: Styles.tabHeading,
      ),
    );
  }

  Widget _buildRowCards(List<CardInfo> cards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (cards.isNotEmpty) ...cards.map((c) => PoliferieCard(c)).toList(),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<CardInfo> cards) {
    // Always present card
    final PoliferieCard _howToCard = PoliferieCard(
      CardInfo(
        "-1",
        image: 'assets/images/metodo.png',
        title: Strings.cardHowItWorks,
      ),
      orientation: CardOrientation.horizontal,
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => OnBoardingScreen(),
            ),
            (route) => false);
      },
      color: Styles.poliferieRed,
    );

    // Filter out cards
    final List<CardInfo> _searchCards = [];
    final List<CardInfo> _articleCards = [];
    for (CardInfo card in cards) {
      if (card.linksTo.startsWith(Configs.firebaseItemsCollection + '/')) {
        _searchCards.add(card);
      } else {
        _articleCards.add(card);
      }
    }

    List<PoliferieCard> _cards = _articleCards
        .map((card) =>
            PoliferieCard(card, orientation: CardOrientation.horizontal))
        .toList();
    _cards.insertAll(0, [_howToCard]);
    final double _bottomPadding = MediaQuery.of(context).padding.bottom +
        AppDimensions.bodyPadding.bottom;
    return ListView(
      padding: AppDimensions.bodyPadding.copyWith(bottom: _bottomPadding),
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildHeadline(Strings.homeHeadline),
        _buildSubHeadline(Strings.homeSubHeadline),
        _buildRowHeading(Strings.homeSearch),
        _buildRowCards(_searchCards),
        _buildRowHeading(Strings.homeDiscover),
        ..._cards,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CardBloc>(context).add(FetchCards());

    return BlocBuilder<CardBloc, CardState>(
      builder: (BuildContext context, CardState state) {
        if (state is FetchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        if (state is FetchStateSuccess) {
          return _buildBody(context, state.cards);
        }
        return Text('This widge should never be reached');
      },
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(),
      body: BlocProvider<CardBloc>(
        create: (context) => CardBloc(
            cardRepository: RepositoryProvider.of<CardRepository>(context)),
        child: HomeScreenBody(),
      ),
    );
  }
}
