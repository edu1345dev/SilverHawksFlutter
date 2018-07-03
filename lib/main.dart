import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Baby Names',
      home: const MyHomePage(title: 'Silverhawks'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return new GridTile(
        key: new ValueKey(document.documentID),
        child: new Stack(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(2.0),
              child: new InkResponse(
                child: new CachedNetworkImage(imageUrl: document['picURL']),
                enableFeedback: true,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondScreen())),
              ),
            ),
            new Positioned(
              child: new Container(
                alignment: Alignment.center,
                child: new Text(
                  "#" + document['number'],
                  textAlign: TextAlign.center,
                  style:
                      new TextStyle(color: Color(0xFFFFFFFF), fontSize: 24.0),
                ),
                color: Color.fromARGB(100, 0, 0, 0),
                height: 50.0,
              ),
              bottom: 0.0,
              top: 75.0,
              right: 0.0,
              left: 0.0,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('atletas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new GridView.builder(
                itemCount: snapshot.data.documents.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]));
          }),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class RadioStateFull extends StatefulWidget {
  final Presence _initialState;

  RadioStateFull(Presence presence)
      : _initialState = presence,
        super(key: new ObjectKey(presence));

  @override
  RadioState createState() => new RadioState(_initialState);
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

class MyAppState extends State<SecondScreen> {
  List<RadioStateFull> list = new List();

  Container makePresenceRow(DocumentSnapshot document, int index) {
    var radioState = new RadioStateFull(new Presence(0, document));

    list.removeAt(index);
    list.insert(index, radioState);

    var container = new Expanded(
        child: Row(
      children: <Widget>[radioState],
    ));

    return new Container(
        child: new Row(children: <Widget>[
      new Expanded(
          child: new Text(
        document.data['firstName'] + " " + document.data['lastName'],
        textAlign: TextAlign.start,
      )),
      container
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Chamada"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.check, size: 24.0),
              onPressed: () {
                _saveChamada();
              })
        ],
      ),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('atletas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');

            initList(snapshot);

            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildListItem(
                    context, snapshot.data.documents[index], index));
          }),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot document, int index) {
    return makePresenceRow(document, index);
  }

  void _saveChamada() async{
    var docRef = await Firestore.instance.collection('chamada').add({
      "date": "03/07/2018",
      "local": "Parque Barigui"
    });


    Firestore.instance.collection('presenca').add({
      "userId": list.first._initialState.documentSnapshot['atletaID'],
      "name": list.first._initialState.documentSnapshot['firstName'],
      "idChamada": docRef.documentID
    });
  }

  void buildPresence(RadioStateFull element) {
    element._initialState.documentSnapshot;
    element._initialState.nameComp;
  }

  void initList(AsyncSnapshot snapshot) {
    for (int x = 0; x < snapshot.data.documents.length; x++) {
      list.add(new RadioStateFull(
          new Presence(0, snapshot.data.documents[x])));
    }
  }
}
