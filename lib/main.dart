import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:team_management/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_management/chamadas_screen.dart';
import 'dart:async';
import 'package:team_management/my_navigator.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomePage(),
//  "/intro": (BuildContext context) => Login(),
};

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
      home: _handleCurrentScreen(),
      routes: routes,
    );
  }
}

Widget _handleCurrentScreen() {
  return new SplashScreen();
//  return new StreamBuilder<FirebaseUser>(
//      stream: FirebaseAuth.instance.onAuthStateChanged,
//      builder: (BuildContext context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return new SplashScreen();
//        } else {
//          if (snapshot.hasData) {
//            return new HomePage();
//          }
//
//          sleep(Duration(seconds: 10));
//
//          return new HomePage();
////          return new LoginScreen();
//        }
////      return new SplashScreen();
//      });
}

class SplashScreen extends StatefulWidget {

  @override
  SplashState createState()  => SplashState();
}

class SplashState extends State<SplashScreen>{



  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Color(0xFFFAFAFA),
        child: Image(image: AssetImage('assets/logo.png')));
  }

  @override
  void initState() {

    var stream = StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new SplashScreen();
        } else {
          if (snapshot.hasData) {
            return new HomePage();
          }

          sleep(Duration(seconds: 10));

          return new HomePage();
//          return new LoginScreen();
        }
//      return new SplashScreen();
      });

    stream.stream;

    Timer(Duration(seconds: 2), () => MyNavigator.goToHome(context));
  }

}
