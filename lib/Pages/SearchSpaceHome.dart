import 'package:flutter/material.dart';
import '../models/Buildings.dart';
//import './Room.dart';

class SearchSpaceHome extends StatelessWidget {
//   List<Buildings> spaceOptions;
  List<String> spaceOptions;
   Function callRoom;

  SearchSpaceHome(funcToCallRoom)
  {
    this.spaceOptions=['Library Building','Old Academic Block','R&D Block','Seminar Block ','Sports Block'];
//    this.spaceOptions=spaceOptions;
    this.callRoom = funcToCallRoom;
  }

  @override
  Widget build(BuildContext context) {
    var list = ["assets/images/building.jpg", "assets/images/events.png"];
    var common_height =MediaQuery.of(context).size.height*0.145;
    return Column(
        children:spaceOptions.map((building) {
          return Container(
            margin: EdgeInsets.all(10),
            height: common_height,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height:common_height,
                  child: Image(image: AssetImage("assets/images/newacad.jpeg"),fit: BoxFit.fill),
                ),
                Container(
                  width: double.infinity,
                  height:common_height,
                  child: RaisedButton(
                      color: Colors.transparent,
//                child: Image(image: AssetImage("assets/images/building.jpg")), //Text(building,style: TextStyle(color: Colors.white,fontSize:20 ),),
                      onPressed: () {
                        print("ButtonPressed");
                        callRoom(building);
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => Room(building)),
//            );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(building,style: TextStyle(color: Colors.white,fontSize:20 ),),
                ),
              ],
            ),
          );
        }).toList());
  }
}