import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_management/new_chamada_screen.dart';

class AtletasScreen extends StatelessWidget {
  const AtletasScreen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: const MyHomePage(title: 'Silverhawks'),
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
    final Orientation orientation = MediaQuery.of(context).orientation;

    return new Scaffold(
      body: new StreamBuilder(
          stream: Firestore.instance.collection('atletas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new GridView.builder(
                itemCount: snapshot.data.documents.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5),
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]));
          }),
    );
  }
}