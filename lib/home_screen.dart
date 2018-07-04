import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_management/atletas_screen.dart';
import 'package:team_management/chamadas_screen.dart';
import 'package:team_management/date_time_picker.dart';
import 'package:team_management/new_chamada_screen.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Atletas", Icons.directions_run),
    new DrawerItem("Chamada", Icons.assignment),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new AtletasScreen();
      case 1:
        return new ChamadasScreen();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        actions: widget.drawerItems[_selectedDrawerIndex].title == "Chamada"
            ? <Widget>[
                new IconButton(
                    icon: new Icon(Icons.assignment, size: 24.0),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => NewChamadaScreen())),)
              ]
            : null,
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: Text("Amanda Lúcia"),
                accountEmail: Text("alc.ramos@yahoo.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      "https://firebasestorage.googleapis.com/v0/b/silverhawksapp-1ad20.appspot.com/o/FotosAtletas%2FAmandaRamos.jpg?alt=media&token=8b8792b0-3783-4749-b720-ced93d14f290"),
                )),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
