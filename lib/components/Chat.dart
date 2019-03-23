import 'package:eco_connect/model/data.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_connect/classes/classes.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatComponet extends StatefulWidget {
  @override
  _ChatComponetState createState() => _ChatComponetState();
}

class _ChatComponetState extends State<ChatComponet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SharedPreferences _sharedPreferences;
  Widget _noNeContact(width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(
          Icons.message,
          color: Colors.grey.shade500.withOpacity(0.5),
          size: MediaQuery.of(context).size.width * 0.6,
        ),
        Text(
          'No agent in contact yet \n go home and select an agent to chat with',
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  _ChatComponetState() {}

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
    DesignTemplate _style = DesignTemplate(context);
    DataModel _model = DataModel(context);

    return ScopedModel<DataModel>(
      model: _model,
      child: Container(
        width: _style.getwidth(),
        height: _style.getheigth(val: 80),
        child:
            ScopedModelDescendant<DataModel>(builder: (context, child, model) {
          if (model.userProfile == null)
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            );
          return StreamBuilder(
              stream: _model.db
                  .collection('profile')
                  .document(model.userProfile.uid)
                  .collection('chat')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
                if (snapShot == null) return _noNeContact(_style.getwidth());
                if (snapShot.hasData) {
                  if (snapShot.data.documents.length == 0) {
                    return _noNeContact(_style.getwidth());
                  }
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    children: snapShot.data.documents.map((docSnapshot) {
                      UsersProfile contact;
                      //  print(docSnapshot.data);
                      return FutureBuilder(
                          future: _model.db
                              .collection('profile')
                              .document(docSnapshot.documentID)
                              .get(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> contactSnapshot) {
                            if (contactSnapshot.hasData) {
                              contact = UsersProfile.object(
                                  contactSnapshot.data.data);

                              return ListTile(
                                title: Text(
                                    '${contact.lastName} ${contact.firstName}'),
                                subtitle: Container(
                                  height: 40,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${docSnapshot.data['msg']}',
                                        maxLines: 1,
                                      ),
                                      Text(
                                          '${_style.timeAgo(docSnapshot.data['time'])}')
                                    ],
                                  ),
                                ),
                                leading: Container(
                                  child: _style.getAvatar(contact, radius: 50),
                                  width: _style.getwidth(val: 20),
                                ),
                                contentPadding: EdgeInsets.all(10),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MainChat(
                                          model.userProfile, contact)));
                                },
                              );
                            } else {
                              return SizedBox();
                            }
                          });
                    }).toList(),
                  );
                } else {
                  return Container(
                    height: _style.getheigth(val: 70),
                    width: _style.getwidth(),
                    child: _noNeContact(_style.getwidth()),
                  );
                }
              });
        }),
      ),
    );
  }
}

class MainChat extends StatefulWidget {
  UsersProfile _personOne;
  UsersProfile _personTwo;

  MainChat(this._personOne, this._personTwo);

  @override
  _MainChatState createState() => _MainChatState(_personOne, _personTwo);
}

