import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/dimensions.dart';

import 'package:Poliferie.io/models/filter.dart';
import 'package:Poliferie.io/widgets/poliferie_value_box.dart';
import 'package:Poliferie.io/widgets/poliferie_floating_button.dart';
import 'package:Poliferie.io/widgets/poliferie_icon_box.dart';

class PoliferieFilter extends StatefulWidget {
  const PoliferieFilter(this.filter, this.status,
      {this.updateValue, this.color = Styles.poliferieRed, key})
      : super(key: key);

  final Filter filter;
  final FilterStatus status;
  final Function updateValue;
  final Color color;

  @override
  _PoliferieFilterState createState() => new _PoliferieFilterState();
}

class _PoliferieFilterState extends State<PoliferieFilter> {
  /// Is filter selected
  bool selected = false;

  /// String values selected for dropDown and selectValue types
  List<String> value = [];

  /// RangeValues selected for selectRange type
  RangeValues values;

  bool atLeastOne() {
    if (widget.filter.type == FilterType.dropDown) {
      return value.length != 0;
    }
    if (widget.filter.type == FilterType.selectRange) {
      // For selectRange filter, we could always select the filter
      return true;
    }
  }

  // Initialize filter state
  @override
  initState() {
    super.initState();
    if (widget.filter.type == FilterType.selectRange) {
      values = RangeValues(widget.status.values[0].toDouble(),
          widget.status.values[1].toDouble());
    }
  }

  Widget _buildFloatingButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 50.0),
      child: PoliferieFloatingButton(
        text: Strings.filterSet,
        activeColor: Styles.poliferieGreen,
        isActive: atLeastOne(),
        onPressed: () {
          Navigator.pop(context);
          widget.updateValue(null, true);
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
          child: PoliferieIconBox(
            widget.filter.icon,
            iconColor: widget.color,
          ),
        ),
        Text(
          widget.filter.name,
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
        widget.filter.description,
        style: Styles.tabDescription,
      ),
    );
  }

  Widget _buildSelector(StateSetter updateState) {
    if (widget.filter.type == FilterType.selectRange) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RangeSlider(
            values: values,
            onChanged: (RangeValues values) {
              updateBottomSheetState(
                  updateState, FilterType.selectRange, values);
            },
            min: widget.filter.range[0].toDouble(),
            max: widget.filter.range[1].toDouble(),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PoliferieValueBox("Minimo",
                    values.start.toInt().toString() + " " + widget.filter.unit),
                PoliferieValueBox("Massimo",
                    values.end.toInt().toString() + " " + widget.filter.unit),
              ]),
        ],
      );
    } else if (widget.filter.type == FilterType.dropDown) {
      List<String> _list =
          widget.filter.range.map((e) => e.toString()).toList();
      // TODO(@amerlo): Fix hack for Container height
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  updateBottomSheetState(
                      updateState, FilterType.dropDown, _list[index]);
                },
                leading: widget.status.values.contains(_list[index])
                    ? Icon(Icons.check_box, color: widget.color)
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
    widget.updateValue(type, newValue);
    // Deselect filter in case of dropDown and no selection
    if (type == FilterType.dropDown &&
        value.length == 1 &&
        value[0] == newValue) {
      widget.updateValue(null, false);
    }
    updateState(() {
      if (type == FilterType.selectRange) {
        values = newValue;
      } else if (type == FilterType.dropDown) {
        if (value.contains(newValue)) {
          if (value.length == 1 && value.contains(newValue)) {
            selected = false;
          }
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
        0.0,
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
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
              child: _buildBottomSheet(state),
            );
          },
        );
      },
    );
  }

  Future<bool> _doNotDismiss(FilterType type) async {
    // Clear values
    widget.updateValue(type, null);
    widget.updateValue(null, false);
    setState(() {
      selected = false;
      if (type == FilterType.selectRange) {
        List<dynamic> newValues =
            FilterStatus.initStatus(type, widget.filter.range).values;
        values = RangeValues(newValues[0], newValues[1]);
      } else if (type == FilterType.dropDown) {
        value = [];
      }
    });
    return false;
  }

  Widget _buildDismissibleBackgroud() {
    return Card(
      elevation: 0.0,
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(AppDimensions.filterCardBorderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // TODO(@amerlo): Select left or right swipe, not both
          children: <Widget>[
            Icon(
              Icons.delete,
              size: AppDimensions.filterIconSize,
              color: Styles.poliferieLightWhite,
            ),
            Icon(
              Icons.delete,
              size: AppDimensions.filterIconSize,
              color: Styles.poliferieLightWhite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleCard() {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(AppDimensions.filterCardBorderRadius),
      ),
      child: ListTile(
        leading: PoliferieIconBox(
          widget.filter.icon,
          iconSize: AppDimensions.filterIconSize,
          iconColor: widget.status.selected ? Colors.white : widget.color,
          iconBackgroundColor: widget.status.selected ? widget.color : null,
        ),
        title: Expanded(
          child: AutoSizeText(
            widget.filter.name,
            style: Styles.filterName,
            wrapWords: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            minFontSize: AppDimensions.filterTitleFontSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(),
      confirmDismiss: (direction) => _doNotDismiss(widget.filter.type),
      background: _buildDismissibleBackgroud(),
      child: _buildDismissibleCard(),
    );
  }
}
