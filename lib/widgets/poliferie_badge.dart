import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

class PoliferieBadge extends StatefulWidget {
  const PoliferieBadge({
    Key key,
    this.imagePath,
    this.name,
    this.description,
  }) : super(key: key);

  final String imagePath;
  final String name;
  final String description;

  @override
  _PoliferieBadgeState createState() => new _PoliferieBadgeState();
}

class _PoliferieBadgeState extends State<PoliferieBadge> {
  bool _isActive = false;

  Widget _badgeInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(60.0, 12.0, 16.0, 0.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              widget.name,
              style: Styles.badgeHeading,
            ),
          ),
          Text(
            widget.description,
            style: Styles.badgeDescription,
          ),
          FlatButton.icon(
            icon: Icon(
              Icons.center_focus_strong,
              color: Styles.poliferieWhite,
            ),
            onPressed: () {},
            label: Text('8/9'),
            padding: EdgeInsets.all(0.0),
            textColor: Styles.poliferieWhite,
          ),
        ],
      ),
    );
  }

  Widget _badgeCard() {
    return Container(
      child: _badgeInfo(),
      height: 124.0,
      margin: EdgeInsets.only(left: 46.0),
      decoration: BoxDecoration(
        color: Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );
  }

  Widget _badgeThumbnail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: Image(
        image: AssetImage(widget.imagePath),
        height: 92.0,
        width: 92.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120.0,
        margin: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: <Widget>[
            _badgeCard(),
            _badgeThumbnail(),
          ],
        ));
  }
}
