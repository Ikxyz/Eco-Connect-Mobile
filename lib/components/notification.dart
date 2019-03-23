import 'package:eco_connect/model/data.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/classes/classes.dart';

class NotificationComponet extends StatefulWidget {
  @override
  _NotificationComponetState createState() => _NotificationComponetState();
}

class _NotificationComponetState extends State<NotificationComponet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

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
      child: ScopedModelDescendant<DataModel>(builder: (context, child, model) {
        return Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            height: _style.getheigth() - 160,
            width: _style.getwidth(),
            child: model.userProfile != null
                ? StreamBuilder(
                    stream: _model.db
                        .collection('profile')
                        .document(model.userProfile.uid)
                        .collection('inbox')
                        .where('status', isEqualTo: false)
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
                      if (snapShot.hasData) {
                        if (snapShot.data.documents.length < 0) {
                          return Container(
                            height: _style.getheigth(val: 70),
                            width: _style.getwidth(),
                            child: Column(
                              children: <Widget>[
                                Image.asset('assets/image/noMsg.png'),
                                Text(' You don\'t have any alerts')
                              ],
                            ),
                          );
                        }

                        return ListView(
                          physics: BouncingScrollPhysics(),
                          children:
                              snapShot.data.documentChanges.map((docSnapshot) {
                            final NOTIFICATION data =
                                NOTIFICATION.object(docSnapshot.document.data);
                            if (model.userProfile != null)
                              _model.db
                                  .collection('profile')
                                  .document(model.userProfile.uid)
                                  .collection('inbox')
                                  .document(docSnapshot.document.documentID)
                                  .updateData({'status': true});

                            return ListTile(
                              title: Text(data.title),
                              subtitle: Text(
                                  '${data.desc} \n\n${_style.timeAgo(data.time)}'),
                              leading: Icon(
                                Icons.info,
                                color: data.type == 'info'
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                              contentPadding: EdgeInsets.all(0),
                            );
                          }).toList(),
                        );
                      } else if (snapShot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          height: _style.getheigth(val: 70),
                          width: _style.getwidth(),
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/image/noMsg.png'),
                              Text(' You don\'t have any alerts')
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          height: _style.getheigth(val: 70),
                          width: _style.getwidth(),
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/image/noMsg.png'),
                              Text(' You don\'t have any alerts')
                            ],
                          ),
                        );
                      }
                    },
                  )
                : Container(
                    height: _style.getheigth(val: 70),
                    width: _style.getwidth(),
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/image/noMsg.png'),
                        Text(' You don\'t have any alerts')
                      ],
                    ),
                  ));
      }),
    );
  }
}
