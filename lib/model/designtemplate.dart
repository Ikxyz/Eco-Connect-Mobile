import 'dart:io';
import 'dart:ui';

import 'package:eco_connect/classes/classes.dart';
import 'package:eco_connect/model/data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as xPath;
import 'package:random_string/random_string.dart' as random;
import 'package:scoped_model/scoped_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class DesignTemplate extends Clasess {
  BuildContext context;
  ThemeData theme;

  static final GlobalKey<FormState> _profileUpdateFormKey =
      GlobalKey<FormState>();
  DesignTemplate(this.context) {
    theme = Theme.of(context);
  }

  double getwidth({val}) {
    if (val == null) return MediaQuery.of(context).size.width;
    return ((val / 100) * MediaQuery.of(context).size.width);
  }

  double getheigth({val}) {
    if (val == null) return MediaQuery.of(context).size.height;
    return ((val / 100) * MediaQuery.of(context).size.height);
  }

  String timeAgo(dynamic stamp) {
    // DateTime time = stamp.toDate();

    print('Got fo it $stamp');
    if (stamp == null) return '';
    if (stamp == 'online' || stamp == "Online") return stamp;

    return timeago.format(stamp);
  }

  Future<File> getImage({bool camera: true}) async {
    var image = await ImagePicker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);
    return image;
  }

  showSnackBar(GlobalKey<ScaffoldState> _scaffoldState, String content) {
    if (_scaffoldState.currentState == null) return;
    _scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

  Future<dynamic> uploadFile(File file, String uid, {String location}) async {
    if (uid == null) {
      print('User id is null');
      return null;
    }
    if (location == null) location = 'profile'; //default location

    final String fileExt = xPath.basename(file.path).split('.')[1];
    final StorageReference _ref =
        FirebaseStorage().ref().child(location).child('$uid.$fileExt');
    final upload = await _ref.putFile(file);
    bool ok = await upload.events.any((eve) {
      if (eve.type == StorageTaskEventType.success) return true;
      return false;
    });
    if (ok) return await upload.lastSnapshot.ref.getDownloadURL();
    return null;
  }

//  Widget chatBubble(
//      MESSAGE msg, UsersProfile personOne, UsersProfile personTwo) {
//    bool isSender = msg.from == personOne.uid;
//
//    return Container(
//      margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
//      child: Card(
//        elevation: 0,
//        color: isSender ? Colors.grey.shade300 : Colors.teal.shade50,
//        margin: isSender
//            ? EdgeInsets.only(left: getwidth(val: 20))
//            : EdgeInsets.only(right: getwidth(val: 20)),
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(20))),
//        child: Padding(
//          padding: const EdgeInsets.all(10.0),
//          child: Column(
//            children: <Widget>[
//              isSender
//                  ? Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Text(msg.msg),
//                        ),
//                        SizedBox(
//                          width: 10,
//                        ),
//                        Container(
//                          child: getAvatar(personOne, radius: 40),
//                          height: 40,
//                          width: 40,
//                        ),
//                      ],
//                    )
//                  : Row(
//                      children: <Widget>[
//                        Container(
//                          child: getAvatar(personTwo, radius: 40),
//                          height: 40,
//                          width: 40,
//                        ),
//                        SizedBox(
//                          width: 10,
//                        ),
//                        Expanded(
//                          child: Text(msg.msg),
//                        ),
//                      ],
//                    )
//            ],
//          ),
//        ),
//      ),
//    );
//  }

  dynamic getValue(val, {isNull: '', isNotNul}) {
    if (val == null) return isNull;
    if (isNotNul == null)
      return val;
    else
      return isNotNull;
  }

