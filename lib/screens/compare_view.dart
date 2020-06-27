import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:Poliferie.io/widgets/poliferie_animated_list.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/item.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';

// TODO(@amerlo): Include test to check that we receive at least two items.

class CompareViewScreen extends StatefulWidget {
  // Items to compare
  final List<SearchSuggestion> queryItems;
  const CompareViewScreen(this.queryItems, {Key key}) : super(key: key);

  @override
  _CompareViewScreenState createState() => _CompareViewScreenState();
}

class CompareViewScreenBody extends StatefulWidget {
  final List<SearchSuggestion> queryItems;
  CompareViewScreenBody(this.queryItems);

  @override
  _CompareViewScreenBodyState createState() => _CompareViewScreenBodyState();
}

class _CompareViewScreenBodyState extends State<CompareViewScreenBody> {
  final double _widthRatio = 0.45;
  Widget _buildInfoBox(BuildContext context, ItemModel item) {
    return Container(
      // TODO(@amerlo): Fix width
      width: MediaQuery.of(context).size.width * _widthRatio,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Styles.poliferieWhite),
      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
      child: Text(
        item.shortName,
        style: Styles.cardHeadHorizontal,
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, List<ItemModel> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ...items.map((i) => _buildInfoBox(context, i)).toList(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, List<ItemModel> items) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: Styles.poliferieRed),
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          _buildHeaderRow(context, items),
        ],
      ),
    );
  }

  Widget _buildInfo(ItemModel item) {
    return Container(
      width: MediaQuery.of(context).size.width * _widthRatio * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TODO(@amerlo): Build this property as ItemModel getter
          Text(
              item.provider != null
                  ? item.provider + ', ' + item.city
                  : item.city,
              maxLines: 2,
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
    );
  }

  Widget _buildStats(ItemModel item) {
    // TODO(@amerlo): Move this data structure to ItemModel
    // Build stats according to item type
    List<IconData> _infoIcons;
    if (item.type == ItemType.course) {
      _infoIcons = [
        Icons.looks_one,
        Icons.language,
        Icons.card_membership,
        Icons.lock,
        Icons.check_circle,
        Icons.recent_actors,
      ];
    } else if (item.type == ItemType.university) {
      _infoIcons = [Icons.lock, Icons.location_searching];
    } else {
      return Container();
    }
    // TODO(@amerlo): How to scale height dynamically?
    return Container(
      width: MediaQuery.of(context).size.width * _widthRatio * 0.9,
      height: 60.0 * (_infoIcons.length / 3).ceil(),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1,
        children: <Widget>[
          ..._infoIcons
              .map(
                (i) => Padding(
                  padding: EdgeInsets.all(5.0),
                  child: PoliferieIconBox(
                    i,
                    iconColor: Styles.poliferieRed,
                    iconSize: 32.0,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRow(List<ItemModel> items, Function buildFunction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[...items.map((i) => buildFunction(i)).toList()],
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
        PoliferieAnimatedList(items: items, singleHeight: 130.0),
      ],
    );
  }

  // TODO(@amerlo): Handle list input
  // TODO(@amerlo): Make this card standard in ItemModel
  Card _buildCard(List<ItemStat> stats) {
    // TODO(@amerlo): Check same type
    String _type = stats[0].type;
    List<Widget> _values;
    if (_type == "euro") {
      _values = stats
          .map((s) =>
              Text(s.value.toStringAsFixed(0) + '€', style: Styles.statsValue))
          .toList();
    } else if (_type == "circle") {
      _values = stats
          .map((s) => CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 3.0,
                percent: s.value / 100,
                center: Text(
                  s.value.toString(),
                  style: Styles.statsValue,
                ),
                progressColor: Colors.green,
              ))
          .toList();
    } else {
      _values = stats
          .map((s) => Text(s.value.toString(), style: Styles.statsValue))
          .toList();
    }
    return Card(
      elevation: 0.0,
      child: Container(
        // TODO(@amerlo): Fix card height
        height: 120.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(stats[0].name, style: Styles.statsTitle),
            Text(stats[0].desc, style: Styles.statsDescription),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[..._values],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Styles.poliferieRed,
      thickness: 2.0,
      height: 40,
    );
  }

  Widget _buildCompareBody(BuildContext context, List<ItemModel> items) {
    // TODO(@amerlo): List order matters, decide how to do it.
    // TODO(@amerlo): Handle different stats here
    List<Widget> itemStats = List<Widget>();
    for (String statKey in items[0].stats.keys) {
      List<Card> cards = items[0]
          .stats[statKey]
          .asMap()
          .map((key, value) =>
              MapEntry(key, _buildCard([value, items[1].stats[statKey][key]])))
          .values
          .toList();
      itemStats.add(_buildList(statKey, cards));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.bodyPaddingLeft),
      width: double.infinity,
      color: Styles.poliferieWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          _buildRow(items, _buildInfo),
          _buildRow(items, _buildStats),
          _buildDivider(),
          ...itemStats,
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<ItemModel> items) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildHeader(context, items),
        _buildCompareBody(context, items),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO(@amerlo): Fetch two results
    BlocProvider.of<ItemBloc>(context).add(FetchItem(widget.queryItems[0].id));

    return BlocBuilder<ItemBloc, ItemState>(
      builder: (BuildContext context, ItemState state) {
        if (state is FetchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        if (state is FetchStateSuccess) {
          return _buildBody(context, [state.item, state.item]);
        }
        return Text('This widge should never be reached');
      },
    );
  }
}

class _CompareViewScreenState extends State<CompareViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO(@amerlo): We would like to remove the settings icon here
      appBar: PoliferieAppBar(
        icon: Icons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocProvider<ItemBloc>(
        create: (context) => ItemBloc(
            itemRepository: RepositoryProvider.of<ItemRepository>(context)),
        child: CompareViewScreenBody(widget.queryItems),
      ),
    );
  }
}
