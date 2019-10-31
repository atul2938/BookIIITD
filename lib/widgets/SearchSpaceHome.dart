import 'package:flutter/material.dart';
import 'package:project1_app/models/Buildings.dart';
//import './Room.dart';

class SearchSpaceHome extends StatelessWidget {
   List<Buildings> spaceOptions;
   Function callRoom;

  SearchSpaceHome(spaceOptions,funcToCallRoom)
  {
    this.spaceOptions=spaceOptions;
    this.callRoom = funcToCallRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: spaceOptions.map((building) {
      return Container(
        margin: EdgeInsets.all(10),
        height: 70,
        width: double.infinity,
        child: RaisedButton(
          child: Text(building.name),
          onPressed: () {
            print("ButtonPressed");
            callRoom(building);
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => Room(building)),
//            );
          }
        ),
      );
    }).toList());
  }
}
