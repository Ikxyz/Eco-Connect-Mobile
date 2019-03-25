import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:eco_connect/route/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_connect/route/setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:eco_connect/model/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:firebase_analytics/observer.dart';

void main() async {
  SharedPreferences _localdb = await SharedPreferences.getInstance();
  FirebaseUser _user = await FirebaseAuth.instance.currentUser();

  Widget _home;
  bool _firstRun = _localdb.getBool('init');
  int lastPage = _localdb.getInt('setCurrentHomePage');
  print('First lunch ${_firstRun}');
  print('Currentg Logged in user ${_user}');

  if (_firstRun == null) {
    _firstRun = true;
    _home = new Setup();
  } else if (_firstRun == false) {
    if (_user == null)
      _home = new Setup();
    else
      _home = new Home();
  } else {
    _home = new Setup();
  }

  return runApp(new MyApp(
    _firstRun,
    _home,
    user: _user,
    lastPage: _localdb,
  ));
}

class MyApp extends StatelessWidget {
  bool first_run;
  Widget home;
  FirebaseUser user;
  int lastPage;
  MaterialColor _myColor = MaterialColor(0xff403C55, <int, Color>{
    50: Color.fromRGBO(64, 60, 85, .1),
    100: Color.fromRGBO(64, 60, 85, .2),
    200: Color.fromRGBO(64, 60, 85, .3),
    300: Color.fromRGBO(64, 60, 85, .4),
    400: Color.fromRGBO(64, 60, 85, .5),
    500: Color.fromRGBO(64, 60, 85, .6),
    600: Color.fromRGBO(64, 60, 85, .7),
    700: Color.fromRGBO(64, 60, 85, .8),
    800: Color.fromRGBO(64, 60, 85, .9),
    900: Color.fromRGBO(64, 60, 85, 1),
  });
  @override
  Widget build(BuildContext context) {
    DataModel _model = new DataModel(context);
    FirebaseAnalytics analytics = FirebaseAnalytics();

    if (user != null) _model.loadUser(user, context);

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAC Online Agent',
      routes: <String, WidgetBuilder>{
        "home": (BuildContext context) => Home(),
        "login": (BuildContext context) {
          _model.set_setup_page_index(1);
          return Setup();
        },
        "registerMember": (BuildContext context) {
          _model.set_setup_page_index(2);
          return Setup();
        },
        "registerAgent": (BuildContext context) {
          _model.set_setup_page_index(3);
          return Setup();
        },
      },
      navigatorObservers: <NavigatorObserver>[
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: new ThemeData(
        primaryColor: _myColor,
        primarySwatch: _myColor,
        fontFamily: 'Raleway',
        brightness: Brightness.light,
        accentColor: _myColor.shade100,
        accentColorBrightness: Brightness.dark,
      ),
      home: home,
    );
  }

  MyApp(this.first_run, this.home, {user, lastPage}) {}
}
