import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/bloc/card.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/models/card.dart';
import 'package:Poliferie.io/models/article.dart';
import 'package:Poliferie.io/screens/base.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';

import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_card.dart';
import 'package:Poliferie.io/widgets/poliferie_article.dart';

// TODO(@amerlo): Where the repository have to be declared?
final CardRepository cardRepository = CardRepository(
  cardClient: CardClient(useLocalJson: true),
);

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class HomeScreenBody extends StatelessWidget {
  final _coursesCard = CardInfo(42,
      image: 'assets/images/squadra.png', title: Strings.cardCourses);
  final _universitiesCard = CardInfo(43,
      image: 'assets/images/squadra.png', title: Strings.cardUniversities);

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

  // TODO(@amerlo): How to access HomeScreen and change selected screen?
  Widget _buildRowCards() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PoliferieCard(
            _coursesCard,
            onTap: () {},
          ),
          PoliferieCard(
            _universitiesCard,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<CardInfo> cards) {
    final _cards = cards
        .asMap()
        .map((index, card) {
          return MapEntry(
            index,
            PoliferieCard(
              card,
              onTap: _fetchPoliferieArticle(context, card: card),
            ),
          );
        })
        .values
        .toList();
    final double bottomPadding = MediaQuery.of(context).padding.bottom +
        AppDimensions.bodyPadding.bottom;
    return ListView(
      padding: AppDimensions.bodyPadding.copyWith(bottom: bottomPadding),
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
        create: (context) => CardBloc(cardRepository: cardRepository),
        child: HomeScreenBody(),
      ),
    );
  }
}

// TODO(@amerlo): To remove with a proper BlocProvider
// TODO(@amerlo): Markdown visualization has to be fixed
void Function() _fetchPoliferieArticle(BuildContext context, {CardInfo card}) {
  return PoliferieArticle(
    article: Article(
        id: card.id,
        title: card.title,
        subtitle: card.subtitle,
        bodyMarkdownSource: card.text),
  ).bottomSheetCaller(context);
}
