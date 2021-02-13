import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/services.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/utils.dart';

import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/item.dart';
import 'package:Poliferie.io/models/models.dart';

import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';
import 'package:Poliferie.io/widgets/poliferie_animated_list.dart';
import 'package:Poliferie.io/widgets/poliferie_animated_text.dart';

import 'package:auto_size_text/auto_size_text.dart';

class ItemScreen extends StatefulWidget {
  /// This [id] is the requested id from the frontend
  final String id;

  const ItemScreen(this.id, {Key key}) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class ItemScreenBody extends StatefulWidget {
  // TODO(@amerlo): Could we avoid this?
  final String id;
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
          AppIcons.back,
          color: Styles.poliferieLightGrey,
        ),
        onPressed: () {
          {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildImage(ItemModel item) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(bottom: 1),
      child: getImage(
        item.providerImage,
        fit: BoxFit.cover,
        height: screenSize.height / 3,
        width: screenSize.width,
      ),
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

  Widget _buildButtonBar(ItemModel item) {
    return Positioned(
      bottom: 20.0,
      right: 15.0,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        clipBehavior: Clip.hardEdge,
        elevation: 4.0,
        child: ButtonBar(
          children: <Widget>[
            if (item.website != null &&
                item.website.length > 0 &&
                item.website != '-')
              FlatButton(
                color: Styles.poliferieWhite,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Icon(
                  Icons.open_in_new, //account_balance,
                  color: Styles.poliferieRed,
                  size: 32,
                ),
                onPressed: () => launchInWebViewOrVC(item.website),
              ),
            FlatButton(
              color: Styles.poliferieWhite,
              padding: EdgeInsets.all(10.0),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Styles.poliferieRed,
                size: 36,
              ),
              onPressed: () => _updateIsFavorite(toggle: true),
            ),
          ],
          buttonPadding: EdgeInsets.all(0.0),
        ),
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
        _buildButtonBar(item)
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
        item.duration.toString(): Icons.calendar_today,
        item.language: Icons.translate,
        item.requirements: Icons.card_membership,
        item.owner: Icons.lock,
        item.access: Icons.check_circle,
        item.education: Icons.monitor,
      };
    } else if (item.type == ItemType.university) {
      infoMap = {
        item.owner: Icons.lock,
        item.region: Icons.place,
        item.students.toString(): Icons.people,
      };
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
                  padding: EdgeInsets.only(left: 3.0, right: 6.0),
                  child: PoliferieIconBox(
                    infoMap[text],
                    iconColor: Styles.poliferieRed,
                    iconSize: 18.0,
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    text,
                    minFontSize: 10,
                    maxLines: 2,
                    wrapWords: false,
                    style: Styles.courseInfoStats,
                    overflow: TextOverflow.ellipsis,
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
          Padding(
            child: Text(Strings.courseDescription, style: Styles.tabHeading),
            padding: EdgeInsets.only(bottom: 16.0),
          ),
          PoliferieAnimatedText(
            text: item.longDescription,
            previewText:
                (item.shortDescription != null && item.shortDescription != '-')
                    ? item.shortDescription
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildList(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Text(title, style: Styles.tabHeading),
          padding: EdgeInsets.only(bottom: 16.0),
        ),
        PoliferieAnimatedList(items: items),
      ],
    );
  }

  Widget _buildCard(ItemStat stat) {
    bool _enabled = stat.value != null;
    return Container(
      height: AppDimensions.itemCardHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  stat.name,
                  style:
                      _enabled ? Styles.statsTitle : Styles.disabledStatsTitle,
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
                Text(
                  stat.desc,
                  style: _enabled
                      ? Styles.statsDescription
                      : Styles.disabledStatsDescription,
                  textAlign: TextAlign.left,
                  softWrap: true,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: buildCardTraling(stat),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildCourseBody(BuildContext context, ItemModel item) {
    // TODO(@amerlo): List order matters, decide how to do it.
    List<Widget> itemStats = List<Widget>();
    item.stats.forEach((String listName, List<ItemStat> statList) {
      List<Widget> cards = [];
      List<Widget> nullCards = [];
      for (ItemStat stat in statList) {
        if (stat.value == null)
          nullCards.add(_buildCard(stat));
        else
          cards.add(_buildCard(stat));
      }
      //if (cards.isNotEmpty)
      itemStats.add(_buildList(listName, cards + nullCards));
    });

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
    BlocProvider.of<ItemBloc>(context).add(FetchItems([widget.id]));

    return BlocBuilder<ItemBloc, ItemState>(
      builder: (BuildContext context, ItemState state) {
        if (state is FetchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        if (state is FetchStateSuccess) {
          return _buildBody(context, state.items[0]);
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
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: ItemScreenBody(widget.id,
              favoritesRepository:
                  RepositoryProvider.of<FavoritesRepository>(context)),
        ),
      ),
    );
  }
}

/// Build [ItemStat] value widget based in value unit
Widget buildCardTraling(ItemStat stat) {
  var value = parseStatValue(stat.value);
  if (stat.unit == "%") {
    return CircularPercentIndicator(
      animation: true,
      animationDuration: 1000,
      radius: 50.0,
      lineWidth: 3.0,
      percent: (value ?? 0) / 100,
      center: Padding(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            (value?.toStringAsFixed(0) ?? '- ') + "%",
            style: Styles.statsValue,
          ),
        ),
        padding: EdgeInsets.all(5),
      ),
      progressColor: Color.lerp(Colors.red, Colors.green, (value ?? 0) / 100),
    );
  } else if (stat.unit == "€") {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        (value?.toStringAsFixed(0) ?? '- ') + stat.unit,
        style: Styles.statsValue,
      ),
    );
  } else {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        (value?.toString() ?? '-') + (stat.unit != '' ? ' ' + stat.unit : ''),
        style: Styles.statsValue,
      ),
    );
  }
}
