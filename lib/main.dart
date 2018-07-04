import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:team_management/home_screen.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes =
  true; // ignore: deprecated_member_use
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NavigationDrawer Demo',
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new HomePage(),
    );
  }
}




