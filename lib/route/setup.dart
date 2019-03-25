import 'dart:io';
import 'dart:ui';
import 'package:eco_connect/model/data.dart';
import 'package:eco_connect/model/designtemplate.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_connect/classes/classes.dart';
import 'package:eco_connect/classes/custom-clip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_connect/classes/otp-text-feild.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  TextEditingController _otpCode = TextEditingController(text: '');
  UsersProfile _profile = UsersProfile.object(Map.from(jsonUserProfile()));
  String _message = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DesignTemplate _style;
  String _verificationId;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  SharedPreferences _sharedPreferences;
  bool _isworking = false;
  bool _isUploading = false;
  Map<String, dynamic> _profileMapData =
      new Map<String, dynamic>.from(jsonUserProfile());
  @override
  Widget build(BuildContext context) {
    DesignTemplate mStyle = new DesignTemplate(context);
    DataModel _dataModel = new DataModel(context);

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    void initState() {
      _controller = AnimationController(vsync: this);
      super.initState();
      _style = DesignTemplate(context);
    }

    void _goto(int val) {
      _pageController.animateToPage(val,
          duration: Duration(milliseconds: 500), curve: SawTooth(1));
    }

    Future _createProfile() {
      setState(() {
        _isworking = true;
      });
      String uid = _profileMapData['uid'];
      if (uid == null) {
        setState(() {
          _isworking = false;
        });
        _goto(1);
        mStyle.showSnackBar(_scaffoldState, 'Re-Authentication to continue');
      }
      if (_profileFormKey.currentState.validate() == false) {
        setState(() {
          _isworking = false;
        });
        return null;
      }
      _profileFormKey.currentState.save();

      print(_profileMapData);
      return _dataModel.db
          .collection('profile')
          .document(uid)
          .setData(_profileMapData)
          .then((res) {
        _dataModel.setCurrentUser(context);
        //Notity User on successfull account opening
        print('Account Opened Successfully');
        setState(() {
          _isworking = false;
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
      }).catchError((err) {
        setState(() {
          _isworking = false;
        });
        mStyle.showDialogBox(
            context: context,
            title: "Error creating account",
            desc: "",
            buttonText: "Try again",
            callBack: () {
              _createProfile();
            });
      });
    }

    void _verifyPhoneNumber() async {
      setState(() {
        _message = '';
        _isworking = true;
      });
      final PhoneVerificationCompleted verificationCompleted =
          (FirebaseUser user) {
        setState(() {
          _message = 'signInWithPhoneNumber auto succeeded: $user';
          _isworking = false;
        });
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        setState(() {
          _message =
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
          _isworking = false;
        });
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        _scaffoldState.currentState.showSnackBar(SnackBar(
          content:
              const Text('Please check your phone for the verification code.'),
        ));
        _profileMapData['tel'] = '+234' + _phoneNumberController.text;
        _goto(2);
        setState(() {
          _isworking = false;
        });
        _verificationId = verificationId;
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
        _isworking = false;
      };

      await _auth.verifyPhoneNumber(
          phoneNumber: '+234' + _phoneNumberController.text,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }

    Future<bool> _hasAccount(String uid) async {
      var acc = await _dataModel.db.collection('profile').document(uid).get();
      return acc.exists;
    }

    void _signInWithPhoneNumber() async {
      setState(() {
        _isworking = true;
      });
      final FirebaseUser user = await _auth.signInWithPhoneNumber(
          verificationId: _verificationId, smsCode: _otpCode.text);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      setState(() async {
        if (user != null) {
          _message = ' in, uid: ' + user.uid;
          setState(() {
            _isworking = false;
            _profileMapData['uid'] = user.uid;
          });
          if (await _hasAccount(user.uid) == true) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'home', (Route<dynamic> route) => false);
          }
          _goto(3);
        } else {
          setState(() {
            _isworking = false;
          });
          mStyle.showDialogBox(
              context: context,
              title: 'Sign in failed',
              desc: 'Unable to sign in at the moment.');
        }
      });
    }

    void _fetchAndUploadPassport(bool camera) async {
      setState(() {
        _isUploading = true;
      });
      File file = await mStyle.getImage(camera: camera);
      if (file == null) {
        mStyle.showSnackBar(_scaffoldState, 'Invalid File');
        setState(() {
          _isUploading = false;
        });
      }
      print('Got file ${file.path}');
      String url = await mStyle.uploadFile(file, _profileMapData['uid']);
      if (url == null) {
        setState(() {
          _isUploading = false;
        });
        return mStyle.showSnackBar(_scaffoldState, 'Invalid File');
      }
      print('This is the download Url $url');
      setState(() {
        _profileMapData['passport'] = url;
        _isUploading = false;
      });
    }

    TextStyle _textStyle =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 18);

    List<Widget> _pages(context) {
      return <Widget>[
        //#region**************************** Welcome Page ********************************************************************

        new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              color: Theme.of(context).primaryColor,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/lunch/icon.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Eco-",
                        style: mStyle.mTitleStyle(color: Colors.white),
                      ),
                      Text(
                        "Connect",
                        style: mStyle.mTitleStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      _profileMapData['isMember'] = true;
                      _profileMapData['isAgent'] = false;
                      _goto(1);
                    },
                    shape: StadiumBorder(),
                    icon: Icon(Icons.account_circle),
                    label: Text('SignIn as a Member'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      _profileMapData['isAgent'] = true;
                      _profileMapData['isMember'] = false;
                      _goto(1);
                    },
                    shape: StadiumBorder(),
                    icon: Icon(Icons.supervised_user_circle),
                    label: Text('SignIn as an Agent'),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        //#endregion*********************************************************************************

        //#region******************* Enter Phone Number **************************************************************

        new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ClipPath(
                    child: Container(
                      height: mStyle.getheigth(val: 30),
                      color: Theme.of(context).primaryColor,
                      child: Image.asset(
                        'assets/image/eco-connect.png',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        height: mStyle.getheigth(val: 30),
                        width: mStyle.getwidth(),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                    ),
                    clipper: CustomClip(),
                  ),
                  Container(
                    height: mStyle.getheigth(val: 70),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Sign in with phone number",
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor),
                        ),
                        TextFormField(
                          controller: _phoneNumberController,
                          maxLines: 1,
                          decoration: InputDecoration(
                              prefix: Text(
                                "+234",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              enabled: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              counterStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14),
                              helperStyle: _textStyle,
                              labelStyle: _textStyle,
                              prefixStyle: _textStyle,
                              errorStyle: _textStyle,
                              hintText: '',
                              icon: Icon(Icons.phone_android,
                                  color: Theme.of(context).primaryColor,
                                  size: 18),
                              labelText: 'Phone number (+x xxx-xxx-xxxx)'),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18),
                          validator: (String value) {
                            if (value.isEmpty || value.length != 10) {
                              return '';
                            }
                          },
                          autofocus: false,
                          autovalidate: true,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () async {
                                  _goto(0);
                                },
                                shape: CircleBorder(),
                                child: Icon(Icons.arrow_back),
                              ),
                              Container(
                                child: Visibility(
                                  visible: _isworking,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                  replacement: RaisedButton(
                                    onPressed: () async {
                                      _verifyPhoneNumber();
                                    },
                                    shape: StadiumBorder(),
                                    child: const Text('Next'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _message,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        //#endregion
        //#region******************* Enter OTP CODE **************************************************************
        new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ClipPath(
                    child: Container(
                      height: mStyle.getheigth(val: 40),
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/image/eco-connect.png',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            height: mStyle.getheigth(val: 20),
                            width: mStyle.getwidth(),
                          ),
                          Text(
                            'Enter the six digit pin sent to you at \n \nxxx-${_phoneNumberController.text}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                    ),
                    clipper: CustomClip(),
                  ),
                  Container(
                    height: mStyle.getheigth(val: 60),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        TextFormField(
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          autovalidate: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              enabled: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              counterStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14),
                              helperStyle: _textStyle,
                              labelStyle: _textStyle,
                              prefixStyle: _textStyle,
                              errorStyle: _textStyle,
                              hintText: '- - - -',
                              icon: Icon(Icons.fiber_pin,
                                  color: Theme.of(context).primaryColor,
                                  size: 18),
                              labelText: 'Code (OTP)'),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18),
                          controller: _otpCode,
                          validator: (String value) {
                            if (value.isEmpty || value.length != 6) {
                              return '';
                            }
                          },
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  _goto(2);
                                },
                                color: Colors.lightGreen,
                                icon: Icon(Icons.arrow_back),
                              ),
                              Container(
                                child: Visibility(
                                  visible: _isworking,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                  replacement: RaisedButton(
                                    onPressed: () async {
                                      _signInWithPhoneNumber();
                                    },
                                    shape: StadiumBorder(),
                                    child: const Text('Next'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _message,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

        //#endregion
        //#region******************* Enter Profile details **************************************************************
        new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ClipPath(
                    child: Container(
                      height: mStyle.getheigth(val: 40),
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: <Widget>[
                          _isUploading
                              ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Container(
                                  height: mStyle.getheigth(val: 25),
                                  width: mStyle.getheigth(val: 25),
                                  child: _profileMapData['passport'] == null
                                      ? Icon(Icons.account_circle,
                                          size: mStyle.getwidth(val: 40))
                                      : mStyle.getAvatar(null,
                                          url: _profileMapData['passport'],
                                          radius: 50),
                                ),
                          FlatButton.icon(
                            label: Text('Upload photo'),
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 100,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          RaisedButton.icon(
                                              onPressed: () {
                                                _fetchAndUploadPassport(true);
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.camera_alt),
                                              label: Text('Take new photo')),
                                          RaisedButton.icon(
                                              onPressed: () {
                                                _fetchAndUploadPassport(false);
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.folder),
                                              label: Text('Pick from file'))
                                        ],
                                      ),
                                    );
                                  });
                            },
                            shape: StadiumBorder(),
                            textColor: Colors.white,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                    ),
                    clipper: CustomClip(),
                  ),
                  Container(
                    height: mStyle.getheigth(val: 60),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      autovalidate: false,
                      key: _profileFormKey,
                      onChanged: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          mStyle.mTextFormField(context, onSaved: (val) {
                            _profileMapData['isAgent'] = true;
                            _profileMapData['firstName'] = val;
                          },
                              autovalidate: false,
                              autocorrect: true,
                              validator: mStyle.isNotNull,
                              hintText: 'Enter first name',
                              labelText: 'First Name',
                              suffix: Icon(Icons.edit)),
                          mStyle.mTextFormField(context, onSaved: (val) {
                            _profileMapData['lastName'] = val;
                          },
                              autovalidate: false,
                              autocorrect: true,
                              validator: mStyle.isNotNull,
                              hintText: 'Enter last name',
                              labelText: 'Last Name',
                              suffix: Icon(Icons.edit)),
                          mStyle.mTextFormField(context, onSaved: (val) {
                            _profileMapData['address'] = val;
                          },
                              autovalidate: false,
                              autocorrect: true,
                              validator: mStyle.isNotNull,
                              hintText: 'Enter address',
                              labelText: 'Address',
                              suffix: Icon(Icons.home)),
                          Container(
                              alignment: Alignment.center,
                              child: Visibility(
                                visible: _isworking,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                                replacement: RaisedButton(
                                  onPressed: _createProfile,
                                  shape: StadiumBorder(),
                                  child: const Text('Next'),
                                ),
                              )),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _message,
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

        //#endregion
      ];
    }

    return Scaffold(
      key: _scaffoldState,
      body: PageView(
          children: _pages(context),
          onPageChanged: (val) {},
          controller: _pageController,
          physics: BouncingScrollPhysics()),
    );
  }
}
