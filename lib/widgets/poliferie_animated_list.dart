import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

class PoliferieAnimatedList extends StatefulWidget {
  const PoliferieAnimatedList({Key key, this.title, this.items})
      : super(key: key);

  final String title;
  final List<Card> items;

  @override
  _PoliferieAnimatedListState createState() =>
      new _PoliferieAnimatedListState();
}

// TODO(@amerlo): Change to reflect design
class _PoliferieAnimatedListState extends State<PoliferieAnimatedList> {
  Widget _buildExpandable(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: Styles.tabHeading,
        ),
        children: <Widget>[...widget.items],
        trailing: Icon(Icons.expand_more, color: Styles.poliferieYellow),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildExpandable(context);
  }
}
