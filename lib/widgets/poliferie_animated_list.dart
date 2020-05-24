import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

class PoliferieAnimatedList extends StatefulWidget {
  const PoliferieAnimatedList({Key key, this.items, this.singleHeight = 75.0})
      : super(key: key);

  final List<Card> items;
  final double singleHeight;

  @override
  _PoliferieAnimatedListState createState() =>
      new _PoliferieAnimatedListState();
}

// TODO(@amerlo): Change to reflect design
class _PoliferieAnimatedListState extends State<PoliferieAnimatedList> {
  // TODO(@amerlo): Single heigth should be in sync with card height
  int _length;
  double _height;
  IconData _icon;

  @override
  void initState() {
    _length = 1;
    _height = widget.singleHeight * _length;
    _icon = Icons.expand_more;
  }

  Widget _buildExpandable(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _height,
        child: Column(
          children: <Widget>[
            ...widget.items.getRange(0, _length).toList(),
          ],
        ),
        onEnd: () {
          setState(() {
            if (_height != widget.singleHeight) {
              _length = widget.items.length;
            }
          });
        },
      ),
      IconButton(
        icon: Icon(_icon),
        color: Styles.poliferieYellow,
        onPressed: () {
          setState(() {
            if (_length == 1) {
              _height = widget.singleHeight * widget.items.length;
              _icon = Icons.expand_less;
            } else {
              _length = 1;
              _height = widget.singleHeight;
              _icon = Icons.expand_more;
            }
          });
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _buildExpandable(context);
  }
}
