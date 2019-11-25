import 'dart:core';
import 'dart:core';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1_app/Pages/AdministratorPage.dart';
import 'package:project1_app/Pages/HomePage.dart';
import 'package:project1_app/Pages/EventPage.dart';
import 'onboarding.dart';
import '../widgets/util.dart';
import '../CreateDatabase.dart';
import '../models/Buildings.dart';
import 'AuthScreen.dart';
import 'AccountScreen.dart';
import '../models/Account.dart';
// import './widgets/BottomBar.dart';
import 'SearchSpaceHome.dart';
import 'Room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:test_app/EventPage.dart';
import './loginSignupPage.dart';
import '../services/authentication.dart';
import './HomePage.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final Dref = FirebaseDatabase.instance.reference();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _userId = "";
  Account _account;
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        print('FOUND USER');
        print(user);
        _user=user;
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<Account> _getUser(String userid) async
  {
    DataSnapshot dataSnapshot = await Dref.child('Users').child(userid).once();
    if (dataSnapshot.value[1] != null) {
      _account= Account.fromMappedJson(json.decode(dataSnapshot.value));
    }
    return _account;
  }

  Future<FirebaseUser> _getCurrentUser() async {
    FirebaseUser user1 = await _firebaseAuth.currentUser();
//    signOut();
    if(user1!=null)
      {
        setState(() {
          _user = user1;
        });
      }
    return user1;
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
//          _getUser(_userId);
//          _getCurrentUser();
////          if(_account!=null && _user!=null)
////            {
////              print('ACCOUNT FOUND');
////              print('account id saved ${_account.id}');
////              print('user id firebase ${_userId}');
////              return HomePage(widget.auth,logoutCallback,_account,_user);
////            }
////          else
//            if (_user!=null)
//            {
////              print('ACCOUNT FOUND WITH ONLY USER');
//////              print('account id saved ${_account.id}');
////              print('user id firebase ${_userId}');
//              return HomePage.notAllinfo(widget.auth, logoutCallback, _user);
//            }
//          else
//            {
//              return buildWaitingScreen();
//            }
          return HomePage(widget.auth, logoutCallback,_userId);
//          return new HomePage(
//            userId: _userId,
//            auth: widget.auth,
//            logoutCallback: logoutCallback,
//          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}

