import 'dart:core';
import 'dart:core';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1_app/Pages/AdministratorPage.dart';
import 'package:project1_app/Pages/EventPage.dart';
import 'package:project1_app/services/authentication.dart';
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

////////////////////
import '../file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
///////////////



class HomePage extends StatefulWidget {
  final Dref = FirebaseDatabase.instance.reference();
  var goBack=false;
   BaseAuth auth;
   VoidCallback logoutCallback;
  String userId;
   Account myaccount;
   FirebaseUser user;


  HomePage(this.auth,this.logoutCallback,this.userId);

//  HomePage.notAllinfo(auth,logoutCallback,user)
//  {
//    this.auth=auth;
//    this. logoutCallback=logoutCallback;
//    this.user=user;
//    String email = user.email;
//    String first = email.split('@')[0];
//    String name = first;
////    bool isstudent = false;
//    List<String> no = ['0','1','2','3','4','5','6','7','8','9'];
//    for(int i=0;i<no.length;i++)
//    {
//      if(name.contains(no[i]))
//      {
////        isstudent = true;
//        name = name.replaceAll(no[i], '');
//      }
//    }
//    this.myaccount = new Account(name,user.uid,email,'Administration','3');
//  }

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {
  bool gotdata = false;
  var _currentTabIndex = 0;
//  final Account myaccount = Account('Himanshu', 'himanshu17291@iiitd.ac.in', 'Administration');
  List<BottomNavigationBarItem> _bottomBarItems;
  var roomCalled = false;
  var isAdministrator =false;
  static List<Buildings> allBuilding = new List<Buildings>();
  static List<List<String>> timeTable;
//  Buildings currentBuilding;
  String currentBuilding;
  Account myaccount;


  @override
  void initState() {
    //Initial State of the app
    super.initState();
    print('INSIDE HOMEPAGE');
    print('user is ');
    print(widget.user);
    print('Account is ');
    print(widget.myaccount);
    widget.auth.getCurrentUser().then((user1) {
      setState(() {
        print('FOUND USER');
        print(user1);
        widget.user = user1;
        if (user1 != null) {
          widget.user = user1;
          String email = widget.user.email;
          String first = email.split('@')[0];
          String name = first;
//    bool isstudent = false;
          List<String> no = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
          for (int i = 0; i < no.length; i++) {
            if (name.contains(no[i])) {
//        isstudent = true;
              name = name.replaceAll(no[i], '');
            }
          }
          setState(() {
            widget.myaccount =new Account(name, widget.user.uid, email, 'Administration', '3');
            if (widget.myaccount.privilege == '3') {
              isAdministrator = true;
            }
            gotdata=true;
            print("ho gaya");
            print(widget.myaccount);
          });


        }
//        authStatus =
//        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }


  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

//  void getDatabase() async {
//    List<Buildings> b = List<Buildings>();
//    Buildings building;
//    List<String> names = [
//      'Library Building',
//      'Old Academic Block',
//      'R&D Block',
//      'Seminar Block ',
//      'Sports Block'
//    ];
//
//    for (int i = 0; i < names.length; i++) {
//      DataSnapshot dataSnapshot = await widget.Dref.child('Buildings').child(
//          names[i]).once();
//      if (dataSnapshot.value[1] != null) {
//        print("dataSnapshot");
//        print(dataSnapshot.value);
//        print('INside here');
//        building = Buildings.fromMappedJson(json.decode(dataSnapshot.value));
//        print(building.name);
//        b.add(building);
//      }
//    }
//    if (b.length == 5) {
//      setState(() {
//        gotdata = true;
//      });
//    }
//    allBuilding = b;
//  }

  void goBackFunc()
  {
    print("Changing go back n");
    widget.goBack = !widget.goBack;
  }

//  void loadToDatabase() async {
//    // final url = 'https://space-iiitd.firebaseio.com/Buildings.json';
//    for (int i = 0; i < allBuilding.length; i++) {
//      await widget.Dref.child('Buildings').child(allBuilding[i].name).set(
//          json.encode(allBuilding[i].toJson()));
//    }
//  }

  // void _bottomBarButtonTap(index) {
  //   setState(() {
  //     _currentTabIndex = index;
  //   });
  //   print(_currentTabIndex);
  // }

  BottomNavigationBar bottomBar() {
    isAdministrator? _bottomBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.search), title: Text('Search')),
      BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events')),
      BottomNavigationBarItem(icon: Icon(Icons.work), title: Text('Admin')),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), title: Text('MyProfile'))
    ]
        : _bottomBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.search), title: Text('Search')),
      BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events')),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), title: Text('MyProfile'))
    ];

    return BottomNavigationBar(
      items: _bottomBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
  } //bottomBar Function

  void _callRoom(building) {
    setState(() {
      roomCalled = true;
      this.currentBuilding = building;
    });
  }

  void _callRoomExit() {
    setState(() {
      roomCalled = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    print('Account check in build');
    print(widget.myaccount);

    List<Widget> _kTabPages = List<Widget>();
    List<String> appBarNames;
    isAdministrator?appBarNames = ['Search for Space','Checkout Event','Administrator Screen','Profile']:
    appBarNames = ['Search for Space','Checkout Event','Profile'];

    isAdministrator?  _kTabPages = <Widget>[
      SingleChildScrollView(child: SearchSpaceHome(_callRoom),),
      EventPage(),
      AdministratorPage(),
      AccountScreen(widget.myaccount),
    ]
        :
    _kTabPages = <Widget>[
      SingleChildScrollView(child: SearchSpaceHome( _callRoom),),
      Center(
        child: Icon(Icons.event, size: 64.0, color: Colors.teal),
      ),
      AccountScreen(widget.myaccount),
    ];

    Widget _chooseBody() {
      if (roomCalled && _currentTabIndex == 0) {
        print('Sending to Room the account');
        print(widget.myaccount);
        return Room(this.currentBuilding, _callRoomExit,widget.myaccount);
      }
      return _kTabPages[_currentTabIndex];
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: colorIIITD),

      home:Scaffold(
        appBar: AppBar(backgroundColor:Colors.white,
          actions: <Widget>[
            new FlatButton(
                child: Icon(Icons.exit_to_app,color: colorIIITD,),
//                Text('Logout',style: new TextStyle(fontSize: 17.0, color: Colors.black)),
                onPressed: signOut)
          ],
          title: Text("BookiiIT", style: TextStyle(fontSize:20,color: colorIIITD),),),

        body:gotdata?_chooseBody():Container(child: Center(child: CircularProgressIndicator()),),
        bottomNavigationBar:gotdata? bottomBar():null,
        //BottomBar(_bottomBarButtonTap),
      ),
//          :SplashScreen(goBackFunc),
    );
  }
}

