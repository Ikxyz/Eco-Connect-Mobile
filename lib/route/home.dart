import 'dart:async';
import 'package:eco_connect/components/Chat.dart';
import 'package:eco_connect/components/notification.dart';
import 'package:eco_connect/components/profile.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_connect/model/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:eco_connect/components/componets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/nav_bar.dart';
import 'package:eco_connect/components/agent_list.dart';
import 'package:eco_connect/components/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final sdm = Firestore.instance
    .settings(timestampsInSnapshotsEnabled: true, persistenceEnabled: true);

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SharedPreferences _sharedPreferences;

  DataModel _model;
  int mIndex = 0;
  Timer countDown;
  int _numbersOfNewNotification = 0;
  _HomeState() {
    SharedPreferences.getInstance().then((_shared) {
      _sharedPreferences = _shared;
      setIndex(_shared.getInt('setCurrentHomePage'));
    });
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _model = DataModel(context);
    _model.auth.currentUser().then((user) {
      if (user != null)
        _model.db
            .collection('profile')
            .document(user.uid)
            .collection('inbox')
            .where('status', isEqualTo: false)
            .orderBy('time')
            .limit(30)
            .snapshots()
            .listen((snapShot) {
          _numbersOfNewNotification = 0;
          snapShot.documents.map((doc) {
            setState(() {
              if (doc.data['status'] == false) _numbersOfNewNotification += 1;
            });
          }).toList();
        });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int setIndex(int val) {
    if (val == null) return mIndex = 0;
    setState(() {
      mIndex = val;
    });
    _sharedPreferences.setInt('setCurrentHomePage', val);
    return val;
  }

  @override
  Widget build(BuildContext context) {
    _model = DataModel(context);

    DesignTemplate _style = DesignTemplate(context);
    List<Widget> _pages = <Widget>[
      AgentListComponet(),
      NotificationComponet(),
      ChatComponet(),
      ProfileComponet(),
    ];

    return ScopedModel<DataModel>(
        model: DataModel(context),
        child:
            ScopedModelDescendant<DataModel>(builder: (context, child, model) {
          return Scaffold(
            key: _model.homeScaffoldState,
            body: Container(
              height: _style.getheigth(),
              width: _style.getwidth(),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "CAC",
                              style: _style.mTitleStyle(color: Colors.black),
                            ),
                            Text(
                              "OA",
                              style: _style.mTitleStyle(),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 10,
                              ),
                            ),
                            FlatButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  _numbersOfNewNotification > 0
                                      ? Icons.notifications_active
                                      : Icons.notifications,
                                  color: _numbersOfNewNotification > 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.black,
                                ),
                                label: Text(
                                    "${_numbersOfNewNotification}${_numbersOfNewNotification > 1 ? ' Notifications' : ' Notification'}")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: _style.getheigth() - 160,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[_pages[mIndex]],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBarComponet((val) {
              mIndex = val;
              setIndex(val);
              //  print('hey you $val');
            }, mIndex),
          );
        }));
  }
}
