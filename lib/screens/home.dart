import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/bloc/card.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/models/card.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';

import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_card.dart';

final CardRepository cardRepository = CardRepository(
  cardClient: CardClient(useLocalJson: true),
);

class HomeScreen extends StatefulWidget {
  final CardRepository cardRepository;

  HomeScreen({Key key, this.cardRepository}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class HomeScreenBody extends StatelessWidget {
  final _coursesCard = CardInfo(
      id: 42,
      imagePath: 'assets/images/squadra.png',
      shortName: Strings.cardCourses);
  final _universitiesCard = CardInfo(
      id: 43,
      imagePath: 'assets/images/squadra.png',
      shortName: Strings.cardUniversities);

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

  Widget _buildRowCards() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PoliferieCard(_coursesCard),
        PoliferieCard(_universitiesCard),
      ],
    ));
  }

  Widget _buildBody(BuildContext context, List<CardInfo> cards) {
    final _cards = cards.map((card) => PoliferieCard(card));
    return ListView(
      padding: AppDimensions.bodyPadding,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildHeadline(Strings.homeHeadline),
        _buildSubHeadline(Strings.homeSubHeadline),
        _buildRowHeading(Strings.homeSearch),
        _buildRowCards(),
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
          return CircularProgressIndicator();
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
        create: (context) => CardBloc(cardRepository: widget.cardRepository),
        child: HomeScreenBody(),
      ),
    );
  }
}
