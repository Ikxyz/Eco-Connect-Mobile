import 'dart:ui';
import 'package:eco_connect/model/data.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_connect/classes/classes.dart';

class UpdataProfileComponet extends StatefulWidget {
  @override
  _UpdataProfileComponetState createState() => _UpdataProfileComponetState();
}

class _UpdataProfileComponetState extends State<UpdataProfileComponet> {
  GlobalKey<FormState> _profileUpdateKey = GlobalKey<FormState>();
  Map<String, dynamic> _userProfile =
      new Map<String, dynamic>.from(jsonUserProfile());
  DataModel _model;
  bool _isUpdateing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _model = DataModel(context);
  }

  @override
  Widget build(BuildContext context) {
    DesignTemplate _style = DesignTemplate(context);
    Future _updateProfileFuntion(String uid) {
      _userProfile['uid'] = uid;
      _userProfile['online'] = DateTime.now().toUtc();
      print(_userProfile);
      return _model.db
          .collection('profile')
          .document(uid)
          .setData(_userProfile)
          .then((res) {
        _model.setCurrentUser(context);
        _model.setUserProfile(context);
        //Notity User on successfull account opening
        print('Account Opened Successfully');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
      }).catchError((err) {
        setState(() {
          _isUpdateing = false;
        });
        _style.showDialogBox(
            context: context,
            title: "Error creating account",
            desc: "",
            buttonText: "Try again",
            callBack: () {
              _updateProfileFuntion(uid);
            });
      });
    }

    return Scaffold(
        body: ListView(
      children: <Widget>[
        //#region************************** Register page for Non - Agent ***************************************************
        Form(
          key: _profileUpdateKey,
          autovalidate: false,
          child: new ListView(
            padding: EdgeInsets.only(left: 30, right: 30),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _style.mTextFormField(context, onSaved: (val) {
                _userProfile['firstName'] = val;
              },
                  validator: _style.isNumber,
                  hintText: "...",
                  labelText: "Tel",
                  autocorrect: true,
                  autovalidate: false,
                  textCapitalization: TextCapitalization.words,
                  helperText: ""),
              _style.mTextFormField(context, onSaved: (val) {
                _userProfile['zip'] = val;
              },
                  validator: _style.isNotNull,
                  hintText: "...",
                  labelText: "Zip Code",
                  autocorrect: true,
                  autovalidate: false,
                  textCapitalization: TextCapitalization.words,
                  helperText: ""),
              _style.mTextFormField(context, onSaved: (val) {
                _userProfile['address'] = val;
              },
                  validator: _style.isNotNull,
                  hintText: "...",
                  labelText: "Address",
                  autocorrect: true,
                  autovalidate: false,
                  textCapitalization: TextCapitalization.words,
                  helperText: ""),
              _style.mTextFormField(context, onSaved: (val) {
                _userProfile['city'] = val;
              },
                  validator: _style.isNotNull,
                  hintText: "...",
                  labelText: "City",
                  autocorrect: true,
                  autovalidate: false,
                  textCapitalization: TextCapitalization.words,
                  helperText: ""),
              _style.mTextFormField(context, onSaved: (val) {
                _userProfile['state'] = val;
              },
                  validator: _style.isNotNull,
                  hintText: "...",
                  labelText: "State",
                  autocorrect: true,
                  autovalidate: false,
                  textCapitalization: TextCapitalization.words,
                  helperText: ""),
              _style.mTextFormField(context, onSaved: (val) {
                _userProfile['country'] = val;
              },
                  validator: _style.isNotNull,
                  hintText: "...",
                  labelText: "Country",
                  autocorrect: true,
                  autovalidate: false,
                  textCapitalization: TextCapitalization.words,
                  helperText: ""),
              SizedBox(
                height: 20,
              ),
              Visibility(
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.teal),
                )),
                replacement: OutlineButton.icon(
                  onPressed: () {
                    _updateProfileFuntion('Update Profile');
                  },
                  icon: Icon(Icons.person_add),
                  label: Text('Register'),
                  textColor: Theme.of(context).primaryColor,
                ),
                visible: _isUpdateing,
              ),
              OutlineButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.person_pin),
                label: Text('Cancel'),
                textColor: Colors.red,
              ),
            ],
          ),
        ),
        //#endregion********************************************************************************************************
      ],
      physics: BouncingScrollPhysics(),
    ));
  }
}
