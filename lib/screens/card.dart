import 'package:flutter/material.dart';

import 'package:Poliferie.io/widgets/poliferie_tile.dart';
import 'package:Poliferie.io/styles.dart';

class PageScreen extends StatefulWidget {
  final PoliferieTile card;
  PageScreen({this.card, Key key}) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  /// TODO(@amerlo): Move this to BLoC
  bool _isFavorite = false;
  static const _padding = 20.0;

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Styles.poliferieRedAccent),
      title: Text('Card'.toUpperCase(), style: Styles.searchTabTitle),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          color: Styles.poliferieRedAccent,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.card.head,
                  textAlign: TextAlign.left,
                  style: Styles.cardHead,
                ),
                Text(
                  widget.card.leading,
                  textAlign: TextAlign.left,
                  style: Styles.cardLeading,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              // TODO(@amerlo): Update color based on state
              icon: Icon(
                Icons.bookmark_border,
                color: Styles.poliferieDarkGrey,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 280,
      child: Image.asset(
        widget.card.imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        widget.card.body,
        style: Styles.cardDescription,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      thickness: 1.0,
      height: 20.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: Column(
          children: <Widget>[
            _buildImage(context),
            _buildHeading(context),
            _buildDivider(context),
            _buildText(context),
          ],
        ),
      ),
    );
  }
}
