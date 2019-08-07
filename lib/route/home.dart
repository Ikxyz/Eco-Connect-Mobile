import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/classes/custom-clip.dart';
import 'package:eco_connect/components/bottom_nav_bar.dart';
import 'package:eco_connect/components/dashboard.dart';
import 'package:eco_connect/components/notification.dart';
import 'package:eco_connect/components/pick_up_list.dart';
import 'package:eco_connect/components/profile.dart';
import 'package:eco_connect/model/data.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      _shared.setBool('init', false);
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
      DashBoardComponet(_model.homeScaffoldState),
      NotificationComponet(),
      PickUpListComponet(_model.homeScaffoldState),
      ProfileComponet(),
    ];

    return ScopedModel<DataModel>(
        model: DataModel(context),
        child:
            ScopedModelDescendant<DataModel>(builder: (context, child, model) {
          return Scaffold(
            key: _model.homeScaffoldState,
            body: Container(
              height: _style.getheigth(val: 95),
              width: _style.getwidth(),
              child: Column(
                children: <Widget>[
                  ClipPath(
                    clipper: CustomClip(),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: _style.getheigth(val: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Eco-",
                                style: _style.mTitleStyle(color: Colors.white),
                              ),
                              Text(
                                "Connect",
                                style: _style.mTitleStyle(color: Colors.green),
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
                                        : Colors.white,
                                  ),
                                  label: Text(
                                    "${_numbersOfNewNotification}${_numbersOfNewNotification > 1 ? ' Notifications' : ' Notification'}",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                          Container(
                            width: _style.getwidth(),
                            child: model.userProfile == null
                                ? SizedBox()
                                : model.userProfile.isAgent
                                    ? Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.person_pin,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Agent Accont',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    : SizedBox(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: _style.getheigth(val: 61),
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
