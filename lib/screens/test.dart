import 'package:flutter/material.dart';

import 'package:poliferie_platform_flutter/widgets/poliferie_app_bar.dart';
import 'package:poliferie_platform_flutter/styles.dart';
import 'package:poliferie_platform_flutter/strings.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(icon: Icons.settings, onTap: () {}),
      body: Text("Hello world"),
    );
  }
}
