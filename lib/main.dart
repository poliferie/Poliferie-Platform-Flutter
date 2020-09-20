import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/providers/providers.dart';
import 'package:Poliferie.io/repositories/filter_repository.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/screens/onboarding.dart';
import 'package:Poliferie.io/screens/base.dart';

class PoliferieApp extends StatefulWidget {
  _PoliferieAppState createState() => _PoliferieAppState();
}

class _PoliferieAppState extends State<PoliferieApp> {
  bool _initialized = false;
  bool _error = false;
  bool _showOnBoarding = true;

  static final Map<String, WidgetBuilder> routes = {
    '/home': (context) => BaseScreen(),
    '/onboarding': (context) => OnBoardingScreen(),
  };

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void checkOnboarding() async {
    bool onBoardingIsCompleted = await SharedPreferences.getInstance()
            .then((p) => p.getBool('onBoardingIsCompleted')) ??
        false;
    setState(() {
      _showOnBoarding = !onBoardingIsCompleted;
    });
  }

  @override
  void initState() {
    initializeFlutterFire();
    checkOnboarding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      print("Error during initialization of the app");
    }

    if (!_initialized) {
      print("Firebase has not been initialized yet...");
    }

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
          create: (context) => SearchRepository(
            apiProvider: apiProvider,
            localProvider: localProvider,
          ),
        ),
        RepositoryProvider<FilterRepository>(
          create: (context) => FilterRepository(apiProvider: apiProvider),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(apiProvider: apiProvider),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (context) =>
              FavoritesRepository(localProvider: localProvider),
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
          scaffoldBackgroundColor: Styles.poliferieWhite,
        ),
        routes: routes,
        initialRoute: _showOnBoarding ? '/onboarding' : '/home',
        builder: (context, child) => child,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(PoliferieApp());
}
