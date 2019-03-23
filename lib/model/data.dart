import 'package:eco_connect/model/post.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:eco_connect/classes/classes.dart';

class DataModel extends Model {
  FirebaseAuth auth = FirebaseAuth.instance;

  BuildContext xContext;
  DataModel(this.xContext) {
    // init();
    auth.currentUser().asStream().listen((user) {
      if (user != null) {
        this.loadUser(user, xContext);
        return;
      }
      if (ModalRoute.of(xContext) == null) return;
      _user = user;
      print(ModalRoute.of(xContext).settings.name);

      if (ModalRoute.of(xContext).settings.name != 'login')
        Navigator.of(xContext)
            .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
    });
  }
  Firestore db = Firestore.instance;
  int _setupPageIndex = 0;
  int _numbersOfNewNotification = 0;
  FirebaseUser _user;
  UsersProfile _usersProfile;
  Map<String, dynamic> _usersProfileMap;

  int get setup_page_index => _setupPageIndex;
  int get numbersOfNewNotification => _numbersOfNewNotification;

  UsersProfile get userProfile => _usersProfile;
  Map<String, dynamic> get usersProfileMap => _usersProfileMap;
  FirebaseUser get currentUser => _user;
  GlobalKey<ScaffoldState> homeScaffoldState = GlobalKey<ScaffoldState>();
  List<GlobalKey> listOfuniqueKey = <GlobalKey>[];
  void set_setup_page_index(int value) {
    _setupPageIndex = value;
    notifyListeners();
  }

  void init() async {}

  get getUniqueKeyFromList => listOfuniqueKey.last;

  void setCurrentUser(BuildContext context) async {
    _user = await auth.currentUser();
    print(_user);
    if (_user == null)
      Navigator.of(context)
          .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
    notifyListeners();
  }

  void setUserProfile(context) async {
    setCurrentUser(context);
    print('this was called');
    if (_user == null) return;
    DocumentSnapshot _doc =
        await db.collection('profile').document(_user.uid).get();
    _usersProfile = UsersProfile.object(_doc.data);
    print(_usersProfile);
    notifyListeners();
  }

  void loadUser(FirebaseUser mUser, context) async {
    if (mUser == null) return;
    var doc = await db.collection('profile').document(mUser.uid).get();

    if (doc.exists == false) return;
    _usersProfile = UsersProfile.object(doc.data);
    _usersProfileMap = doc.data;
    notifyListeners();
  }
}
