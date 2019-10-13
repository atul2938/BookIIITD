import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget{
  Function buttonPress;
  var privalageLevel=1;
  var currentTabIndex = 0;
  var _bottomBarItems;


  BottomBar(buttonPress)
  {
    this.buttonPress = buttonPress;

    if(privalageLevel==3)
    {
      this._bottomBarItems = <BottomNavigationBarItem>[
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
  }


  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
//      backgroundColor: Theme.of(context).primaryColor,
      items: _bottomBarItems,
      currentIndex: currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        currentTabIndex = index;
        print('Inside Bottom Bar');
        print(currentTabIndex);
        buttonPress(index);
      },
    );
  }

}