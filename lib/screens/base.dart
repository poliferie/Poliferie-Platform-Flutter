import 'package:flutter/material.dart';

import 'package:poliferie_platform_flutter/styles.dart';
import 'package:poliferie_platform_flutter/icons.dart';
import 'package:poliferie_platform_flutter/screens/screens.dart';

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
    DiscoverScreen(),
    SearchScreen(),
    CompareScreen(),
    //ProfileScreen(userRepository: profileRepository),
    //TestUserScreen(usersRepository: usersRepository),
    //TestScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(AppIcons.home),
            ),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(AppIcons.search),
            ),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(AppIcons.compare),
            ),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(AppIcons.profile),
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
          selectedItemColor: Styles.poliferieRedAccent,
          unselectedItemColor: Styles.poliferieDarkGrey,
          currentIndex: _selectedPageIndex),
    );
  }
}
