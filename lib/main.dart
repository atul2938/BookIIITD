import 'package:flutter/material.dart';
import 'package:project1_app/CreateDatabase.dart';
import 'package:project1_app/models/Buildings.dart';
import 'package:project1_app/widgets/AuthScreen.dart';
import 'package:project1_app/widgets/BookingScreen.dart';
import './widgets/AccountScreen.dart';
import './models/Account.dart';
// import './widgets/BottomBar.dart';
import './widgets/SearchSpaceHome.dart';
import './widgets/Room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

Future main() async {
  // await CreateDatabse.loadVenuedatabase();
  await CreateDatabse.fetchVenueDatabase();
  await CreateDatabse.fetchTimeTableDatabase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final Dref = FirebaseDatabase.instance.reference();
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _currentTabIndex = 0;
  final Account myaccount =
      Account('Himanshu', 'himanshu17291@iiitd.ac.in', 'Student');
  List<BottomNavigationBarItem> _bottomBarItems;
  var roomCalled = false;
  static List<Buildings> allBuilding;
  static List<List<String>> timeTable;
  Buildings currentBuilding;

  @override
  void initState() {
    //Initial State of the app
    super.initState();
    allBuilding = CreateDatabse.Bhavans;
    timeTable = CreateDatabse.SamaySarini;
    print(allBuilding[4].spaces[0].timeSlots.length);
    //Modify timeslots here

    loadToDatabase();
    print("ho gaya");
  }

  void loadToDatabase() async {
    // final url = 'https://space-iiitd.firebaseio.com/Buildings.json';
    for (int i = 0; i < allBuilding.length; i++) {
      await widget.Dref.child('Buildings')
          .child(allBuilding[i].name)
          .set(json.encode(allBuilding[i].toJson()));
    }
  }

  void _bottomBarButtonTap(index) {
    setState(() {
      _currentTabIndex = index;
    });
    print(_currentTabIndex);
  }

  BottomNavigationBar bottomBar() {
    if (myaccount.privilege == 3) {
      _bottomBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.search), title: Text('Search')),
        BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events')),
        BottomNavigationBarItem(icon: Icon(Icons.work), title: Text('Admin')),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), title: Text('MyProfile'))
      ];
    } else {
      _bottomBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.search), title: Text('Search')),
        BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events')),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), title: Text('MyProfile'))
      ];
    }

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
    final _kTabPages = <Widget>[
      SingleChildScrollView(
        child: SearchSpaceHome(allBuilding, _callRoom),
      ),
      Center(
        child: Icon(Icons.event, size: 64.0, color: Colors.teal),
      ),
      AccountScreen(myaccount),
    ];

    Widget _chooseBody() {
      if (roomCalled && _currentTabIndex == 0) {
        return Room(this.currentBuilding, _callRoomExit);
      }
      return _kTabPages[_currentTabIndex];
    }

    return MaterialApp(
        theme: ThemeData(primarySwatch: colorIIITD),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Space Booking", style: TextStyle(color: colorIIITD),),
            backgroundColor: Colors.white,
          ),
          body: BookingScreen(),
          // body:_chooseBody(),
          bottomNavigationBar: bottomBar(), //BottomBar(_bottomBarButtonTap),
        ));
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
