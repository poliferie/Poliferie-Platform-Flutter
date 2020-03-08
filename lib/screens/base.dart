import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/screens/screens.dart';
import 'package:Poliferie.io/dimensions.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => new _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedPageIndex = 0;

  // TODO(@amerlo): Remove TestScreen() and TestUserScreen()
  // TODO(@amerlo): How to zip together screens and
  // BottomNavigationBarItem
  var pages = [
    HomeScreen(cardRepository: cardRepository),
    SearchScreen(),
    CompareScreen(),
    ProfileScreen(userRepository: profileRepository),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          pages[_selectedPageIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      title: Text(""),
                      icon: Icon(
                        AppIcons.home,
                        size: AppDimensions.bottomNavigationBarIconSize,
                      ),
                    ),
                    BottomNavigationBarItem(
                      title: Text(""),
                      icon: Icon(
                        AppIcons.search,
                        size: AppDimensions.bottomNavigationBarIconSize,
                      ),
                    ),
                    BottomNavigationBarItem(
                      title: Text(""),
                      icon: Icon(
                        AppIcons.compare,
                        size: AppDimensions.bottomNavigationBarIconSize,
                      ),
                    ),
                    BottomNavigationBarItem(
                      title: Text(""),
                      icon: Icon(
                        AppIcons.profile,
                        size: AppDimensions.bottomNavigationBarIconSize,
                      ),
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      _selectedPageIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 0.0,
                  unselectedFontSize: 0.0,
                  backgroundColor: Styles.poliferieWhite,
                  selectedItemColor: Styles.poliferieRedAccent,
                  unselectedItemColor: Styles.poliferieDarkGrey,
                  currentIndex: _selectedPageIndex),
            ),
          ),
        ],
      ),
    );
  }
}
