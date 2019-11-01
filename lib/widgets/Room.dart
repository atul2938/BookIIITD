import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter/material.dart';
import '../models/Request.dart';


//import 'package:intl/intl.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../models/Spaces.dart';
import '../models/TimeSlots.dart';
import '../models/Buildings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';


class Room extends StatefulWidget {
  Buildings building;
  Function callRoomExit;
  List<Spaces> spaces;
  Spaces currentSpace;
  TimeSlots dropDownValueTimeSlot;
  String dropDownValueStart;
  String dropDownValueEnd;
  String description;
  bool underProgress=true;
  List<TimeSlots> validTimeSlots;
  List<String> days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
  final Dref = FirebaseDatabase.instance.reference();
//  String startTime;
//  String endTime;

  Room(building, callRoomExit) {
    print(building.toString());
    this.building = building;
    this.callRoomExit = callRoomExit;
    if (building.spaces != null) {
      this.spaces = building.spaces;
      this.currentSpace = this.spaces[0];
      this.validTimeSlots = List.from(this.currentSpace.timeSlots.where((slot)=>slot.day==days[DateTime.now().weekday-1]));
      this.dropDownValueTimeSlot = this.validTimeSlots[0];
      this.dropDownValueStart = this.dropDownValueTimeSlot.startTime.toString();
      this.dropDownValueEnd = this.dropDownValueTimeSlot.endTime.toString();
      print(this.dropDownValueStart+" "+this.dropDownValueEnd);
      print(this.validTimeSlots.runtimeType);
    }
    underProgress=false;
  }

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
//  RangeValues _values = RangeValues(0.3, 0.7);


//  Widget showSpaceOptions() {
//    if (widget.spaces == null) {
//      return Text('NO Space options ');
//    }
//    return Column(
//        children: widget.spaces.map((building) {
//      return Container(
//        margin: EdgeInsets.all(10),
//        height: 70,
//        width: double.infinity,
//        child: RaisedButton(child: Text(building.type), onPressed: () {}),
//      );
//    }).toList());
//  }

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
        SizedBox(
          width: MediaQuery.of(context).size.width*0.12,
        ),
        Center(
          child: Text(
            widget.building.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }


  String _findFloor(floorno)
  {
    var fno = int.parse(floorno);
    List<String> temp = ['Ground','First','Second','Third','Fourth','Fifth','Sixth''Seventh'];
    if(fno>=temp.length){
      return floorno+ "  Floor";
    }
    return temp[fno]+" Floor";
  }

  Widget showSpacesButtons() {
    return GridView.count(
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      children: widget.spaces.map((space) {
        return Container(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
                color: Color.fromRGBO(136, 86, 204, 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(space.name,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    Text(space.type,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),),
                    Text(_findFloor(space.floorNo.toString()),style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),)
                  ],
                ),
                onPressed: () {
                  setState(() {

                    widget.currentSpace = space;
                    widget.validTimeSlots = List.from(widget.currentSpace.timeSlots.where((slot)=>slot.day==widget.days[DateTime.now().weekday-1]));
                    widget.dropDownValueTimeSlot = widget.validTimeSlots[0];
                    widget.dropDownValueStart = widget.dropDownValueTimeSlot.startTime.toString();
                    widget.dropDownValueEnd = widget.dropDownValueTimeSlot.endTime.toString();
//                    print(this.dropDownValueStart+" "+this.dropDownValueEnd);
                  });
                  showAlertBox("Information about the Choosen Space", widget.currentSpace.name.toString() +
                      " is a "+widget.currentSpace.type.toString()+" at "+_findFloor(widget.currentSpace.floorNo.toString())+
                      " with capacity "+ widget.currentSpace.capacity.toString());
                }));
      }).toList(),
    );
  }

  void showAlertBox(title,content)
  {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: Text(content),
          );
        }
    );
    return;
  }

  int _getIntTime(timeString)
  {
    var s =timeString;
    var hmlist=s.split(":");
    var h = int.parse(hmlist[0]);
    var min = int.parse(hmlist[1]);
    return (h*60+min);

  }

  void submitRequest() {
    print("INside ReQUESTS");
    var stime = _getIntTime(widget.dropDownValueStart);
    var etime = _getIntTime(widget.dropDownValueEnd);
    var duration = etime-stime;
    print(stime.toString()+" "+etime.toString());
    if(stime>=etime)
      {
        showAlertBox("Error", "Incorrect range of timings entered");
        return;
      }
    if((widget.building.name=='Library Building' || widget.building.name=='Sports Block') && duration>60)
      {
        showAlertBox("Error","Cannot Book for more than 1 hour" );
        return;
      }
    showAlertBox("Successful Submission", "Your request has been recorded and will be processed soon");
    _uploadRequest(Request(widget.building.name, widget.currentSpace.name,widget.dropDownValueStart,
        widget.dropDownValueEnd, widget.description,'false'));

  }
  _uploadRequest(Request request) async
  {
    await widget.Dref.child('Requests').child(request.startTime+request.endTime).set(json.encode(request.toJson()));
  }

  Widget showBookSection() {
    print("its here");
    var stime = widget.dropDownValueStart;
    var etime = widget.dropDownValueEnd;
    print(widget.dropDownValueEnd+ "  in showbook "+widget.dropDownValueStart);
    return Card(
      color: Color.fromRGBO(211, 211, 211, 100),
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
              Text('From..'),
              DropdownButton<String>(
                value:widget.dropDownValueStart,
                icon: Icon(Icons.arrow_drop_down_circle),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (newValue) {
//                  stime = newValue;
                  setState(() {
                    widget.dropDownValueStart = newValue;
//                    widget.startTime=newValue;
                  });
                  print(widget.dropDownValueStart);
                },
                items: widget.validTimeSlots
                    .map<DropdownMenuItem<String>>((value) {
//                  widget.startTime = value.startTime.toString();
//                  print("Coming inide map+ "+widget.currentSpace.timeSlots.length.toString());
                  return DropdownMenuItem<String>(
                    value: value.startTime.toString(),
                    child: Text(value.startTime.toString()),
                  );
                  }).toList(),

              ),
//              SizedBox(width: MediaQuery.of(context).size.width*03,),

              Text('Till..'),
              DropdownButton<String>(
                value:widget.dropDownValueEnd,
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

//                    widget.endTime = newValue;
                    print('endtime' + widget.dropDownValueEnd);
                  });
                },
                items: widget.validTimeSlots
                    .map<DropdownMenuItem<String>>((value) {
//                  widget.endTime = value.endTime.toString();
                  return DropdownMenuItem<String>(
                    value: value.endTime.toString(),
                    child: Text(value.endTime.toString()),
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
                hintText: 'Enter the description...eg - Project Discussion etc '),
            onChanged: (value){
              widget.description=value;
            },
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

  void showModelScreen(ctx,TimeSlots time) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height*0.40,
            color: Color.fromRGBO(0, 160, 165, 70),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Time slot ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                  Text(time.startTime+"-"+time.endTime,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                  Text('Status- '+(time.isVacant?'Vacant':'Occupied'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
                  Text("Reason- "+time.purpose,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                ],
              ),
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
          children: widget.validTimeSlots.map((time) {
            return Container(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  color: time.isVacant?Colors.lightGreen:Colors.redAccent,
                    child: Text(time.startTime.toString() +"-\n" +time.endTime.toString()+"\n"+time.day,
                      style:TextStyle(fontSize:10,fontWeight:FontWeight.w500) ,),
                    onPressed: () {
                      //here timeslots button is pressed
                      showModelScreen(ctx,time);
                    }));
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.underProgress?Container(child: Center(child: CircularProgressIndicator(),),):
    ListView(
      children: <Widget>[
        Container(height: MediaQuery.of(context).size.height*0.08, child: showHeading()),
//        showSpaceOptions(),
        Divider(), // Now Displaying Space Options
        Container(height: MediaQuery.of(context).size.height*0.25, child: showSpacesButtons()),
        Divider(), //Selecting Time

        showBookSection(),
        Divider(),
        showTimeSlots(context),
        Divider(),
      ],
    );
  }
}
