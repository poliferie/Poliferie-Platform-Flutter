import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';

import 'package:Poliferie.io/widgets/poliferie_value_box.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';

enum FilterType { dropDown, selectRange, selectValue }

final courseFilterList = <PoliferieFilter>[
  PoliferieFilter(
    icon: Icons.my_location,
    name: 'Regione',
    hint: 'Inserisci una regione...',
    description: "Regione dell'università",
    type: FilterType.dropDown,
    range: ["Lazio", "Lombardia"],
  ),
  PoliferieFilter(
    icon: Icons.supervised_user_circle,
    name: 'Studenti',
    hint: 'Numero minimo di studenti...',
    description: 'Numero di iscritti al corso',
    type: FilterType.selectRange,
    range: [0, 10000],
  ),
  PoliferieFilter(
    icon: Icons.money_off,
    name: 'Tassa',
    hint: 'Tassa massima annuale...',
    description: 'Tassa universitaria annuale',
    type: FilterType.selectRange,
    range: [0, 10000],
    unit: "€",
  ),
  PoliferieFilter(
    icon: Icons.sentiment_satisfied,
    name: 'Soddisfazione',
    hint: 'Grado di soddisfazione minimo...',
    description: 'Grado di soddisfazione dei laureati',
    type: FilterType.selectRange,
    range: [0, 100],
    unit: "%",
  ),
  PoliferieFilter(
    icon: Icons.book,
    name: 'Area Disciplinare',
    hint: 'Area disciplinare...',
    description: 'Area disciplinare del corso',
    type: FilterType.dropDown,
    range: ["Matematica", "Fisica"],
  ),
  PoliferieFilter(
    icon: Icons.settings,
    name: 'Tirocini',
    hint: 'Percentuale di tirocini...',
    description:
        'Percentuale di studenti che ha effettuato almeno un tirocinio formativo',
    type: FilterType.selectRange,
    range: [0, 100],
    unit: "%",
  ),
  PoliferieFilter(
      icon: Icons.settings,
      name: 'Lingua',
      hint: '',
      description: 'Lingua di insegnamento del corso',
      type: FilterType.selectValue,
      range: ["ITA", "ENG"])
];

class PoliferieFilter extends StatefulWidget {
  const PoliferieFilter({
    Key key,
    this.icon,
    this.name,
    this.hint,
    this.description,
    this.type,
    this.range,
    this.unit = "",
  }) : super(key: key);

  final IconData icon;
  final String name;
  final String description;
  final String hint;
  final FilterType type;
  final String unit;

  /// Set of possible values, it depends on [FilterType]
  final List range;

  @override
  _PoliferieFilterState createState() => new _PoliferieFilterState();
}

class _PoliferieFilterState extends State<PoliferieFilter> {
  // TODO(@amerlo): Could they be made private?
  bool selected = false;

  // String values selected for dropDown and selectValue types
  String value;

  // RangeValues selected for selectRange type
  RangeValues values;

  // Initialize filter state
  @override
  initState() {
    super.initState();
    if (widget.type == FilterType.selectRange) {
      double _min = widget.range[0].toDouble();
      double _max = widget.range[1].toDouble();
      double _range = _max - _min;
      values = RangeValues(_min + 0.1 * _range, _max - _range * 0.1);
    }
  }

  Widget _buildFloatingButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 50.0),
      child: PoliferieFloatingButton(
        text: Strings.filterSet,
        activeColor: Styles.poliferieGreen,
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            value = "Prova";
            selected = true;
          });
        },
      ),
    );
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: AppDimensions.bottomSheetPadding,
          child: Icon(
            widget.icon,
            color: Styles.poliferieRed,
          ),
        ),
        Text(
          widget.name,
          style: Styles.filterHeadline,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppDimensions.bottomSheetPaddingHorizontal,
          10.0, AppDimensions.bottomSheetPaddingHorizontal, 10.0),
      child: Text(
        widget.description,
        style: Styles.tabDescription,
      ),
    );
  }

  Widget _buildSelector() {
    if (widget.type == FilterType.selectRange) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RangeSlider(
            values: values,
            onChanged: (RangeValues values) {
              setState(() {
                values = values;
              });
            },
            min: widget.range[0].toDouble(),
            max: widget.range[1].toDouble(),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PoliferieValueBox(
                    "Minimo", values.start.toString() + " " + widget.unit),
                PoliferieValueBox(
                    "Massimo", values.end.toString() + " " + widget.unit),
              ]),
        ],
      );
    } else if (widget.type == FilterType.selectValue) {
      return Text("Value");
    } else if (widget.type == FilterType.dropDown) {
      return Text("Drop down");
    } else {
      throw Exception("Filter type is not defined!");
    }
  }

  Widget _buildBottomSheet() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.bodyPaddingLeft,
        AppDimensions.bottomSheetPaddingVertical,
        AppDimensions.bodyPaddingRight,
        AppDimensions.bottomSheetPaddingVertical,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeading(),
              _buildDescription(),
              _buildSelector(),
            ],
          ),
          _buildFloatingButton(),
        ],
      ),
    );
  }

  _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Styles.poliferieLightGrey,
            child: Container(
              child: _buildBottomSheet(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                ),
              ),
            ),
          );
        });
  }

  Future<bool> _doNotDismiss() async {
    setState(() {
      selected = false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(),
      confirmDismiss: (direction) => _doNotDismiss(),
      background: Container(
        color: Styles.poliferieRed,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerStart,
        child: Icon(
          Icons.delete,
          color: Styles.poliferieLightWhite,
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListTile(
          onTap: _onButtonPressed,
          leading: Icon(widget.icon),
          selected: selected,
          title: Text(
            widget.name,
            style: Styles.filterName,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
