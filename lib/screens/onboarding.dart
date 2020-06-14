import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';

// TODO(@amerlo): Maybe move from here
class OnBoardingPage extends Equatable {
  final String title;
  final String text;
  final Color color;
  final int index;
  final String imagePath;

  const OnBoardingPage(
      {this.index, this.title, this.text, this.color, this.imagePath});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

List<OnBoardingPage> _pages = [
  OnBoardingPage(
    index: 0,
    title: 'Benvenuto',
    text:
        'Poliferie.io è un App che mira a combattare le disuagualinze di opportunità in ambito scolatico',
    color: Styles.poliferieWhite,
    imagePath: 'assets/images/onboarding_0.png',
  ),
  OnBoardingPage(
    index: 1,
    title: 'Cerca',
    text: 'Lorem ipsum',
    color: Styles.poliferieBlue,
    imagePath: 'assets/images/onboarding_0.png',
  )
];

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildHeader(String title, text) {
    return Container(
      padding: AppDimensions.bodyPadding,
      color: Styles.poliferieRed,
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Styles.headlineWhite),
          Text(
            text,
            style: Styles.subHeadlineWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(int index) {
    return Container(
        color: Styles.poliferieRed,
        width: double.maxFinite,
        child: Center(
            child: DotsIndicator(
          dotsCount: 5,
          position: index.toDouble(),
          decorator: DotsDecorator(
            color: Styles.poliferieLightGrey,
            activeColor: Styles.poliferieWhite,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        )));
  }

  Widget _buildImage(String imagePath, Color color) {
    return Expanded(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(color: color),
          // TODO(@amerlo): Fix positioned here!
          Positioned(
            top: 0.0,
            right: 100.0,
            child: Container(height: 100, color: Styles.poliferieRed),
          ),
          Image(
            // TODO(@amerlo): Fix height
            height: 400,
            image: AssetImage(imagePath),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnBoardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildHeader(page.title, page.text),
        _buildCounter(page.index),
        _buildImage(page.imagePath, page.color),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      height: double.maxFinite,
      child: PageView(
        controller: _controller,
        children: <Widget>[
          ..._pages.map((p) => _buildPage(p)).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
}

Future<bool> setFinishedOnBoarding() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool('onBoardingIsCompleted', true);
}
