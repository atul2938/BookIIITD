import 'package:flutter/material.dart';
import '../models/Buildings.dart';
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
        children:spaceOptions.map((building) {
      return Container(
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height*0.12,
        width: double.infinity,
        child: RaisedButton(
          color: Color.fromRGBO(0, 160, 165, 70),
          child: Text(building.name,style: TextStyle(color: Colors.white,fontSize:20 ),),
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
