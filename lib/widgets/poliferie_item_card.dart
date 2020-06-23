import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/models/item.dart';

import 'package:Poliferie.io/screens/item.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';

class PoliferieItemCard extends StatelessWidget {
  final ItemModel item;
  final bool isFavorite;
  final Function onSetFavorite;

  const PoliferieItemCard(this.item,
      {this.isFavorite: false, this.onSetFavorite});

  Widget _buildHeader(ItemModel item) {
    String subHeader;
    if (item.provider != null) {
      subHeader = item.provider + ', ' + item.city;
    } else if (item.region != null) {
      subHeader = item.region + ', ' + item.city;
    } else {
      subHeader = item.city;
    }
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              item.longName,
              style: Styles.resultHeadline,
            ),
            Text(subHeader, style: Styles.resultSubHeadline),
          ],
        ),
      ),
    );
  }

  Widget _buildFavorite() {
    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Styles.poliferieRed, size: 32),
      onPressed: onSetFavorite,
    );
  }

  Widget _buildInfo(ItemModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PoliferieIconBox(
          item.providerLogo,
          iconSize: 40,
        ),
        _buildHeader(item),
        _buildFavorite(),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Divider(
        color: Styles.poliferieRed,
        height: 10,
        thickness: 2,
      ),
    );
  }

  Widget _buildStats(ItemModel item) {
    // TODO(@amerlo): Fix infoMap for University
    // Build stats according to item type
    Map<String, dynamic> infoMap;
    if (item.type == ItemType.course) {
      infoMap = {
        item.duration.toString(): Icons.looks_one,
        item.language: Icons.language,
        item.students.toString(): Icons.people,
      };
    } else if (item.type == ItemType.university) {
      infoMap = {
        item.owner: Icons.lock,
        item.region: Icons.location_searching,
        item.students.toString(): Icons.people,
      };
    }
    // TODO(@amerlo): How to include placeholder for new stats
    return Row(
      children: infoMap.keys.map((String text) {
        return Expanded(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 6.0),
                child: PoliferieIconBox(
                  infoMap[text],
                  iconColor: Styles.poliferieRed,
                  iconSize: 18.0,
                ),
              ),
              Text(
                text,
                style: Styles.courseInfoStats,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // TODO(@amerlo): We could add a longTap to show a bottom screen with a preview for that course
  Widget _buildCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemScreen(item.id),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
        child: Column(
          children: <Widget>[
            _buildInfo(item),
            _buildDivider(),
            _buildStats(item),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }
}
