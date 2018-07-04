import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChamadasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('chamada').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildListItem(
                    context, snapshot.data.documents[index], index));
          }),
    );
  }

  _buildListItem(BuildContext context, document, int index) {
    return new Card(
        elevation: 2.0,
        child: Container(
          height: 150.0,
          padding: EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      document['date'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    )),
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text(
                            document['local'],
                            textAlign: TextAlign.start,
                          )),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text(
                            document['tipo'],
                            textAlign: TextAlign.end,
                          )),
                    ),
                  ],
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Text(
                                  "Presenças",
                                ),
                                Text(
                                  document['totalPresencas'].toString(),
                                )
                              ],
                            )),
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: <Widget>[
                            Text(
                              "Justificativas",
                            ),
                            Text(
                              document['totalJustificativas'].toString(),
                            )
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: <Widget>[
                            Text(
                              "Faltas",
                            ),
                            Text(
                              document['totalFaltas'].toString(),
                            ),
                          ],
                        ))
                      ],
                    )),
                flex: 2,
              )
            ],
          ),
        ));
  }
}
