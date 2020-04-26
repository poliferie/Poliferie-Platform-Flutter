import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/dimensions.dart';

import 'package:Poliferie.io/screens/screens.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => new _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedScreenIndex = 0;

  // TODO(@amerlo): Is there a more elegant solution
  // to zip together screens and BottomNavigationBarItem?
  var pages = [
    HomeScreen(cardRepository: cardRepository),
    SearchScreen(searchRepository: searchRepository),
    CompareScreen(),
    ProfileScreen(userRepository: profileRepository),
  ];

  /// Build the [BottomNavigationBar] which handles the screens.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedScreenIndex],
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
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
              _selectedScreenIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0.0,
          unselectedFontSize: 0.0,
          backgroundColor: Styles.poliferieWhite,
          selectedItemColor: Styles.poliferieRed,
          unselectedItemColor: Styles.poliferieDarkGrey,
          currentIndex: _selectedScreenIndex
        ),
      ),
      /*
      body: Stack(
        children: <Widget>[
          pages[_selectedScreenIndex],
          Positioned(
            left: 0,
            bottom: 0,
            child: ,
          ),
        ],
      ),*/
    );
  }
}
