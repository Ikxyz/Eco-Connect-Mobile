import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_countdown/flutter_countdown.dart';
import 'package:flutter/material.dart';
import 'package:eco_connect/model/data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:eco_connect/classes/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/classes/custom-clip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PickUpListComponet extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldState;
  @override
  _PickUpListComponetState createState() =>
      _PickUpListComponetState(_scaffoldState);

  PickUpListComponet(this._scaffoldState);
}

class _PickUpListComponetState extends State<PickUpListComponet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalKey<ScaffoldState> _scaffoldState;
  DataModel _model;
  UsersProfile _usersProfile;
  PickUpRequest _pickUpRequest;
  DesignTemplate _style;

  _PickUpListComponetState(this._scaffoldState);

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _style = DesignTemplate(context);
    _model = DataModel(context);

    return ScopedModel<DataModel>(
      model: _model,
      child: ScopedModelDescendant<DataModel>(builder: (context, child, model) {
        _usersProfile = model.userProfile;
        return Container(
          height: _style.getheigth(val: 61),
          child: ListView(
            padding: EdgeInsets.only(left: 10, right: 10),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
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
                            children: snapShot.data.documentChanges
                                .map((docSnapshaot) {
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
                                      width: 100,
                                      child: GestureDetector(
                                        onTap: () {
                                          return showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: CachedNetworkImage(
                                                    imageUrl: doc.url,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) {
                                                      return CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      );
                                                    },
                                                  ),
                                                );
                                              });
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: doc.url,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      'Pick up agent: ',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    subtitle: Text(
                                        '\nPick up time: \n\nWegith:   \n\nWaste type:   \n\nWorth:   \n\nProcess time:   '),
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
      }),
    );
  }
}
