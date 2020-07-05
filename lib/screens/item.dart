import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/item.dart';
import 'package:Poliferie.io/models/models.dart';

import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';
import 'package:Poliferie.io/widgets/poliferie_animated_list.dart';

class ItemScreen extends StatefulWidget {
  /// This [id] is the requested id from the frontend
  final int id;

  const ItemScreen(this.id, {Key key}) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class ItemScreenBody extends StatefulWidget {
  // TODO(@amerlo): Could we avoid this?
  final int id;
  final FavoritesRepository favoritesRepository;

  ItemScreenBody(this.id, {@required this.favoritesRepository});

  @override
  _ItemScreenBodyState createState() => _ItemScreenBodyState();
}

class _ItemScreenBodyState extends State<ItemScreenBody> {
  bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _updateIsFavorite();
  }

  void _updateIsFavorite({bool toggle}) async {
    bool isFavorite;
    if (toggle != null && toggle) {
      widget.favoritesRepository.toggle(widget.id);
      isFavorite = !_isFavorite;
    } else {
      isFavorite = await widget.favoritesRepository.contains(widget.id);
    }
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 20.0,
      left: -10.0,
      child: MaterialButton(
          color: Styles.poliferieWhite,
          shape: CircleBorder(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Styles.poliferieLightGrey,
          ),
          onPressed: () {
            {
              Navigator.pop(context);
            }
          }),
    );
  }

  Widget _buildImage(ItemModel item) {
    return Image(
      image: AssetImage(item.providerImage),
    );
  }

  Widget _buildSpacer() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.screenContainerBoxRadius),
              topRight:
                  Radius.circular(AppDimensions.screenContainerBoxRadius)),
          color: Styles.poliferieWhite),
      width: double.infinity,
    );
  }

  Widget _buildFavorite() {
    return Positioned(
      bottom: 20.0,
      right: 10.0,
      child: MaterialButton(
        color: Styles.poliferieWhite,
        shape: CircleBorder(),
        padding: EdgeInsets.all(6.0),
        child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Styles.poliferieRed, size: 40),
        onPressed: () => _updateIsFavorite(toggle: true),
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context, ItemModel item) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildImage(item),
        _buildBackButton(context),
        _buildSpacer(),
        _buildFavorite()
      ],
    );
  }

  Widget _buildInfo(ItemModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.longName.toUpperCase(),
                style: Styles.courseHeadline,
                maxLines: 2,
              ),
              Text(
                  item.provider != null
                      ? item.provider + ', ' + item.city
                      : item.city,
                  style: Styles.courseSubHeadline),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.location_on, color: Styles.poliferieRed),
                    Text(item.region, style: Styles.courseLocation)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats(ItemModel item) {
    // TODO(@amerlo): Move this data structure to ItemModel
    // Include this in a function like ItemModel.buildInfoMap()
    Map<String, dynamic> infoMap;
    if (item.type == ItemType.course) {
      infoMap = {
        item.duration.toString(): Icons.looks_one,
        item.language: Icons.language,
        item.requirements: Icons.card_membership,
        item.owner: Icons.lock,
        item.access: Icons.check_circle,
        item.education: Icons.recent_actors,
      };
    } else if (item.type == ItemType.university) {
      infoMap = {item.owner: Icons.lock, item.region: Icons.location_searching};
    } else {
      return Container();
    }
    // TODO(@amerlo): How to scale height dynamically?
    return Container(
      height: 60.0 * (infoMap.length / 3).ceil(),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2,
        children: infoMap.keys.map((String text) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: PoliferieIconBox(
                    infoMap[text],
                    iconColor: Styles.poliferieRed,
                    iconSize: 18.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: Styles.courseInfoStats,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDescription(ItemModel item) {
    return Padding(
      padding: AppDimensions.betweenTabs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(Strings.courseDescription, style: Styles.tabHeading),
          Text(item.shortDescription, style: Styles.tabDescription),
        ],
      ),
    );
  }

  Widget _buildList(String title, List<Card> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Text(title, style: Styles.tabHeading),
          padding: EdgeInsets.only(bottom: 10.0),
        ),
        PoliferieAnimatedList(items: items),
      ],
    );
  }

  Card _buildCard(ItemStat stat) {
    return Card(
      elevation: 0.0,
      child: Container(
        height: AppDimensions.itemCardHeight,
        child: ListTile(
          title: Text(stat.name, style: Styles.statsTitle),
          subtitle: Text(stat.desc, style: Styles.statsDescription),
          trailing: buildCardTraling(stat),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        ),
      ),
    );
  }

  Widget _buildCourseBody(BuildContext context, ItemModel item) {
    // TODO(@amerlo): List order matters, decide how to do it.
    List<Widget> itemStats = List<Widget>();
    for (String listName in item.stats.keys) {
      List<Card> cards =
          item.stats[listName].map((e) => _buildCard(e)).toList();
      itemStats.add(_buildList(listName, cards));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.bodyPaddingLeft),
      width: double.infinity,
      color: Styles.poliferieWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildInfo(item),
          _buildStats(item),
          _buildDescription(item),
          ...itemStats,
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemModel item) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildCourseHeader(context, item),
        _buildCourseBody(context, item),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ItemBloc>(context).add(FetchItem(widget.id));

    return BlocBuilder<ItemBloc, ItemState>(
      builder: (BuildContext context, ItemState state) {
        if (state is FetchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        if (state is FetchStateSuccess) {
          return _buildBody(context, state.item);
        }
        return Text('This widge should never be reached');
      },
    );
  }
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ItemBloc>(
        create: (context) => ItemBloc(
            itemRepository: RepositoryProvider.of<ItemRepository>(context)),
        child: ItemScreenBody(widget.id,
            favoritesRepository:
                RepositoryProvider.of<FavoritesRepository>(context)),
      ),
    );
  }
}

/// Build [ItemStat] value widget based in value unit
Widget buildCardTraling(ItemStat stat) {
  if (stat.unit == "%") {
    return CircularPercentIndicator(
      radius: 50.0,
      lineWidth: 3.0,
      percent: stat.value / 100,
      center: Text(
        stat.value.toString(),
        style: Styles.statsValue,
      ),
      progressColor: Color.lerp(Colors.red, Colors.green, stat.value / 100),
    );
  } else if (stat.unit == "€") {
    return Text(stat.value.toStringAsFixed(0) + ' ' + stat.unit,
        style: Styles.statsValue);
  } else {
    return Text(stat.value.toString() + ' ' + stat.unit,
        style: Styles.statsValue);
  }
}
