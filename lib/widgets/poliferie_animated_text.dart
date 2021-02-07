import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/dimensions.dart';

class PoliferieAnimatedText extends StatefulWidget {
  PoliferieAnimatedText({
    Key key,
    @required this.text,
    this.previewText,
    this.previewLength = 200,
    this.animationMilliseconds = 250,
    this.verticalPadding = AppDimensions.itemCardPaddingVertical,
  }) : super(key: key) {
    this._moreToShow = (previewText != null || text.length > previewLength);
  }

  final String text;
  final String previewText;
  final int previewLength;
  final int animationMilliseconds;
  final double verticalPadding;
  bool _moreToShow;

  @override
  _PoliferieAnimatedTextState createState() =>
      new _PoliferieAnimatedTextState();
}

// TODO(@amerlo): Change to reflect design
class _PoliferieAnimatedTextState extends State<PoliferieAnimatedText>
    with SingleTickerProviderStateMixin {
  // TODO(@amerlo): Single heigth should be in sync with card height,
  //                and height expansion should scale with it.
  bool _isExpanded;
  IconData _icon;
  Widget _textElement;

  @override
  void initState() {
    _isExpanded = false;
    _icon = Icons.expand_more;
    _textElement = _previewText();
  }

  void toggle() {
    setState(
      () {
        if (!_isExpanded) {
          // closed -> open
          _isExpanded = true;
          _icon = Icons.expand_less;
          _textElement = _longText();
        } else {
          // open -> closed
          _isExpanded = false;
          _icon = Icons.expand_more;
          _textElement = _previewText();
        }
      },
    );
  }

  Widget _previewText() {
    return Text(
      widget.previewText ??
          widget.text.substring(
                  0,
                  (widget.previewLength > widget.text.length)
                      ? widget.text.length
                      : widget.previewLength) +
              '...',
      softWrap: true,
      style: Styles.cardSubHeading,
      key: UniqueKey(),
    );
  }

  Widget _longText() {
    return Text(
      widget.text,
      softWrap: true,
      style: Styles.cardSubHeading, //tabDescription,
      key: UniqueKey(),
    );
  }

  Widget _buildExpandable(BuildContext context) {
    return Container(
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
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: widget.animationMilliseconds),
        curve: Curves.fastOutSlowIn,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: widget.animationMilliseconds),
          switchInCurve: Curves.easeInOut,
          //switchOutCurve: Curves.fastLinearToSlowEaseIn,
          reverseDuration: Duration(milliseconds: 1),
          child: _textElement,
        ),
      ),
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
          onPressed: widget._moreToShow ? toggle : () {},
        ),
        opacity: widget._moreToShow ? 1.0 : 0.0,
      )
    ]);
  }
}
