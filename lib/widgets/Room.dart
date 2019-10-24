import 'package:flutter/material.dart';
import 'package:project1_app/models/Request.dart';

//import 'package:intl/intl.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:project1_app/models/Spaces.dart';
import 'package:project1_app/models/TimeSlots.dart';
import '../models/Buildings.dart';

class Room extends StatefulWidget {
  Buildings building;
  Function callRoomExit;
  List<Spaces> spaces;
  Spaces currentSpace;
  TimeSlots dropDownValue;
  String dropDownValueStart;
  String dropDownValueEnd;
  String description;
  String startTime;
  String  endTime;

  Room(building, callRoomExit) {
    this.building = building;
    this.callRoomExit = callRoomExit;
    if (building.spaces != null) {
      this.spaces = building.spaces;
      this.currentSpace = this.spaces[0];
      this.dropDownValue = this.currentSpace.timeSlots[0];
      this.dropDownValueStart = this.dropDownValue.startTime.toString();
      this.dropDownValueEnd = this.dropDownValue.endTime.toString();

    }
  }

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
//  RangeValues _values = RangeValues(0.3, 0.7);

  Widget showSpaceOptions() {
    if (widget.spaces == null) {
      return Text('NO Space options ');
    }
    return Column(
        children: widget.spaces.map((building) {
      return Container(
        margin: EdgeInsets.all(10),
        height: 70,
        width: double.infinity,
        child: RaisedButton(child: Text(building.name), onPressed: () {}),
      );
    }).toList());
  }

  Widget showHeading() {
    return Row(
      //1
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20),
          child: FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              widget.callRoomExit();
            },
          ),
        ),
        Center(
          child: Text(
            widget.building.name,
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget showSpacesButtons() {
    return GridView.count(
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      children: widget.spaces.map((spaces) {
        return Container(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
                child: Text(spaces.name),
                onPressed: () {
                  setState(() {
                    widget.currentSpace = spaces;
                    widget.dropDownValue = widget.currentSpace.timeSlots[0];
                  });
                }));
      }).toList(),
    );
  }

  void submitRequest() {
    Request(
        widget.building, widget.startTime, widget.endTime, widget.description);
  }

  Widget showBookSection() {
    return Card(
      elevation: 2,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'Book Your Space',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DropdownButton<String>(
                value: widget.dropDownValueStart,
                icon: Icon(Icons.arrow_drop_down_circle),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (newValue) {
                  setState(() {
                    widget.dropDownValueStart = newValue;
                    print(widget.dropDownValueStart);
                  });
                },
                items: widget.currentSpace.timeSlots
                    .map<DropdownMenuItem<String>>((value) {
                  widget.startTime = value.startTime.toString();
                  return DropdownMenuItem<String>(
                    value: value.endTime.toString(),
                    child: Text('From: ' + value.toString()),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: widget.dropDownValueEnd,
                icon: Icon(Icons.arrow_drop_down_circle),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (newValue) {
                  setState(() {
                    widget.dropDownValueEnd = newValue;
                    print('endtime'+widget.dropDownValueEnd);
                  });
                },
                items: widget.currentSpace.timeSlots
                    .map<DropdownMenuItem<String>>((value) {
                  widget.endTime = value.endTime.toString();
                  return DropdownMenuItem<String>(
                    value: value.endTime.toString(),
                    child: Text('Till: ' + value.endTime.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            decoration: InputDecoration(
//            border: InputBorder.none,
                border: OutlineInputBorder(),
                hintText: 'Enter the description'),
            onSubmitted: (value) {
              widget.description = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                child: Text('BookIt'),
                onPressed: () {
                  submitRequest();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void showModelScreen(ctx)
  {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
            height: 200,
            child: GestureDetector(
              onTap: () {},
              child: Text('Text will be displayed'),
            ),
          );
        });
  }

  Widget showTimeSlots(ctx) {
    return Column(
      children: <Widget>[
        Text(
          'Time Slots',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        GridView.count(
          crossAxisCount: 4,
          scrollDirection: Axis.vertical,
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          children: widget.currentSpace.timeSlots.map((time) {
            return Container(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                    child: Text(time.startTime.toString()+" "+time.endTime.toString()),
                    onPressed: () { //here timeslots button is pressed
                      showModelScreen(ctx);
                    }));
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        showHeading(),
//        showSpaceOptions(),
        Divider(), // Now Displaying Space Options
        showSpacesButtons(),
        Divider(), //Selecting Time

        showBookSection(),
        Divider(),
        showTimeSlots(context),
        Divider(),
      ],
    );
  }
}
