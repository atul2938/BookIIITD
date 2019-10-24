//import 'dart:io';
//import 'dart:async';
//import 'dart:convert';
//import 'package:csv/csv.dart';
//import 'backend/Auth.dart';
//import 'models/Spaces.dart';
//import 'dart:async' show Future;
//import 'package:flutter/services.dart' show rootBundle;
//import './widgets/BottomBar.dart';
import './widgets/AccountScreen.dart';
import './models/Account.dart';
import './widgets/SearchSpaceHome.dart';
import './widgets/Room.dart';
import './CreateDatabase.dart';
import 'package:flutter/material.dart';
import 'package:project1_app/models/Buildings.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _currentTabIndex = 0;
  final Account myaccount = Account('Himanshu','himanshu17291@iiitd.ac.in','Student');
  List<BottomNavigationBarItem> _bottomBarItems;
//  List<List<dynamic>> venueDB;
  var roomCalled =false;
  List<Buildings> allBuilding;
  Buildings currentBuilding;

  @override
  void initState() {
    CreateDatabse cr = CreateDatabse();
    print("Before calling");
    allBuilding = cr.returnFetchedBuildings();
    print("After calling, allBuildings = ");
    super.initState();
  }



//  void fetchVenueDatabase() async{
//     venueDB =  await loadVenuedatabase();
//     List<Buildings> bhavans = List<Buildings>();
//     List<Spaces> space = List<Spaces>();
//     String buildingName = venueDB[1][0];
//     int count = 0;       //to count how many spaces a building has
//     for(int i=1;i<venueDB.length;i++){
//        if(venueDB[i][0] == buildingName){
//          //This building has more spaces
//          //append this space to the end of the list "space"
//          count++;
//          // print(venueDB[i][4].runtimeType);
//          if(!(venueDB[i][4] is String)){
//            venueDB[i][4] = venueDB[i][4].toString();
//          }
//          space.add(Spaces(venueDB[i][1], venueDB[i][3], venueDB[i][2], venueDB[i][4]));
//        }
//        else{
//          bhavans.add(Buildings(venueDB[i-1][0],count,space));
//          buildingName = venueDB[i][0];
//          count = 1;
//          space.clear();
//          if(!(venueDB[i][4] is String)){
//            venueDB[i][4] = venueDB[i][4].toString();
//          }
//          space.add(Spaces(venueDB[i][1], venueDB[i][3], venueDB[i][2], venueDB[i][4]));
//        }
//     }
//     bhavans.add(Buildings(venueDB[venueDB.length-1][0],count,space));
//
//    //  for(int i=0;i<bhavans.length;i++){
//    //    print(bhavans[i].noofspaces);
//    //  }
//  }

//  final List<Buildings> spaceOptions = [
//  // Buildings('Library',5,[Spaces('LR1',[2,3,4,5]),Spaces('LR2',[8,9,10,11,12])]),
//  Buildings('Old Acad',6,null),
//  Buildings('R&D Building',5,null),
//  Buildings('Seminar Building',5,null),
//  Buildings('Sports Courts',3,null)
//];


//  void _bottomBarButtonTap(index) {
//    setState(() {
//      _currentTabIndex = index;
//    });
//    print(_currentTabIndex);
//  }

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
    final _kTabPages = <Widget>[
      SingleChildScrollView(child: SearchSpaceHome(allBuilding,_callRoom),),
      Center(
        child: Icon(Icons.event, size: 64.0, color: Colors.teal),
      ),
      AccountScreen(myaccount),
    ];

    Widget _chooseBody()
    {
//      print(venueDB);
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
          body:_chooseBody(),
          bottomNavigationBar: bottomBar(), //BottomBar(_bottomBarButtonTap),
        )
        );
  }
}
//
//Future<String> _loadVenueDatabase() async {
//  return await rootBundle.loadString('assets/VenueDatabase.csv');
//}
//
//Future<List<List<dynamic>>> loadVenuedatabase() async {
//  String data = await _loadVenueDatabase();
//  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);
//  return rowsAsListOfValues;
//}

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
