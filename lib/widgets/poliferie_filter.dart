import 'package:flutter/material.dart';

import 'package:Poliferie.io/styles.dart';

/// TODO(@amerlo): Move this to BLoC
final courseFilterList = <PoliferieFilter>[
  PoliferieFilter(
      icon: Icons.my_location,
      name: 'Regione',
      hint: 'Inserisci una regione...',
      description: "Regione dell'università"),
  PoliferieFilter(
      icon: Icons.supervised_user_circle,
      name: 'Studenti',
      hint: 'Numero minimo di studenti...',
      description: 'Numero di iscritti al corso'),
  PoliferieFilter(
      icon: Icons.money_off,
      name: 'Tassa',
      hint: 'Tassa massima annuale...',
      description: 'Tassa universitaria annuale'),
  PoliferieFilter(
      icon: Icons.sentiment_satisfied,
      name: 'Soddisfazione',
      hint: 'Grado di soddisfazione minimo...',
      description: 'Grado di soddisfazione dei laureati'),
  PoliferieFilter(
      icon: Icons.book,
      name: 'Area Disciplinare',
      hint: 'Area disciplinare...',
      description: 'Area disciplinare del corso'),
  PoliferieFilter(
      icon: Icons.book,
      name: 'Area Disciplinare',
      hint: 'Area disciplinare...',
      description: 'Area disciplinare del corso'),
  PoliferieFilter(
      icon: Icons.book,
      name: 'Area Disciplinare',
      hint: 'Area disciplinare...',
      description: 'Area disciplinare del corso'),
  PoliferieFilter(
      icon: Icons.book,
      name: 'Area Disciplinare',
      hint: 'Area disciplinare...',
      description: 'Area disciplinare del corso'),
  PoliferieFilter(
      icon: Icons.book,
      name: 'Area Disciplinare',
      hint: 'Area disciplinare...',
      description: 'Area disciplinare del corso'),
];

class PoliferieFilter extends StatefulWidget {
  const PoliferieFilter({
    Key key,
    this.icon,
    this.name,
    this.hint,
    this.description,
  }) : super(key: key);

  final IconData icon;
  final String name;
  final String description;
  final String hint;

  @override
  _PoliferieFilterState createState() => new _PoliferieFilterState();
}

class _PoliferieFilterState extends State<PoliferieFilter> {
  String _value = '';
  bool _isApplied = false;

  TextEditingController _textFieldController = TextEditingController();

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

  Widget _builcActionButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      FlatButton(
        child: new Text('APPLICA'),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            _value = _textFieldController.text;
            _isApplied = true;
          });
        },
      ),
      FlatButton(
        child: new Text('PULISCI'),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            _value = null;
            _isApplied = false;
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
          _builcActionButtons(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      child: FlatButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        onPressed: () {
          _onButtonPressed();
        },
        onLongPress: () {},
        textColor:
            _isApplied ? Styles.poliferieRedAccent : Styles.poliferieDarkGrey,
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
