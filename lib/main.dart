import 'package:flutter/material.dart';
import 'package:project1_app/models/Buildings.dart';
import 'package:project1_app/widgets/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';


import './widgets/AccountScreen.dart';
import './models/Account.dart';
//import './widgets/BottomBar.dart';
import './widgets/SearchSpaceHome.dart';
import './widgets/Room.dart';
import 'models/Spaces.dart';

void main() => runApp(MyApp());

final Account myaccount = Account('Himanshu','himanshu17291@iiitd.ac.in','Student');

// Widget _handleWindowDisplay(){
//   return StreamBuilder(
//     stream: FirebaseAuth.instance.onAuthStateChanged,
//     builder: (BuildContext context, snapshot){
//       // if(snapshot.connectionState == ConnectionState.waiting){
//       //   return Center(child: Text("Loading"),); 
//       // }
//       // else{
//         if(snapshot.hasData){
//           return AccountScreen(myaccount);
//         }
//         else return LoginScreen();
//       // }
//     },
//   );
// }

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _currentTabIndex = 0;
  final Account myaccount = Account('Himanshu','himanshu17291@iiitd.ac.in','Student');
  List<BottomNavigationBarItem> _bottomBarItems;
  var roomCalled =false;
  Buildings building;
  final List<Buildings> spaceOptions = [
    Buildings('Library',5,[Spaces('LR1',[2,3,4,5]),Spaces('LR2',[8,9,10,11,12])]),
    Buildings('Old Acad',6,null),
    Buildings('R&D Building',5,null),
    Buildings('Seminar Building',5,null),
    Buildings('Sports Courts',3,null)
  ];


  void _bottomBarButtonTap(index) {
    setState(() {
      _currentTabIndex = index;
    });
    print(_currentTabIndex);
  }

  BottomNavigationBar bottomBar()
  {
    if(myaccount.privilage==3)
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
      this.building=building;
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
      SingleChildScrollView(child: SearchSpaceHome(spaceOptions,_callRoom),),
      Center(
        child: Icon(Icons.event, size: 64.0, color: Colors.teal),
      ),
      AccountScreen(myaccount),
    ];

    Widget _chooseBody()
    {
      if(roomCalled && _currentTabIndex==0)
        {
          return Room(this.building,_callRoomExit);
        }
      return _kTabPages[_currentTabIndex];
    }


    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.purple),
        // home: _handleWindowDisplay(),
        home: Scaffold(
          appBar: AppBar(title: Text("Space Booking")),
          body:_chooseBody(),
          bottomNavigationBar: bottomBar(),//BottomBar(_bottomBarButtonTap),
        ));
    // );
  }
}

//Center(child: _kTabPages[_currentTabIndex])
