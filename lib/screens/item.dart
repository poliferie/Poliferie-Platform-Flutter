import 'package:Poliferie.io/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/widgets/poliferie_animated_list.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/item.dart';
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';

// TODO(@amerlo): Where the repositories have to be declared?
final ItemRepository itemRepository =
    ItemRepository(itemClient: ItemClient(useLocalJson: true));

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

  ItemScreenBody(this.id);

  @override
  _ItemScreenBodyState createState() => _ItemScreenBodyState();
}

class _ItemScreenBodyState extends State<ItemScreenBody> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _setFavoriteItems();
  }

  void _setFavoriteItems() async {
    final List<dynamic> storedFavorites = await getPersistenceList('favorites');
    setState(() {
      _isFavorite = storedFavorites.contains(widget.id);
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

  Widget _buildCourseHeader(BuildContext context, ItemModel item) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        _buildImage(item),
        _buildBackButton(context),
      ],
    );
  }

// TODO(@amerlo): This needs to be moved up in the stack
  Widget _buildFavorite() {
    return MaterialButton(
      color: Styles.poliferieWhite,
      shape: CircleBorder(),
      padding: EdgeInsets.all(6.0),
      child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Styles.poliferieRed, size: 40),
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
          if (_isFavorite) {
            addToPersistenceList('favorites', widget.id);
          } else {
            removeFromPersistenceList('favorites', widget.id);
          }
        });
      },
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
        _buildFavorite()
      ],
    );
  }

  Widget _buildStats(ItemModel item) {
    // If item does not have stats, do not build it
    if (item.type != "course" && item.type != "university") {
      return Container();
    }
    // Build stats according to item type
    Map<String, dynamic> infoMap;
    if (item.type == "course") {
      infoMap = {
        item.duration.toString(): Icons.looks_one,
        item.language: Icons.language,
        item.requirements: Icons.card_membership,
        item.owner: Icons.lock,
        item.access: Icons.check_circle,
        item.education: Icons.recent_actors,
      };
    } else if (item.type == "university") {
      infoMap = {item.owner: Icons.lock, item.region: Icons.location_searching};
    }
    // TODO(@amerlo): How to scale height dynamically?
    return Container(
      height: 60.0 * (infoMap.length / 3).ceil(),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0.0),
        crossAxisCount: 3,
        childAspectRatio: 2,
        children: infoMap.keys.map((String text) {
          return Row(
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
              Text(
                text,
                style: Styles.courseInfoStats,
              ),
            ],
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
    var trailing;
    if (stat.type == "euro") {
      trailing =
          Text(stat.value.toStringAsFixed(0) + '€', style: Styles.statsValue);
    } else if (stat.type == "circle") {
      trailing = CircularPercentIndicator(
        radius: 50.0,
        lineWidth: 3.0,
        percent: stat.value / 100,
        center: Text(
          stat.value.toString(),
          style: Styles.statsValue,
        ),
        progressColor: Colors.green,
      );
    }
    return Card(
      elevation: 0.0,
      child: ListTile(
        title: Text(stat.name, style: Styles.statsTitle),
        subtitle: Text(stat.desc, style: Styles.statsDescription),
        trailing: trailing,
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
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
      padding: AppDimensions.bodyPadding,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Styles.poliferieWhite),
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
          return CircularProgressIndicator();
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
        create: (context) => ItemBloc(itemRepository: itemRepository),
        child: ItemScreenBody(widget.id),
      ),
    );
  }
}