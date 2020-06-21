import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/screens/base.dart';
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
        'Poliferie.io è un App che mira a combattare le disuagualinze di opportunità in ambito scolatico.',
    color: Styles.poliferieWhite,
    imagePath: 'assets/images/onboarding/welcome.png',
  ),
  OnBoardingPage(
    index: 1,
    title: 'Cerca',
    text: 'Lorem ipsum',
    color: Styles.poliferieBlue,
    imagePath: 'assets/images/onboarding/search.png',
  ),
  OnBoardingPage(
    index: 2,
    title: 'Filtra',
    text: 'Lorem ipsum',
    color: Styles.poliferieBlue,
    imagePath: 'assets/images/onboarding/filter.png',
  ),
  OnBoardingPage(
    index: 3,
    title: 'Comfronta',
    text: 'Lorem ipsum',
    color: Styles.poliferieBlue,
    imagePath: 'assets/images/onboarding/compare.png',
  ),
  OnBoardingPage(
    index: 4,
    title: 'Inizia',
    text: 'Lorem ipsum',
    color: Styles.poliferieBlue,
    imagePath: 'assets/images/onboarding/ready.png',
  )
];

class FunctionClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(size.width / 2, 0, 0, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

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

  Widget _buildHeader(String title, String text, int index) {
    return Container(
      padding: AppDimensions.bodyPadding,
      color: Styles.poliferieRed,
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: Styles.headlineWhite),
              // TODO(@amerlo): This check could be moved up in the tree
              if (index != 4)
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Styles.poliferieWhite,
                    size: 32,
                  ),
                  onPressed: () {
                    setFinishedOnBoarding();
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BaseScreen()),
                            (route) => false);
                  },
                ),
            ],
          ),
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
    final double _imageHeight = MediaQuery.of(context).size.height * 0.95;
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(color: color),
          ClipPath(
            clipper: FunctionClipper(),
            child: Container(
              color: Styles.poliferieRed,
              height: _imageHeight * 0.2,
            ),
          ),
          Positioned(
            bottom: -_imageHeight * 0.2,
            child: Image(
              height: _imageHeight,
              image: AssetImage(imagePath),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnBoardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildHeader(page.title, page.text, page.index),
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
