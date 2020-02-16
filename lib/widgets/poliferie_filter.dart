import 'package:flutter/material.dart';

import 'package:poliferie_platform_flutter/styles.dart';

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

  void _toggle() {
    setState(() {
      _isApplied = !_isApplied;
    });
  }

  TextEditingController _textFieldController = TextEditingController();

  _showValuePicker(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.name),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: widget.hint),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text('ANNULLA'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text('APPLICA'),
              onPressed: () {
                _value = _textFieldController.text;
                _isApplied = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: FlatButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        onPressed: () {
          _toggle();
        },
        onLongPress: () {
          _showValuePicker(context);
        },
        textColor:
            _isApplied ? Styles.poliferieRedAccent : Styles.poliferieDarkGrey,
        child: Icon(widget.icon),
      ),
    );
  }
}
