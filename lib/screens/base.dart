import 'package:flutter/material.dart';

import 'package:Poliferie.io/screens/screens.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/dimensions.dart';

class BaseScreen extends StatefulWidget {
  @override
  BaseScreenState createState() => new BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  final int _numberOfScreens = 4;

  /// Screens
  List<Widget> screens;

  /// Current screen
  int _selectedIndex = 0;

  /// Push [screenIndex] screen
  void goToScreen(int screenIndex) {
    if (screenIndex != _selectedIndex && screenIndex < _numberOfScreens) {
      setState(() {
        _selectedIndex = screenIndex;
      });
    }
  }

  // By default go back to home screen on device back button
  Future<bool> _onWillPop() {
    if (_selectedIndex == 0) {
      return Future.value(true);
    }
    setState(() {
      _selectedIndex = 0;
    });
    return Future.value(false);
  }

  BorderRadius navigationBarRadius = BorderRadius.only(
    topRight: Radius.circular(AppDimensions.bottomNavigationBarBorderRadius),
    topLeft: Radius.circular(AppDimensions.bottomNavigationBarBorderRadius),
  );

  @override
  void initState() {
    super.initState();

    screens = [
      HomeScreen(),
      SearchScreen(),
      CompareScreen(),
      ProfileScreen(),
    ];
  }

  BottomNavigationBarItem _buildNavItem(IconData icon) {
    return BottomNavigationBarItem(
      title: Text(""),
      icon: Icon(
        icon,
        size: AppDimensions.bottomNavigationBarIconSize,
      ),
    );
  }

  /// Build the [BottomNavigationBar] which handles the screens.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
        extendBody: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: navigationBarRadius,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: navigationBarRadius,
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                _buildNavItem(AppIcons.home),
                _buildNavItem(AppIcons.search),
                _buildNavItem(AppIcons.compare),
                _buildNavItem(AppIcons.profile),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 0.0,
              unselectedFontSize: 0.0,
              backgroundColor: Styles.poliferieWhite,
              selectedItemColor: Styles.poliferieRed,
              unselectedItemColor: Styles.poliferieDarkGrey,
              currentIndex: _selectedIndex,
            ),
          ),
        ),
      ),
    );
  }
}