Map<int, Color> themeColor = {
  50: Color.fromRGBO(63, 173, 168, .1),
  100: Color.fromRGBO(63, 173, 168, .2),
  200: Color.fromRGBO(63, 173, 168, .3),
  300: Color.fromRGBO(63, 173, 168, .4),
  400: Color.fromRGBO(63, 173, 168, .5),
  500: Color.fromRGBO(63, 173, 168, .6),
  600: Color.fromRGBO(63, 173, 168, .7),
  700: Color.fromRGBO(63, 173, 168, .8),
  800: Color.fromRGBO(63, 173, 168, .9),
  900: Color.fromRGBO(63, 173, 168, 1),

};

MaterialColor colorIIITD = MaterialColor(0xff3FADA8, themeColor);


//invention atuls
//
//class SplashScreen extends StatefulWidget {
//  SplashScreen({Key key}) : super(key: key);
//
//  _SplashScreenState createState() => _SplashScreenState();
//}
//
//class _SplashScreenState extends State<SplashScreen>{
//
//  @override
//  void initState(){
//    super.initState();
//    Future.delayed(
//      Duration(seconds: 2),
//          () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => App(),
//          ),
//        );
//      },
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Stack(
//        fit: StackFit.expand,
//        children: <Widget>[
//          new Column(
//            mainAxisAlignment: MainAxisAlignment.end,
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              Padding(padding: EdgeInsets.only(bottom: 30.0),child:SpinKitCircle(color: Color.fromRGBO(63, 173, 168, 1)))
//            ],),
//          new Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Image(image: AssetImage("assets/images/icon.png"), width: 128, height: 128),
//              Text(
//                'Space Jet',
//                style: TextStyle(
//                    fontSize: 32,
//                    fontWeight: FontWeight.w500,
//                    color: CustomColors.TextHeader),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//class App extends StatefulWidget {
//  App({Key key}) : super(key: key);
//  _AppState createState() => _AppState();
//}
//
//class _AppState extends State<App> {
//  @override
//  void initState() {
//    SystemChrome.setSystemUIOverlayStyle(
//      SystemUiOverlayStyle(
//        statusBarColor: Colors.transparent, //top bar color
//      ),
//    );
//    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        canvasColor: CustomColors.GreyBackground,
//        fontFamily: 'rubik',
//      ),
//      home: ExcelPicker(),
//    );
//  }
//}