//#region textStyle
  TextStyle mTitleStyle({color: null}) {
    if (color == null) color = theme.primaryColor;
    return TextStyle(
      color: color,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle mSubTitleStyle({color: null}) {
    if (color == null) color = theme.primaryColor;
    return TextStyle(
      color: color,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle mSemiNormalStyle({color: null}) {
    if (color == null) color = theme.primaryColor;
    return TextStyle(
      color: color,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle mNormalStyle({color: null}) {
    if (color == null) color = theme.primaryColor;
    return TextStyle(
      color: color,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  //#endregion

//#region textBox

  TextFormField mTextFormField(context,
      {@required onSaved,
      @required validator,
      @required hintText,
      @required labelText,
      textCapitalization: TextCapitalization.words,
      autovalidate: false,
      autocorrect: true,
      textInputAction: TextInputAction.done,
      obscureText: false,
      key,
      maxLines: 1,
      prefix,
      errorColor: Colors.red,
      keyboardType: TextInputType.text,
      errorText: 'Can\'t be left empty',
      suffix,
      helperText: "",
      prefixIcon,
      controller}) {
    return TextFormField(
      controller: controller,
      autofocus: false,
      style: TextStyle(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefix: prefix,
          suffix: suffix,
          helperText: helperText,
          prefixIcon: prefixIcon,
          errorText: errorText,
          hintStyle: TextStyle(color: Theme.of(context).primaryColor),
          suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          helperStyle: TextStyle(color: Theme.of(context).primaryColor),
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
          fillColor: Theme.of(context).primaryColor,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          counterStyle: TextStyle(color: Theme.of(context).primaryColor),
          errorStyle: TextStyle(color: errorColor),
          hasFloatingPlaceholder: true),
      textCapitalization: textCapitalization,
      autovalidate: autovalidate,
      validator: validator,
      onSaved: onSaved,
      autocorrect: true,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      key: key,
      maxLines: maxLines,
    );
  }

//#endregion

  String getID({lenght: 28}) => random.randomAlphaNumeric(lenght);

  void showDialogBox(
      {@required context,
      @required title,
      @required desc,
      color: Colors.blue,
      icon: Icons.info_outline,
      buttonText: "Close",
      Function callBack}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: new Card(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: new Column(
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            color: color,
                            fontSize: 20,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(child: new Text(desc)),
                        SizedBox(
                          height: 10,
                        ),
                        new Center(
                          child: RaisedButton.icon(
                              shape: StadiumBorder(),
                              textColor: Colors.white,
                              color: color,
                              onPressed: () {
                                try {
                                  callBack();
                                } catch (err) {}
                                Navigator.of(context).pop();
                              },
                              icon: Icon(icon),
                              label: Text(buttonText)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

//  void showProfileDialogBox(
//      {@required UsersProfile userProfile,
//      Function onTap,
//      buttonText: "Close",
//      Function callBack}) {
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.center,
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              Card(
//                child: Container(
//                  padding: EdgeInsets.all(20),
//                  height: getheigth(val: 70),
//                  child: ListView(
//                    children: <Widget>[
//                      Container(
//                        child: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: getAvatar(userProfile, radius: 100),
//                        ),
//                        width: 50,
//                        margin: EdgeInsets.only(
//                            left: getwidth() * 0.1, right: getwidth() * 0.1),
//                      ),
//                      SizedBox(
//                        height: 10,
//                      ),
//                      Center(
//                        child: Text(
//                          " ${getValue(userProfile.online, isNull: '')}",
//                          style: TextStyle(
//                              color: userProfile.online == "online"
//                                  ? Colors.green
//                                  : Colors.black),
//                        ),
//                      ),
//                      SizedBox(
//                        height: 10,
//                      ),
//                      Text(
//                          "Name: ${userProfile.lastName} ${userProfile.firstName}"),
//                      Text(
//                          "State ${getValue(userProfile.state, isNotNul: userProfile.state, isNull: '')}"),
//                      Text(
//                          "City:  ${userProfile.city != null ? userProfile.city : ''}"),
//                      Text(
//                          "Country:  ${userProfile.country != null ? userProfile.country : ''}"),
//                      SizedBox(height: 10),
//                      Center(
//                        child: FlatButton.icon(
//                            onPressed: () {
//                              try {
//                                onTap();
//                              } catch (err) {}
//                            },
//                            color: Theme.of(context).primaryColor,
//                            icon: Icon(Icons.message),
//                            textColor: Colors.white,
//                            label: Text('Begin registration')),
//                      ),
//                    ],
//                  ),
//                ),
//                margin: EdgeInsets.only(left: 20, right: 20),
//              ),
//            ],
//          );
//        });
//  }

  void showProfileUpdateDialog(
      {@required Map<String, dynamic> updateNode, @required context}) {
    DataModel _model = new DataModel(context);
    _model.homeScaffoldState.currentState.showBottomSheet((contex) {
      Map<String, dynamic> _updateData = {};
      bool _isWorking = false;
      List<Widget> _widgetList = <Widget>[
        Text(
          "Profile Update",
          style: mTitleStyle(),
        ),
        SizedBox(
          height: 10,
        ),
      ];

      updateNode.forEach((key, value) {
        _widgetList.add(
            ScopedModelDescendant<DataModel>(builder: (context, child, model) {
          GlobalKey _mkey = new GlobalKey();
          model.listOfuniqueKey.add(_mkey);

          return mTextFormField(context, onSaved: (val) {
            updateNode[value] = val;
          },
              validator: this.isNotNull,
              key: model.getUniqueKeyFromList,
              hintText: "Enter $key",
              labelText: key);
        }));
      });
      _widgetList.add(
        Center(
          child: Visibility(
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
            visible: _isWorking,
            replacement: FlatButton.icon(
                onPressed: () {
                  if (_profileUpdateFormKey.currentState.validate() == false)
                    return;
                  _profileUpdateFormKey.currentState.save();
                  _isWorking = !_isWorking;
                  _model.db
                      .collection('profile')
                      .document(_model.userProfile.uid)
                      .updateData(_updateData)
                      .then((e) {
                    _isWorking = !_isWorking;
                    Navigator.pop(context);
                    showDialogBox(
                        context: context,
                        title: "Success",
                        desc: "Profile updates successfully");
                  });
                },
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.account_circle),
                textColor: Colors.white,
                label: Text('Update')),
          ),
        ),
      );

      return Form(
        key: _profileUpdateFormKey,
        child: ScopedModel<DataModel>(
          model: _model,
          child: Container(
            width: getwidth(),
            height: getheigth(),
            child: Card(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: _widgetList,
              ),
            ),
          ),
        ),
      );
    });
  }

//  dynamic networkCachedImage(
//      {@required url, @required provider: true, raduis}) {
//    if (provider)
//      return CachedNetworkImageProvider(url,
//          errorListener: () => CircularProgressIndicator());
//
//    return CachedNetworkImage(
//        imageUrl: url,
//        fit: BoxFit.fill,
//        errorWidget: (context, url, error) => Center(
//              child: CircularProgressIndicator(
//                strokeWidth: 1,
//              ),
//            ),
//        placeholder: (context, url) => Center(
//              child: CircularProgressIndicator(
//                strokeWidth: 1,
//              ),
//            ));
//  }

//  Widget getMinProfileCard(UsersProfile userProfile, Function onTap) {
//    return Container(
//      width: MediaQuery.of(context).size.width / 2,
//      child: GestureDetector(
//        onTap: () {
//          showProfileDialogBox(userProfile: userProfile, onTap: onTap);
//        },
//        child: Card(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Column(
//              children: <Widget>[
//                Row(
//                  mainAxisSize: MainAxisSize.max,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Expanded(
//                      child: getAvatar(userProfile, radius: 60),
//                    ),
//                    Icon(
//                      Icons.brightness_1,
//                      size: 10,
//                      color: userProfile.online == "online"
//                          ? Colors.green
//                          : Colors.grey,
//                    )
//                  ],
//                ),
//                SizedBox(
//                  height: 10,
//                ),
//                Text("${userProfile.lastName} ${userProfile.firstName}"),
//                SizedBox(
//                  height: 10,
//                ),
//                Text(
//                    " ${getValue(userProfile.state, isNotNul: userProfile.state, isNull: '')}"),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  dynamic userInterface({@required child, opacity: 0.5}) {
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: AssetImage('assets/image/grocery.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: new Container(
          child: child,
          decoration:
              new BoxDecoration(color: Colors.white.withOpacity(opacity)),
        ),
      ),
    );
  }
//
//  Widget getAvatar(UsersProfile userProfile, {String url, double radius: 100}) {
//    if (url != null) {
//      return new ClipOval(
//        child: networkCachedImage(url: url, provider: false),
//      );
//    }
//    if (userProfile == null) {
//      return CircleAvatar(
//        child: Text(''),
//        radius: radius,
//      );
//    }
//    if (userProfile.passport == null) {
//      return CircleAvatar(
//        child: userProfile.lastName != null
//            ? Text(
//                '${userProfile.lastName.substring(0, 1)}${userProfile.firstName.substring(0, 1)}',
//                style: TextStyle(fontSize: radius * 0.5),
//              )
//            : Text(''),
//        radius: radius,
//      );
//    }
//    return new ClipOval(
//      child: networkCachedImage(url: userProfile.passport, provider: false),
//    );
//
////      CircleAvatar(
////      radius: 50,
////      backgroundImage:
////          networkCachedImage(url: userProfile.passport, provider: true),
////    );
//
////    Container(
////        height: radius * 2,
////        decoration: BoxDecoration(
////            shape: BoxShape.circle,
////            image: DecorationImage(
////                image: networkCachedImage(
////                    url: userProfile.passport,
////                    provider: true,
////                    raduis: radius))));
//  }

}
