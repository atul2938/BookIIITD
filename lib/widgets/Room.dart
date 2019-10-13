import 'package:flutter/material.dart';
import 'package:project1_app/models/Spaces.dart';
import '../models/Buildings.dart';

class Room extends StatelessWidget {
  Buildings building;
  Function callRoomExit;
  List<Spaces> spaces;

  Room(building, callRoomExit) {
    this.building = building;
    this.callRoomExit = callRoomExit;
    this.spaces = building.spaces;
  }

  Widget showSpaceOptions() {
    if (spaces == null) {
      return Text('NO Space options ');
    }
    return Column(
        children: spaces.map((building) {
      return Container(
        margin: EdgeInsets.all(10),
        height: 70,
        width: double.infinity,
        child: RaisedButton(child: Text(building.name), onPressed: () {}),
      );
    }).toList());
  } //showSpaceOptions function

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          //1
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: FloatingActionButton(
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  callRoomExit();
                },
              ),
            ),
            Center(
              child: Text(
                building.name,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        showSpaceOptions(),
      ],
    );
  }
}
