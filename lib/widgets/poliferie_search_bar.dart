// adapted from https://github.com/alexrindone/flutter_textfield_search/blob/master/lib/textfield_search.dart

import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/icons.dart';
import 'package:Poliferie.io/utils.dart';
import 'package:flutter/services.dart';

class PoliferieSearchBar extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function loadSuggestions;
  final Function onSearch;
  final List initialList;
  final Function suggestionCallback;
  final int minTextLength;
  const PoliferieSearchBar(
      {Key key,
      @required this.label,
      @required this.controller,
      @required this.loadSuggestions,
      @required this.onSearch,
      this.initialList,
      this.suggestionCallback,
      this.minTextLength = 4})
      : super(key: key);

  @override
  _PoliferieSearchBarState createState() => _PoliferieSearchBarState();
}

class _PoliferieSearchBarState extends State<PoliferieSearchBar> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List suggestions = new List();
  bool loading = false;
  final _debouncer = Debouncer(milliseconds: 500);
  bool notEmpty;

  void resetText() {
    widget.controller.text = '';
    checkIsEmpty();
  }

  void checkIsEmpty() {
    if (notEmpty != (widget.controller.text.length > 0)) {
      setState(() {
        notEmpty = (widget.controller.text.length > 0);
      });
    }
  }

  void resetList() {
    List tempList = new List();
    setState(() {
      this.suggestions = tempList;
      this.loading = false;
    });
    // mark that the overlay widget needs to be rebuilt
    this._overlayEntry.markNeedsBuild();
  }

  void setLoading() {
    if (!this.loading) {
      setState(() {
        this.loading = true;
      });
    }
  }

  void updateSuggestions() {
    // mark that the overlay widget needs to be rebuilt
    // so loader can show
    this._overlayEntry.markNeedsBuild();

    this.setLoading();
    widget.loadSuggestions().then((suggestionsList) {
      // create an empty temp list
      List tempList = new List();
      if (widget.initialList != null) {
        // loop through each item in filtered items
        for (int i = 0; i < widget.initialList.length; i++) {
          // lowercase the item and see if the item contains the string of text from the lowercase search
          if (widget.initialList[i].longName
              .toLowerCase()
              .contains(widget.controller.text.toLowerCase())) {
            // if there is a match, add to the temp list
            tempList.add(widget.initialList[i]);
          }
        }
      }
      tempList.addAll(suggestionsList);
      setState(() {
        // after loop is done, set the suggestions from the tempList
        this.suggestions = tempList;
        this.loading = false;
      });
      // mark that the overlay widget needs to be rebuilt so results can show
      this._overlayEntry.markNeedsBuild();
    });
  }

  void initState() {
    super.initState();
    notEmpty = (widget.controller.text.length > 0);
    // add event listener to the focus node and only give an overlay if an entry
    // has focus and insert the overlay into Overlay context otherwise remove it
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    widget.controller.dispose();
    super.dispose();
  }

  Widget _listViewBuilder(context) {
    if (widget.controller.text.length < widget.minTextLength) {
      return null;
    }
    if (suggestions.length > 0) {
      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              // set the controller value to what was selected
              setState(() {
                // if we have a label property, and getSelectedValue function
                // send getSelectedValue to parent widget using the label property
                if (widget.suggestionCallback != null) {
                  // widget.controller.text = suggestions[i].longName +
                  //     (suggestions[i].isCourse()
                  //         ? " " + suggestions[i].provider
                  //         : "");
                  widget.suggestionCallback(suggestions[i]);
                } else {
                  widget.controller.text = suggestions[i];
                }
              });
              // reset the list so it's empty and not visible
              resetList();
              // remove the focus node so we aren't editing the text
              FocusScope.of(context).unfocus();
            },
            child: ListTile(
              leading: Icon(
                suggestions[i].isCourse()
                    ? AppIcons.course
                    : AppIcons.university,
                size: 28,
              ),
              title:
                  Text(suggestions[i].longName, style: Styles.suggestionTitle),
              subtitle: suggestions[i].isCourse()
                  ? Text(suggestions[i].provider)
                  : Text(suggestions[i].city),
            ),
          );
        },
        padding: EdgeInsets.zero,
        shrinkWrap: true,
      );
    } else {
      // TODO(@ferrarodav) substitute string with element in Strings file
      return null; //ListTile(title: Text('No matching items!'));
    }
  }

  Widget _loadingIndicator() {
    return Container(
      width: 50,
      height: 50,
      child: Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    Size overlaySize = renderBox.size;
    Offset position = renderBox
        .localToGlobal(Offset.zero); // get global position of renderBox
    double y = position.dy; // get y coordinate
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    const BOTTOM_OFFSET = 45;
    const MAX_HEIGHT = 400;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: overlaySize.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, overlaySize.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(15),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: screenWidth,
                  maxWidth: screenWidth,
                  minHeight: 0,
                  // make sure we have a max dynamic height of MAX_HEIGHT
                  maxHeight: (screenHeight - y) - BOTTOM_OFFSET > MAX_HEIGHT
                      ? MAX_HEIGHT.toDouble()
                      : (screenHeight - y) - BOTTOM_OFFSET,
                ),
                child:
                    loading ? _loadingIndicator() : _listViewBuilder(context)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Container(
        decoration: BoxDecoration(
          color: Styles.poliferieWhite,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: this._focusNode,
          textInputAction: TextInputAction.search,
          style: Styles.buttonText,
          decoration: InputDecoration(
            hintText: widget.label,
            border: InputBorder.none,
            isDense: false,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: notEmpty
                ? GestureDetector(
                    onTap: resetText,
                    child: Icon(
                      Icons.cancel,
                    ),
                  )
                : Icon(
                    Icons.search,
                  ),
          ),
          showCursor: true,
          onChanged: (String value) {
            checkIsEmpty();
            // every time we make a change to the input, update the list
            if (widget.controller.text.length < widget.minTextLength) {
              resetList();
              print(widget.controller.text);
            } else {
              this.setLoading();
              _debouncer.run(() {
                setState(() {
                  updateSuggestions();
                });
              });
            }
          },
          onSubmitted: widget.onSearch,
        ),
      ),
    );
  }
}
