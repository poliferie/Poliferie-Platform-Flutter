import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/dimensions.dart';

import 'package:delayed_display/delayed_display.dart';

class PoliferieAnimatedList extends StatefulWidget {
  const PoliferieAnimatedList({
    Key key,
    this.items,
    this.singleHeight = AppDimensions.itemCardHeight,
    this.verticalPadding = AppDimensions.itemCardPaddingVertical,
    this.itemAnimationMilliseconds = 50,
  }) : super(key: key);

  final List<Widget> items;
  final double singleHeight;
  final double verticalPadding;
  final int itemAnimationMilliseconds;

  @override
  _PoliferieAnimatedListState createState() =>
      new _PoliferieAnimatedListState();
}

// TODO(@amerlo): Change to reflect design
class _PoliferieAnimatedListState extends State<PoliferieAnimatedList> {
  // TODO(@amerlo): Single heigth should be in sync with card height,
  //                and height expansion should scale with it.
  bool _isExpanded;
  IconData _icon;
  int _visibleElements;
  double _height;

  @override
  void initState() {
    _isExpanded = false;
    _icon = Icons.expand_more;
    _visibleElements = 1;
    _height = _computeHeight(_visibleElements);
  }

  void toggle() {
    setState(
      () {
        if (!_isExpanded) {
          // closed -> open
          _isExpanded = true;
          _icon = Icons.expand_less;
          _visibleElements = widget.items.length;
          _height = _computeHeight(_visibleElements);
        } else {
          // open -> closed
          _isExpanded = false;
          _icon = Icons.expand_more;
          // _visibleElements = 1; // will be done at the end
          _height = _computeHeight(1);
        }
      },
    );
  }

  double _computeHeight(int elements) {
    return (widget.singleHeight + 0.5) * elements + // 0.5 is for the border
        widget.verticalPadding * (elements + 1);
  }

  Widget _buildExpandable(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
          milliseconds: (widget.items.length - 1) *
              widget
                  .itemAnimationMilliseconds), // x ms for each element to show/hide
      curve: Curves.fastLinearToSlowEaseIn,
      padding: EdgeInsets.symmetric(
          horizontal: 10.0, vertical: widget.verticalPadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 1)),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.iconBoxBorderRadius),
      ),
      // Add height due to padding
      height: _height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < _visibleElements; i++)
            DelayedDisplay(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.verticalPadding / 2),
                  decoration: (i > 0)
                      ? BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Styles.poliferieLightGrey,
                                  width: 0.5)))
                      : null,
                  child: widget.items[i]),
              fadeIn: (!_isExpanded && i > 0) ? false : true,
              fadingDuration: Duration(
                  milliseconds:
                      _isExpanded ? widget.itemAnimationMilliseconds : 25),
              delay: Duration(
                  milliseconds: _isExpanded
                      ? (i - 1) * widget.itemAnimationMilliseconds
                      : 0),
            )
        ],
      ),
      onEnd: () {
        setState(() {
          if (!_isExpanded) {
            // closed
            _visibleElements = 1;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      _buildExpandable(context),
      Opacity(
        // If one element, hide the arrow but occupy the space
        child: IconButton(
          icon: Icon(_icon),
          color: Styles.poliferieYellow,
          onPressed: (widget.items.length > 1) ? toggle : () {},
        ),
        opacity: (widget.items.length > 1) ? 1.0 : 0.0,
      )
    ]);
  }
}
