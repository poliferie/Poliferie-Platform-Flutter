import 'dart:ui';

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

class _PoliferieFilterState extends State<PoliferieFilter>
    with AutomaticKeepAliveClientMixin {
  /// Is filter selected
  bool selected = false;

  /// String values selected for dropDown and selectValue types
  List<String> selectedValues = [];

  /// RangeValues selected for selectRange type
  RangeValues rangeValues;

  @override
  bool get wantKeepAlive => true;

  bool atLeastOne() {
    if (widget.filter.type == FilterType.dropDown) {
      return selectedValues.length != 0;
    }
    if (widget.filter.type == FilterType.selectRange) {
      // For selectRange filter, we could always select the filter
      return true;
    }
    if (widget.filter.type == FilterType.selectValue) {
      return selectedValues.isNotEmpty && selectedValues[0] != "";
    }
  }

  // Initialize filter state
  @override
  initState() {
    super.initState();
    if (widget.filter.type == FilterType.selectRange) {
      rangeValues = RangeValues(widget.status.values[0].toDouble(),
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
            values: rangeValues,
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
                PoliferieValueBox(
                  "Minimo",
                  rangeValues.start.toInt().toString() + widget.filter.unit,
                ),
                PoliferieValueBox(
                  "Massimo",
                  rangeValues.end.toInt().toString() + widget.filter.unit,
                ),
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
    } else if (widget.filter.type == FilterType.selectValue) {
      TextEditingController _controller = TextEditingController(
          text: (selectedValues.isNotEmpty) ? selectedValues[0] : '');
      // TODO(@amerlo): We must check the type of inserted value
      return Container(
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: widget.filter.hint,
            suffixText: widget.filter.unit,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                style: BorderStyle.solid,
              ),
            ),
          ),
          onSubmitted: (value) {
            updateBottomSheetState(updateState, FilterType.selectValue, value);
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
        selectedValues.length == 1 &&
        selectedValues[0] == newValue) {
      widget.updateValue(null, false);
    }
    updateState(() {
      if (type == FilterType.selectRange) {
        rangeValues = newValue;
      } else if (type == FilterType.selectValue) {
        selectedValues = [newValue];
      } else if (type == FilterType.dropDown) {
        if (selectedValues.contains(newValue)) {
          if (selectedValues.length == 1 && selectedValues.contains(newValue)) {
            selected = false;
          }
          selectedValues.remove(newValue);
        } else {
          selectedValues.add(newValue);
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

  void _onButtonPressed() {
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
        rangeValues = RangeValues(newValues[0], newValues[1]);
      } else if (type == FilterType.dropDown) {
        selectedValues = [];
      } else if (type == FilterType.selectValue) {
        selectedValues = [];
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

  Widget _buildPreview() {
    // TODO(@amerlo): Find a better copy
    TextStyle previewStyle = TextStyle(color: widget.color);
    if (selected) {
      if (widget.filter.type == FilterType.dropDown) {
        if (selectedValues.length > 1) {
          return Text('Selezione multiple');
        } else if (selectedValues.length == 1) {
          return Text(
            selectedValues[0],
            style: previewStyle,
          );
        }
      } else if (widget.filter.type == FilterType.selectRange) {
        return Text(
          rangeValues.start.toStringAsFixed(0) +
              widget.filter.unit +
              ' - ' +
              rangeValues.end.toStringAsFixed(0) +
              widget.filter.unit,
          style: previewStyle,
        );
      } else if (widget.filter.type == FilterType.selectValue) {
        return Text(
          selectedValues[0] + widget.filter.unit,
          style: previewStyle,
        );
      }
    }
    return Text("");
  }

  Widget _buildDismissibleCard() {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(AppDimensions.filterCardBorderRadius),
      ),
      child: ListTile(
        onTap: _onButtonPressed,
        leading: PoliferieIconBox(
          widget.filter.icon,
          iconSize: AppDimensions.filterIconSize,
          iconColor: widget.status.selected ? Colors.white : widget.color,
          iconBackgroundColor: widget.status.selected ? widget.color : null,
        ),
        title: AutoSizeText(
          widget.filter.name,
          style: Styles.filterName,
          wrapWords: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          minFontSize: AppDimensions.filterTitleFontSize,
        ),
        trailing: _buildPreview(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Dismissible(
      key: GlobalKey(),
      confirmDismiss: (direction) => _doNotDismiss(widget.filter.type),
      background: _buildDismissibleBackgroud(),
      child: _buildDismissibleCard(),
    );
  }
}
