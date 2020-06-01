import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/dimensions.dart';

class PoliferieAnimatedList extends StatefulWidget {
  const PoliferieAnimatedList(
      {Key key,
      this.items,
      this.singleHeight = AppDimensions.itemCardHeight * 1.15})
      : super(key: key);

  final List<Card> items;
  final double singleHeight;

  @override
  _PoliferieAnimatedListState createState() =>
      new _PoliferieAnimatedListState();
}

// TODO(@amerlo): Change to reflect design
class _PoliferieAnimatedListState extends State<PoliferieAnimatedList> {
  // TODO(@amerlo): Single heigth should be in sync with card height,
  //                and height expansion should scale with it.
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
        padding: EdgeInsets.symmetric(
            horizontal: 10.0, vertical: AppDimensions.itemCardPaddingVertical),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 1)),
          ],
          borderRadius:
              BorderRadius.circular(AppDimensions.iconBoxBorderRadius),
        ),
        // Add height due to padding
        height: _height + 2 * AppDimensions.itemCardPaddingVertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
