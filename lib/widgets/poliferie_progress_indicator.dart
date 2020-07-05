import 'package:flutter/material.dart';

class PoliferieProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Hack to center indicator in Container
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
