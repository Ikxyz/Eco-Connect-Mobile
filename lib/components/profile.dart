import 'package:eco_connect/model/data.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileComponet extends StatefulWidget {
  @override
  _ProfileComponetState createState() => _ProfileComponetState();
}

class _ProfileComponetState extends State<ProfileComponet>
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
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          height: _style.getheigth(val: 60),
          width: _style.getwidth(),
          child: model.userProfile != null
              ? ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: 200,
                              child: CircleAvatar(
                                child: Icon(Icons.account_circle),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                '${_style.getValue(model.userProfile.lastName)} ${_style.getValue(model.userProfile.firstName)}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('${_style.getValue(model.userProfile.tel)}'),
                          ],
                        ),
                      ),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text('Telphone: '),
                                subtitle: Text(model.userProfile.tel == null
                                    ? 'not set'
                                    : model.userProfile.tel),
                                contentPadding: EdgeInsets.all(0),
                              ),
                              ListTile(
                                title: Text('Zip code:'),
                                subtitle: Text(_style.getValue(
                                    model.userProfile.tel,
                                    isNull: 'not set')),
                                contentPadding: EdgeInsets.all(0),
                              ),
                              ListTile(
                                title: Text('Address'),
                                subtitle: Text(_style.getValue(
                                    model.userProfile.address,
                                    isNull: 'not set')),
                                contentPadding: EdgeInsets.all(0),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text('City: '),
                                subtitle: Text(_style.getValue(
                                    model.userProfile.city,
                                    isNull: 'not set')),
                                contentPadding: EdgeInsets.all(0),
                              ),
                              ListTile(
                                title: Text('State:'),
                                subtitle: Text(_style.getValue(
                                    model.userProfile.state,
                                    isNull: 'not set')),
                                contentPadding: EdgeInsets.all(0),
                              ),
                              ListTile(
                                title: Text('Country'),
                                subtitle: Text(_style.getValue(
                                    model.userProfile.country,
                                    isNull: 'not set')),
                                contentPadding: EdgeInsets.all(0),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
//                              OutlineButton.icon(
//                                  shape: StadiumBorder(),
//                                  textColor: Theme.of(context).primaryColor,
//                                  onPressed: () {},
//                                  icon: Icon(Icons.edit),
//                                  label: Text("Update Profile")),
//                              SizedBox(
//                                height: 10,
//                              ),
//                              OutlineButton.icon(
//                                  shape: StadiumBorder(),
//                                  textColor: Colors.blue,
//                                  onPressed: () {},
//                                  icon: Icon(Icons.lock),
//                                  label: Text("Change Password")),
                              SizedBox(
                                height: 10,
                              ),
                              OutlineButton.icon(
                                  shape: StadiumBorder(),
                                  textColor: Colors.red,
                                  onPressed: () {
                                    _model.auth.signOut();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('login',
                                            (Route<dynamic> route) => false);
                                  },
                                  icon: Icon(Icons.arrow_forward),
                                  label: Text("Log Out")),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
        );
      }),
    );
  }
}
