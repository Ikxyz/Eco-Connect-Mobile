import 'package:flutter/material.dart';
import 'package:eco_connect/model/data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:eco_connect/classes/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_connect/components/Chat.dart';

class AgentListComponet extends StatefulWidget {
  @override
  _AgentListComponetState createState() => _AgentListComponetState();
}

class _AgentListComponetState extends State<AgentListComponet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  DataModel _model;
  UsersProfile _usersProfile;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _model = DataModel(context);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DesignTemplate _template = DesignTemplate(context);

    return ScopedModel<DataModel>(
      model: _model,
      child: ScopedModelDescendant<DataModel>(builder: (context, child, model) {
        return StreamBuilder(
          stream: _model.db
              .collection('profile')
              .where('isAgent', isEqualTo: true)
              .limit(30)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Wrap(
                children: snapshot.data.documentChanges.map((docSnapshot) {
                  UsersProfile _xUser =
                      new UsersProfile.object(docSnapshot.document.data);
                  if (model.userProfile == null) return SizedBox();
                  if (_xUser.uid == model.userProfile.uid) return SizedBox();
                  return _template.getMinProfileCard(_xUser, () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MainChat(model.userProfile, _xUser)));
                  });
                }).toList(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            } else {
              return Center(child: Text("No agent avaliable at the moment"));
            }
          },
        );
      }),
    );
  }
}
