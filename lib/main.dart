import 'package:flutter/material.dart';

import './widgets/BottomBar.dart';
import './widgets/SearchSpaceHome.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _currentTabIndex = 0;

  void _bottomBarButtonTap(index) {
    setState(() {
      _currentTabIndex = index;
    });
    print(_currentTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Center(
        child: Icon(Icons.search, size: 64.0, color: Colors.teal),
      ),
      Center(
        child: Icon(Icons.event, size: 64.0, color: Colors.teal),
      ),
      Center(
        child: Icon(Icons.account_circle, size: 64.0, color: Colors.teal),
      ),
    ];

//    final _bottomBarItems = <BottomNavigationBarItem>[
//      BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
//      BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events')),
//      BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('MyProfile'))
//    ];
//
//    final bottomNavBar = BottomNavigationBar(
//      items: _bottomBarItems,
//      currentIndex: _currentTabIndex,
//      type: BottomNavigationBarType.fixed,
//      onTap: (int index) {
//        setState(() {
//          _currentTabIndex = index;
//        });
//      },
//    );

    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.purple),
        home: Scaffold(
          appBar: AppBar(title: Text("Space Booking")),
          body: _currentTabIndex == 0
              ? SingleChildScrollView(child: SearchSpaceHome())
              : Center(child: _kTabPages[_currentTabIndex]),
          bottomNavigationBar: BottomBar(_bottomBarButtonTap),
        ));
  }
}

//Center(child: _kTabPages[_currentTabIndex])