class _MainChatState extends State<MainChat>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  UsersProfile _personOne;
  UsersProfile _personTwo;
  GlobalKey<FormState> _chatFormKey = GlobalKey<FormState>();
  TextEditingController _msgBox = TextEditingController();
  _MainChatState(this._personOne, this._personTwo);
  DataModel _model;
  DesignTemplate _style;
  Map<String, dynamic> msg;
  ScrollController _strollCOntroller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    super.initState();

    msg = Map.of(jsonMessage(
        to: _personTwo.uid,
        from: _personOne.uid,
        canRead: true,
        id: '',
        status: 'sent',
        time: DateTime.now().toUtc(),
        type: 'text/text'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMsg() {
    FormState formState = _chatFormKey.currentState;

    formState.save();
    if (msg['msg'] == null) return;
    var nodeOne = _model.db
        .collection('profile')
        .document(_personOne.uid)
        .collection('chat')
        .document(_personTwo.uid)
        .collection('messages');
    var nodeTwo = _model.db
        .collection('profile')
        .document(_personTwo.uid)
        .collection('chat')
        .document(_personOne.uid)
        .collection('messages');
    var nodeOneLastMsg = _model.db
        .collection('profile')
        .document(_personOne.uid)
        .collection('chat')
        .document(_personTwo.uid);
    var nodeTwoLastMsg = _model.db
        .collection('profile')
        .document(_personTwo.uid)
        .collection('chat')
        .document(_personOne.uid);
    var nodeTwoNotification = _model.db
        .collection('profile')
        .document(_personTwo.uid)
        .collection('inbox')
        .document(_personOne.uid);
    Map<String, dynamic> notification = Map.of(jsonNotifications(
        title: '${_personOne.lastName} sent your a message',
        desc: msg['type'] == 'text/text' ? msg['msg'] : '',
        status: false,
        time: DateTime.now().toUtc(),
        type: 'info'));
    var bat = _model.db.batch();
    var docId = _style.getID();
    msg['id'] = docId;
    bat.setData(nodeOne.document(docId), msg);
    bat.setData(nodeTwo.document(docId), msg);
    bat.setData(nodeOneLastMsg, msg);
    bat.setData(nodeTwoLastMsg, msg);
    bat.setData(nodeTwoNotification, notification);
    bat.commit().then((doc) {
      _msgBox.clear();
      msg = Map.of(jsonMessage(
          to: _personTwo.uid,
          from: _personOne.uid,
          canRead: true,
          id: '',
          msg: null,
          status: 'sent',
          time: DateTime.now().toUtc(),
          type: 'text/text'));
      _strollCOntroller.jumpTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    _style = DesignTemplate(context);
    _model = DataModel(context);
    return ScopedModel<DataModel>(
      model: DataModel(context),
      child: Scaffold(
        body: ScopedModelDescendant<DataModel>(
          builder: (context, child, model) {
            return Container(
              height: _style.getheigth(),
              child: Column(
                children: <Widget>[
                  Container(
                    width: _style.getwidth(),
                    child: ListTile(
                      leading: Container(
                        child: _style.getAvatar(_personTwo, radius: 50),
                        width: _style.getwidth(val: 20),
                      ),
                      title: Text(
                          '${_personTwo.lastName} ${_personTwo.firstName}'),
                      subtitle: Text(_style.timeAgo(_personTwo.online)),
                    ),
                    padding: EdgeInsets.only(top: 30),
                  ),
                  Flexible(
                    child: StreamBuilder(
                        stream: _model.db
                            .collection('profile')
                            .document(_personOne.uid)
                            .collection('chat')
                            .document(_personTwo.uid)
                            .collection('messages')
                            .orderBy('time')
                            .limit(30)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
                              physics: BouncingScrollPhysics(),
                              controller: _strollCOntroller,
                              children: snapshot.data.documentChanges
                                  .map((docSnapshot) {
                                if (docSnapshot.document.exists) {
                                  return _style.chatBubble(
                                      MESSAGE.object(docSnapshot.document.data),
                                      _personOne,
                                      _personTwo);
                                } else {
                                  return Center(
                                    child: Text('No messages'),
                                  );
                                }
                              }).toList(),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                              ),
                            );
                          }
                        }),
                  ),
                  Container(
                    width: _style.getwidth(),
                    child: Form(
                      key: _chatFormKey,
                      child: Row(
                        children: <Widget>[
//                          IconButton(
//                            onPressed: () {},
//                            icon: Icon(Icons.insert_drive_file),
//                            color: Theme.of(context).primaryColor,
//                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: _style.mTextFormField(context,
                                  autovalidate: false, onSaved: (val) {
                            if (val.toString().trim().isNotEmpty)
                              msg['msg'] = val;
                          },
                                  autocorrect: true,
                                  errorText: '',
                                  keyboardType: TextInputType.multiline,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  textInputAction: TextInputAction.none,
                                  hintText: 'Type here ...',
                                  controller: _msgBox,
                                  labelText: 'Message')),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: _sendMsg,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
