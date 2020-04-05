import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

enum FilterType { dropDown, selectRange }

final courseFilterList = <PoliferieFilter>[
  PoliferieFilter(
    icon: Icons.my_location,
    name: 'Regione',
    hint: 'Inserisci una regione...',
    description: "Regione dell'università",
    type: FilterType.dropDown,
  ),
  PoliferieFilter(
    icon: Icons.supervised_user_circle,
    name: 'Studenti',
    hint: 'Numero minimo di studenti...',
    description: 'Numero di iscritti al corso',
    type: FilterType.selectRange,
  ),
  PoliferieFilter(
    icon: Icons.money_off,
    name: 'Tassa',
    hint: 'Tassa massima annuale...',
    description: 'Tassa universitaria annuale',
    type: FilterType.selectRange,
  ),
  PoliferieFilter(
    icon: Icons.sentiment_satisfied,
    name: 'Soddisfazione',
    hint: 'Grado di soddisfazione minimo...',
    description: 'Grado di soddisfazione dei laureati',
    type: FilterType.selectRange,
  ),
  PoliferieFilter(
    icon: Icons.book,
    name: 'Area Disciplinare',
    hint: 'Area disciplinare...',
    description: 'Area disciplinare del corso',
    type: FilterType.dropDown,
  ),
  PoliferieFilter(
    icon: Icons.settings,
    name: 'Tirocini',
    hint: 'Percentuale di tirocini...',
    description:
        'Percentuale di studenti che ha effettuato almeno un tirocinio formativo',
    type: FilterType.selectRange,
  )
];

class PoliferieFilter extends StatefulWidget {
  const PoliferieFilter({
    Key key,
    this.icon,
    this.name,
    this.hint,
    this.description,
    this.type,
  }) : super(key: key);

  final IconData icon;
  final String name;
  final String description;
  final String hint;
  final FilterType type;

  @override
  _PoliferieFilterState createState() => new _PoliferieFilterState();
}

class _PoliferieFilterState extends State<PoliferieFilter> {
  // TODO(@amerlo): Could they be made private?
  bool selected = false;
  String value;
  double rangeLow = 0.0;
  double rangeHigh = 0.0;

  TextEditingController _textFieldController = TextEditingController();

  Widget _buildActionButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      FlatButton(
        child: new Text('APPLICA'),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            value = _textFieldController.text;
            selected = true;
          });
        },
      ),
      FlatButton(
        child: new Text('PULISCI'),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            value = null;
            selected = false;
          });
        },
      ),
    ]);
  }

  Widget _buildBottomSheet() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      child: Column(
        children: <Widget>[
          Text(widget.name),
          TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: widget.hint),
          ),
          _buildActionButtons(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.15,
      margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: FlatButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        onPressed: () {
          _onButtonPressed();
        },
        onLongPress: () {},
        textColor: selected ? Styles.poliferieRed : Styles.poliferieDarkGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(widget.icon),
            ),
            Expanded(
              child: Text(
                widget.name,
                style: Styles.filterName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
