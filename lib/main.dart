import 'package:flutter/material.dart';
import 'package:project1_app/CreateDatabase.dart';
import 'package:project1_app/models/Buildings.dart';
import './widgets/AccountScreen.dart';
import './models/Account.dart';
// import './widgets/BottomBar.dart';
import './widgets/SearchSpaceHome.dart';
import './widgets/Room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

void main() => runApp(MyApp());
//Future main() async {
//  // await CreateDatabse.loadVenuedatabase();
//  await CreateDatabse.fetchVenueDatabase();
//  runApp(MyApp());
//}
class MyApp extends StatefulWidget {
  
  final Dref = FirebaseDatabase.instance.reference();
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
  
}

class _MyAppState extends State<MyApp> {
  bool gotdata=false;
  var _currentTabIndex = 0;
  final Account myaccount = Account('Himanshu','himanshu17291@iiitd.ac.in','Student');
  List<BottomNavigationBarItem> _bottomBarItems;
  var roomCalled =false;
  static List<Buildings> allBuilding = new List<Buildings>();
  Buildings currentBuilding;

  @override
  void initState() {            //Initial State of the app
    super.initState();
    getDatabase();
//    allBuilding = CreateDatabse.Bhavans;
//     print(allBuilding[0].toString());
//    loadToDatabase();
    print("ho gaya");
  }

  void getDatabase() async {
    List<Buildings> b = List<Buildings>();
    Buildings building;
    List<String> names = ['Library Building','Old Academic Block','R&D Block','Seminar Block ','Sports Block'];
    for(int i=0;i<names.length;i++)
      {
        DataSnapshot dataSnapshot = await widget.Dref.child('Buildings').child(names[i]).once();
        if(dataSnapshot.value[1]!=null)
          {
            print("dataSnapshot");
            print(dataSnapshot.value);
            print('INside here');
            building = Buildings.fromMappedJson(json.decode(dataSnapshot.value));
            print(building.name);
            b.add(building);
          }
      }
    if(b.length==5)
      {
        setState(() {
          gotdata=true;
        });

      }
    allBuilding = b;
  }

  void loadToDatabase() async{
    // final url = 'https://space-iiitd.firebaseio.com/Buildings.json';
    for(int i=0;i<allBuilding.length;i++){
      await widget.Dref.child('Buildings').child(allBuilding[i].name).set(json.encode(allBuilding[i].toJson()));
    }
  
  }

  // void _bottomBarButtonTap(index) {
  //   setState(() {
  //     _currentTabIndex = index;
  //   });
  //   print(_currentTabIndex);
  // }

  BottomNavigationBar bottomBar()
  {
    if(myaccount.privilege==3)
    {
      _bottomBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
        BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events')),
        BottomNavigationBarItem(icon: Icon(Icons.work), title: Text('Admin')),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('MyProfile'))
      ];
    }
    else
    {
      _bottomBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
        BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events')),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('MyProfile'))
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

  void _callRoom(building)
  {
    setState(() {
      roomCalled=true;
      this.currentBuilding=building;
    });

  }

  void _callRoomExit()
  {
    setState(() {
      roomCalled=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    // print(allBuilding);
    final _kTabPages = <Widget>[
      SingleChildScrollView(child: SearchSpaceHome(allBuilding,_callRoom),),
      Center(
        child: Icon(Icons.event, size: 64.0, color: Colors.teal),
      ),
      AccountScreen(myaccount),
    ];

    Widget _chooseBody()
    {
      if(roomCalled && _currentTabIndex==0)
        {
          return Room(this.currentBuilding,_callRoomExit);
        }
      return _kTabPages[_currentTabIndex];
    }

    return MaterialApp(
        theme: ThemeData(primarySwatch: colorIIITD),
        home:
          Scaffold(
          appBar: AppBar(title: Text("Space Booking")),
          body:gotdata?_chooseBody():Container(child: Center(child: CircularProgressIndicator()),),
          bottomNavigationBar: bottomBar(), //BottomBar(_bottomBarButtonTap),
        )
        );
  }
}

Map<int, Color> themeColor ={
  50:Color.fromRGBO(63,173,168, .1),
  100:Color.fromRGBO(63,173,168, .2),
  200:Color.fromRGBO(63,173,168, .3),
  300:Color.fromRGBO(63,173,168, .4),
  400:Color.fromRGBO(63,173,168, .5),
  500:Color.fromRGBO(63,173,168, .6),
  600:Color.fromRGBO(63,173,168, .7),
  700:Color.fromRGBO(63,173,168, .8),
  800:Color.fromRGBO(63,173,168, .9),
  900:Color.fromRGBO(63,173,168, 1),
};

MaterialColor colorIIITD = MaterialColor(0xff3FADA8, themeColor);