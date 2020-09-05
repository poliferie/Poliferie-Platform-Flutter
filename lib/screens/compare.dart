import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:flutter/widgets.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/bloc/search_bloc.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_tab_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';
import 'package:Poliferie.io/widgets/poliferie_search_delegate.dart';
import 'package:Poliferie.io/models/item.dart';
import 'package:Poliferie.io/models/suggestion.dart';
import 'package:Poliferie.io/screens/compare_view.dart';
import 'package:Poliferie.io/screens/results.dart';
import 'package:Poliferie.io/repositories/search_repository.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/styles.dart';

// TODO(@amerlo): Move this to a widget
class CompareItemBox extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color color;
  final Function selector;
  final Function deselector;
  final bool selected;
  CompareItemBox(
      {this.title,
      this.subTitle,
      this.color,
      this.selector,
      this.deselector,
      this.selected: false});

  Widget _buildBody(BuildContext context) {
    // TODO(@amerlo): Select style to use
    TextStyle _titleStyle = color == Styles.poliferieRed
        ? Styles.cardHeadHorizontalWhite
        : Styles.cardHeadHorizontal;
    _titleStyle = selected ? _titleStyle : Styles.cardHeadHorizontalGray;
    return Container(
      // TODO(@amerlo): Add item stats when selected
      height: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Text(title, style: _titleStyle),
                Text(subTitle == null ? '' : subTitle,
                    style: color == Styles.poliferieRed
                        ? Styles.cardSubHeadingWhite
                        : Styles.cardSubHeading),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              color: color == Styles.poliferieRed
                  ? Styles.poliferieLightWhite
                  : Styles.poliferieRed,
              onPressed: selected ? deselector : selector,
              iconSize: 32,
              icon: Icon(selected ? Icons.remove_circle : Icons.add_box),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: _buildBody(context),
    );
  }
}

class CompareScreen extends StatefulWidget {
  CompareScreen({Key key}) : super(key: key);

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class CompareScreenBody extends StatefulWidget {
  @override
  _CompareScreenBodyState createState() => _CompareScreenBodyState();
}

class _CompareScreenBodyState extends State<CompareScreenBody> {
  // Selected items
  List<SearchSuggestion> _items = [null, null];
  bool _readyToCompare() {
    return !_items.any((i) => i == null);
  }

  Widget _buildHeadline() {
    return Text(Strings.compareHeadline, style: Styles.headline);
  }

  Widget _buildSubHeadline() {
    return Padding(
      padding: AppDimensions.subHeadlinePadding,
      child: Text(
        Strings.compareSubHeadline,
        style: Styles.subHeadline,
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
        padding: EdgeInsets.only(bottom: 10.0), child: PoliferieTabBar());
  }

  Widget _buildFloatingButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.of(context).padding.bottom + 10),
      child: PoliferieFloatingButton(
        text: Strings.compareAction,
        activeColor: Styles.poliferieBlue,
        isActive: _readyToCompare(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompareViewScreen(_items),
            ),
          );
        },
      ),
    );
  }

  // Callback to select item
  void _searchAndSelect(int box, ItemType type) {
    showSearch(
      context: context,
      delegate: PoliferieSearchDelegate(
        searchBloc: BlocProvider.of<SearchBloc>(context),
        onSuggestionTap: (SearchSuggestion suggestion) => {
          setState(
            () {
              _items[box] = suggestion;
            },
          )
        },
      ),
    );
  }

  // Callback to deselect item
  void _deselect(int box) {
    setState(() {
      _items[box] = null;
    });
  }

  Widget _buildInputBoxes(BuildContext context, ItemType type) {
    String _nullString =
        type == ItemType.course ? 'Scegli un corso' : 'Scegli un\'università';
    return Column(
      children: <Widget>[
        ..._items
            .asMap()
            .map(
              (index, s) => MapEntry(
                index,
                CompareItemBox(
                  title: s == null ? _nullString : s.shortName,
                  selector: () {
                    _searchAndSelect(index, type);
                  },
                  deselector: () {
                    _deselect(index);
                  },
                  selected: s != null,
                ),
              ),
            )
            .values
            .toList(),
      ],
    );
  }

  Widget _buildTabBarBody(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildInputBoxes(context, ItemType.course),
              _buildInputBoxes(context, ItemType.university),
            ],
          ),
          _buildFloatingButton(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: AppDimensions.bodyPadding,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeadline(),
            _buildSubHeadline(),
            SizedBox(height: 20),
            _buildTabBar(),
            _buildTabBarBody(context),
          ],
        ),
      ),
    );
  }

  /// Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(icon: AppIcons.settings),
      body: _buildBody(context),
    );
  }
}

class _CompareScreenState extends State<CompareScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(
          create: (BuildContext context) => SearchBloc(
              searchRepository:
                  RepositoryProvider.of<SearchRepository>(context)),
        ),
      ],
      child: CompareScreenBody(),
    );
  }
}
