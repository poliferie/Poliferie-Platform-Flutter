/// TODO(@amerlo): Add LICENSE
///
/// TODO(@amerlo):
///   - Include in Styles padding for all screen
///   - Parametric size and padding values based on device height
///   - Apply BLoC logic to all data, create "_mock.dart" data provider
///   - Include website for university and bottom to check within the app

import 'package:flutter/material.dart';
import 'package:poliferie_platform_flutter/screens/users.dart';

import 'package:poliferie_platform_flutter/styles.dart';
import 'screens.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => new _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedPageIndex = 0;

  // TODO(@amerlo): Leave out test screens
  var pages = [
    //TestScreen(),
    //FeedScreen(),
    SearchScreen(),
    DiscoverScreen(),
    //TestUserScreen(usersRepository: usersRepository),
    ProfileScreen(userRepository: profileRepository),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(Icons.book),
            ),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(Icons.account_circle),
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
