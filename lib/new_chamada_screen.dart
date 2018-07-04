import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_management/date_time_picker.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewChamadaScreen extends StatefulWidget {
  DateTime _fromDate = new DateTime.now();

  @override
  ChamadaScreenState createState() => new ChamadaScreenState();
}

List<RadioStateFull> list = new List();

class RadioStateFull extends StatefulWidget {
  final Presence _initialState;

  RadioStateFull(Presence presence)
      : _initialState = presence,
        super(key: new ObjectKey(presence));

  @override
  RadioState createState() => new RadioState(_initialState);
}

class TypeRadioStateFull extends StatefulWidget {
  @override
  TypeRadioState createState() => new TypeRadioState();
}

class Presence {
  int type;
  DocumentSnapshot documentSnapshot;
  String nameComp;
  String date;

  Presence(this.type, this.documentSnapshot);
}

class RadioState extends State<RadioStateFull> {
  Presence _radioValue;

  RadioState(Presence i) {
    _radioValue = i;
  }

// Method setting value.
  void onChanged(int value) {
    setState(() {
      _radioValue.type = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Radio(
            value: 0,
            groupValue: _radioValue.type,
            onChanged: (int value) {
              onChanged(value);
            }),
        Radio(
            value: 1,
            groupValue: _radioValue.type,
            onChanged: (int value) {
              onChanged(value);
            }),
        Radio(
            value: 2,
            groupValue: _radioValue.type,
            onChanged: (int value) {
              onChanged(value);
            })
      ],
    );
  }
}

class TypeRadioState extends State<TypeRadioStateFull> {
  int _radioValue = 0;

// Method setting value.
  void onChanged(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: (int value) {
                  onChanged(value);
                }),
            Text("Prático")
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: (int value) {
                  onChanged(value);
                }),
            Text("Teórico")
          ],
        )
      ],
    );
  }
}

class ChamadaScreenState extends State<NewChamadaScreen> {
  Container makePresenceRow(DocumentSnapshot document, int index) {
    var radioState = new RadioStateFull(new Presence(0, document));

    list.removeAt(index);
    list.insert(index, radioState);

    var container = new Expanded(
      child: radioState,
    );

    return new Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Row(children: <Widget>[
          new Expanded(
            child: new Text(
              document.data['firstName'] + " " + document.data['lastName'],
              textAlign: TextAlign.start,
            ),
          ),
          container
        ]));
  }

  Container makeTypeRow() {
    var radioState = new TypeRadioStateFull();

    var container = Row(
      children: <Widget>[radioState],
    );

    return new Container(child: container);
  }

  Container makeHeaderRow() {
    return new Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text("Atleta")),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text("P"),
                padding: EdgeInsets.only(right: 20.0),
              ),
              Text("J"),
              Container(
                child: Text("F"),
                padding: EdgeInsets.only(left: 20.0),
              ),
            ],
          )),
        ],
      ),
    );
  }

  DateTime _fromDate = new DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);

  @override
  Widget build(BuildContext context) {

    var enDatesFuture = initializeDateFormatting('pt_BR', null);
    Future.wait([enDatesFuture]);

    return Scaffold(
        appBar: AppBar(
          title: Text("Nova Chamada"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.check, size: 24.0),
                onPressed: () {
                  saveChamada();
                })
          ],
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: DateTimePicker(
                    labelText: 'Data',
                    selectedDate: _fromDate,
                    selectedTime: _fromTime,
                    selectDate: (DateTime date) {
                      setState(() {
                        _fromDate = date;
                      });
                    },
                    selectTime: (TimeOfDay time) {
                      setState(() {
                        _fromTime = time;
                      });
                    },
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Local"),
                  ),
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                ),
                makeTypeRow(),
                makeHeaderRow()
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection('atletas').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');

                    initList(snapshot);

                    return new ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) => _buildListItem(
                            context, snapshot.data.documents[index], index));
                  }),
            ),
          ],
        ));
  }

  void saveChamada() async {
    var docRef = await Firestore.instance
        .collection('chamada')
        .add({"date": "03/07/2018", "local": "Parque Barigui"});

    Firestore.instance.collection('presenca').add({
      "userId": list.first._initialState.documentSnapshot['atletaID'],
      "name": list.first._initialState.documentSnapshot['firstName'],
      "idChamada": docRef.documentID
    });
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot document, int index) {
    return makePresenceRow(document, index);
  }

  void buildPresence(RadioStateFull element) {
    element._initialState.documentSnapshot;
    element._initialState.nameComp;
  }

  void initList(AsyncSnapshot snapshot) {
    for (int x = 0; x < snapshot.data.documents.length; x++) {
      list.add(new RadioStateFull(new Presence(0, snapshot.data.documents[x])));
    }
  }
}
