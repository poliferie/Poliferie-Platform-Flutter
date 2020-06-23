import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/screens/onboarding.dart';
import 'package:Poliferie.io/screens/base.dart';

import 'package:Poliferie.io/providers/providers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Poliferie.io/repositories/repositories.dart';

class PoliferieApp extends StatelessWidget {
  final bool showOnBoarding;

  const PoliferieApp({Key key, @required this.showOnBoarding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final ApiProvider apiProvider = ApiProvider(mockup: true);
    final LocalProvider localProvider = LocalProvider();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CardRepository>(
          create: (context) => CardRepository(apiProvider: apiProvider),
        ),
        RepositoryProvider<ArticleRepository>(
          create: (context) => ArticleRepository(apiProvider: apiProvider),
        ),
        RepositoryProvider<ItemRepository>(
          create: (context) => ItemRepository(apiProvider: apiProvider),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepository(apiProvider: apiProvider, localProvider: localProvider),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(apiProvider: apiProvider),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (context) => FavoritesRepository(localProvider: localProvider),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appTitle,
        theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Styles.poliferieRed,
            fontFamily: 'Lato',
            backgroundColor: Styles.poliferieWhite,
            scaffoldBackgroundColor: Styles.poliferieWhite),
        home: showOnBoarding ? OnBoardingScreen() : BaseScreen(),
      ),
    );
  }
}

Future<bool> isOnBoardingCompleted() async {
  return (await SharedPreferences.getInstance())
          .getBool('onBoardingIsComplted') ??
      false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool showOnBoarding = !(await isOnBoardingCompleted());
  // Comment line below for deploying
  showOnBoarding = false;

  return runApp(PoliferieApp(showOnBoarding: showOnBoarding));
}
