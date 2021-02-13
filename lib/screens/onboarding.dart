import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:equatable/equatable.dart';

import 'package:Poliferie.io/screens/base.dart';
import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/providers/local_provider.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';

// TODO(@amerlo): Consider to move this into a model, even if this will be the only screen
//                which makes use of it.
class OnBoardingPage extends Equatable {
  final String title;
  final String text;
  final Color color;
  final int index;
  final String imagePath;

  const OnBoardingPage(
      {this.index, this.title, this.text, this.color, this.imagePath});
  @override
  List<Object> get props => [title, index];
}

List<OnBoardingPage> _pages = [
  OnBoardingPage(
    index: 0,
    title: 'Benvenuto',
    text:
        'Poliferie.io è un App che mira a combattare le disuguaglianze di opportunità in ambito scolatico.',
    color: Styles.poliferieWhite,
    imagePath: 'assets/images/onboarding/home.png',
  ),
  OnBoardingPage(
    index: 1,
    title: 'Cerca',
    text:
        'Potrai cercare il percorso di formazione post-diploma fra tutti quelli offerti in Italia.',
    color: Styles.poliferieBlue,
    imagePath: 'assets/images/onboarding/search.png',
  ),
  OnBoardingPage(
    index: 2,
    title: 'Filtra',
    text: 'Seleziona solo quelli che più ti interessano.',
    color: Styles.poliferieGreen,
    imagePath: 'assets/images/onboarding/filter.png',
  ),
  OnBoardingPage(
    index: 3,
    title: 'Confronta',
    text: 'Confronta i percorsi per capire quello più adatto a te.',
    color: Styles.poliferiePink,
    imagePath: 'assets/images/onboarding/compare.png',
  ),
  OnBoardingPage(
    index: 4,
    title: 'Inizia',
    text:
        'Scopri il tuo futuro. Per ogni domanda contattaci su Instagram @poliferie!',
    color: Styles.poliferieWhite,
    imagePath: 'assets/images/onboarding/profile.png',
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

  Widget _buildFloatingActionButton(double width) {
    return Container(
      color: Styles.poliferieRed,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          left: width * 0.2,
          right: width * 0.2,
          top: 10,
        ),
        child: PoliferieFloatingButton(
          text: Strings.onboardingStartButton.toUpperCase(),
          isActive: true,
          activeColor: Styles.poliferieYellow,
          onPressed: () {
            setFinishedOnBoarding();
            pushToBaseScreen(context);
          },
        ),
      ),
    );
  }

  Widget _buildHeader(String title, String text, int index) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      padding: AppDimensions.bodyPadding,
      color: Styles.poliferieRed,
      height: MediaQuery.of(context).size.height * 0.33,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(title, style: Styles.headlineWhite),
                  if (index != 4)
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Styles.poliferieWhite,
                        size: 32,
                      ),
                      onPressed: () {
                        setFinishedOnBoarding();
                        pushToBaseScreen(context);
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
          if (index != 4) _buildCounter(index),
          if (index == 4) _buildFloatingActionButton(_width)
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
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath, Color color) {
    final double _imageHeight = MediaQuery.of(context).size.height * 0.8;
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
            bottom: -_imageHeight * 0.17,
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
  final LocalProvider localProvider = LocalProvider();
  return localProvider.save('onBoardingIsCompleted', true);
}

void pushToBaseScreen(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => BaseScreen()),
      (route) => false);
}
