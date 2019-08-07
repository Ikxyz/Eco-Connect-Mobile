import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/classes/classes.dart';
import 'package:eco_connect/model/data.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DashBoardComponet extends StatefulWidget {
  GlobalKey<ScaffoldState> _state = GlobalKey<ScaffoldState>();
  @override
  _DashBoardComponetState createState() => _DashBoardComponetState(_state);

  DashBoardComponet(this._state);
}

class _DashBoardComponetState extends State<DashBoardComponet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalKey<ScaffoldState> _scaffoldState;
  DataModel _model;
  UsersProfile _usersProfile;
  PickUpRequest _pickUpRequest;
  DesignTemplate _style;
  bool _isRequesting = false;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  _DashBoardComponetState(this._scaffoldState);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchAndUploadPassport(bool camera) async {
    setState(() {
      _isRequesting = true;
    });
    bool pending;
    var hasPending = await _model.db
        .collection('profile')
        .document(_usersProfile.uid)
        .collection('pickup')
        .where('isComplete', isEqualTo: false)
        .getDocuments();

    if (hasPending.documents.length > 0) {
      setState(() {
        _isRequesting = false;
      });
      return _style.showSnackBar(
          _scaffoldState, 'Sorry you have a pending pick up request');
    }

    _pickUpRequest = PickUpRequest.object(Map.from(jsonPickUpRequest()));

    File file = await _style.getImage(camera: camera);
    if (file == null) {
      _style.showSnackBar(_scaffoldState, 'Invalid Photo');
      setState(() {
        _isRequesting = false;
      });
    }
    print('Got file ${file.path}');
    String url = await _style.uploadFile(file, _style.getID(lenght: 28),
        location: 'pickup');
    if (url == null) {
      setState(() {
        _isRequesting = false;
      });
      return _style.showSnackBar(_scaffoldState, 'Invalid File');
    }
    print('This is the download Url $url');
    _pickUpRequest.url = url;
    _postPickUpRequest();
  }

  void _postPickUpRequest() {
    var bat = _model.db.batch();
    Map<String, dynamic> postData = Map.from(jsonPickUpRequest(
      uid: _usersProfile.uid,
      url: _pickUpRequest.url,
    ));
    Map<String, dynamic> postNotification = Map.from(jsonNotifications(
        type: 'info',
        time: DateTime.now().toUtc(),
        status: false,
        desc: 'Your request has been sent and is undergoing procesing',
        title: 'Pick Up Request Sent Sccuessfully'));
    String docId = _style.getID(lenght: 28);
    bat.setData(_model.db.collection('pickup').document(docId), postData);
    bat.setData(
        _model.db
            .collection('profile')
            .document(_usersProfile.uid)
            .collection('pickup')
            .document(docId),
        postData);
    bat.setData(
        _model.db
            .collection('profile')
            .document(_usersProfile.uid)
            .collection('inbox')
            .document(_style.getID(lenght: 16)),
        postNotification);
    bat.commit().then((res) {
      setState(() {
        _isRequesting = false;
      });
      _style.showSnackBar(_scaffoldState, 'Pick request sent');
    });
  }

  @override
  Widget build(BuildContext context) {
    _style = DesignTemplate(context);
    _model = DataModel(context);
    Widget _isMember(model) {
      return Container(
        height: _style.getheigth(val: 61),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              height: _style.getheigth(val: 30),
              width: _style.getwidth(),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      '# 0.00',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    radius: 60,
                  ),
                ),
                elevation: 10,
                shape: CircleBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: _style.getwidth(val: 10),
                  right: _style.getwidth(val: 10)),
              child: Visibility(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                visible: _isRequesting,
                replacement: FlatButton.icon(
                  onPressed: () {
                    _fetchAndUploadPassport(true);
                  },
                  icon: Icon(Icons.local_shipping),
                  label: Text(
                    'Request Pickup',
                    style: TextStyle(fontSize: 20),
                  ),
                  shape: StadiumBorder(),
                  textColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _usersProfile == null
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : StreamBuilder(
                    stream: _model.db
                        .collection('profile')
                        .document(_usersProfile.uid)
                        .collection('pickup')
                        .where('isComplete', isEqualTo: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapShot) {
                      if (snapShot.hasData) {
                        if (snapShot.data.documents.length == 0) {
                          return Container(
                            child: Center(
                              child: Text('No pending pick up'),
                            ),
                          );
                        }
                        return Column(
                          children:
                              snapShot.data.documentChanges.map((docSnapshaot) {
                            PickUpRequest doc = PickUpRequest.object(
                                Map.of(docSnapshaot.document.data));
                            DateTime reqTime = doc.requestTime;
                            String sec = '0:00:00';
                            return Container(
                              width: _style.getwidth(),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    child: CircleAvatar(
                                      child: Icon(Icons.account_circle),
                                    ),
                                  ),
                                  title: Text(
                                    'Current Pickup',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  subtitle: Text('Undergoing Processing'),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text('No pending pick up'),
                          ),
                        );
                      }
                    }),
          ],
        ),
      );
    } // isMember

    Widget _isAgent(model) {
      return Container(
        height: _style.getheigth(val: 61),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    radius: 40,
                  ),
                ),
                elevation: 10,
                shape: CircleBorder(),
              ),
              title: Text('Pending pick up request'),
              subtitle: Text('Total numbers waste ready for pick up'),
            ),
            ListTile(
              leading: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    radius: 40,
                  ),
                ),
                elevation: 10,
                shape: CircleBorder(),
              ),
              title: Text('Failed pick up request'),
              subtitle: Text('Total numbers waste ready for pick up'),
            ),
            ListTile(
              leading: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    radius: 40,
                  ),
                ),
                elevation: 10,
                shape: CircleBorder(),
              ),
              title: Text('Avaliable pick up'),
              subtitle: Text(
                  'Total numbers avaliable waste close to you for pick up'),
            ),
            ListTile(
              leading: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    radius: 40,
                  ),
                ),
                elevation: 10,
                shape: CircleBorder(),
              ),
              title: Text('Sccessfully pick up'),
              subtitle: Text('Total numbers sccussfull pick up'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: _style.getwidth(val: 10),
                  right: _style.getwidth(val: 10)),
              child: Visibility(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                visible: _isRequesting,
                replacement: FlatButton.icon(
                  onPressed: () {
                    _fetchAndUploadPassport(true);
                  },
                  icon: Icon(Icons.delete_sweep),
                  label: Text(
                    'Accept Waste',
                    style: TextStyle(fontSize: 20),
                  ),
                  shape: StadiumBorder(),
                  textColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    } // is Agent

    Widget _isOrg() {}
    return ScopedModel<DataModel>(
      model: _model,
      child: ScopedModelDescendant<DataModel>(builder: (context, child, model) {
        _usersProfile = model.userProfile;
        if (_usersProfile == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (_usersProfile.isMember) {
          return _isMember(model);
        }
        if (_usersProfile.isAgent) {
          return _isAgent(model);
        }
      }),
    );
  }
}
