import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';

import 'package:Poliferie.io/widgets/poliferie_value_box.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';

import 'package:auto_size_text/auto_size_text.dart';

enum FilterType { dropDown, selectRange, selectValue }

final courseFilterList = <PoliferieFilter>[
  PoliferieFilter(
    icon: Icons.my_location,
    name: 'Regione',
    hint: 'Inserisci una regione...',
    description: "Regione dell'università",
    type: FilterType.dropDown,
    range: [
      "Lazio",
      "Lombardia",
      "Piemonte",
      "Campania",
      "Basilicata",
      "Puglia",
      "Molise"
    ],
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
      range: ["ITA", "ENG"]),
  PoliferieFilter(
      icon: Icons.monetization_on,
      name: 'Stipendio',
      hint: '',
      description: 'Stipendio netto mensile',
      type: FilterType.selectRange,
      range: [0, 100]),
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
  bool selected = false;

  // String values selected for dropDown and selectValue types
  List<String> value = [];

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
          child: PoliferieIconBox(widget.icon, iconColor: Styles.poliferieRed),
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

  Widget _buildSelector(StateSetter updateState) {
    if (widget.type == FilterType.selectRange) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RangeSlider(
            values: values,
            onChanged: (RangeValues values) {
              updateBottomSheetState(
                  updateState, FilterType.selectRange, values);
            },
            min: widget.range[0].toDouble(),
            max: widget.range[1].toDouble(),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PoliferieValueBox("Minimo",
                    values.start.toInt().toString() + " " + widget.unit),
                PoliferieValueBox("Massimo",
                    values.end.toInt().toString() + " " + widget.unit),
              ]),
        ],
      );
    } else if (widget.type == FilterType.selectValue) {
      return Text("Value");
    } else if (widget.type == FilterType.dropDown) {
      List<String> _list = widget.range.map((e) => e.toString()).toList();
      // TODO(@amerlo): Fix hack for Container height
      return Container(
        height: 300,
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  updateBottomSheetState(
                      updateState, FilterType.dropDown, _list[index]);
                },
                leading: value.contains(_list[index])
                    ? Icon(Icons.check_box, color: Styles.poliferieRed)
                    : Icon(Icons.check_box_outline_blank,
                        color: Styles.poliferieVeryLightGrey),
                title: Text(_list[index]),
              ),
            );
          },
        ),
      );
    } else {
      throw Exception("Filter type is not defined!");
    }
  }

  Future<Null> updateBottomSheetState(
      StateSetter updateState, FilterType type, dynamic newValue) async {
    updateState(() {
      if (type == FilterType.selectRange) {
        values = newValue;
      } else if (type == FilterType.dropDown) {
        if (value.contains(newValue)) {
          value.remove(newValue);
        } else {
          value.add(newValue);
        }
      }
    });
  }

  Widget _buildBottomSheet(StateSetter updateState) {
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
              _buildSelector(updateState),
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
          return StatefulBuilder(builder: (context, state) {
            return Container(
              color: Styles.poliferieLightGrey,
              child: Container(
                child: _buildBottomSheet(state),
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
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.filterCardBorderRadius),
        ),
        /*child: FlatButton(onPressed: _onButtonPressed, child: Row(children: <Widget>[PoliferieIconBox(widget.icon), Expanded(child:Text(
            widget.name,
            style: Styles.filterName.copyWith(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ))]),),*/
        child: FlatButton.icon(
          padding: EdgeInsets.all(10),
          onPressed: _onButtonPressed, 
          icon: PoliferieIconBox(
            widget.icon, 
            iconColor: selected ? Colors.white : Styles.poliferieRed,
            iconBackgroundColor: selected ? Styles.poliferieRed : null), 
          label: Expanded(child: AutoSizeText(
            widget.name,
            style: Styles.filterName,
            wrapWords: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            minFontSize: 12,
          )),
        ),
        /*child: ListTile(
          onTap: _onButtonPressed,
          leading: PoliferieIconBox(widget.icon),
          selected: selected,
          title: Text(
            widget.name,
            style: Styles.filterName,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),*/
      ),
    );
  }
}
