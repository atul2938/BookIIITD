import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/Buildings.dart';
import 'PreviousRequests.dart';
import 'dart:convert';
import 'RecentRequests.dart';
import '../models/Request.dart';
import '../models/TimeSlots.dart';

class AdministratorPage extends StatefulWidget {
  final Dref = FirebaseDatabase.instance.reference();
  List<Request> requests = List<Request>();
  List<String> testList = ["a", "bsjddn", "leys"];
  List<Buildings> allBuilding;
  int tab=0;
  List<Widget> subBody = [RecentRequests(),PreviousRequests()];

  @override
  _AdministratorPageState createState() => _AdministratorPageState();
}

class _AdministratorPageState extends State<AdministratorPage> {
  bool gotData = false;

  @override
  void initState() {
    super.initState();
//    getRequests();
//    getDatabase();
  }

  void getDatabase() async {
    List<Buildings> b = List<Buildings>();
    Buildings building;
    List<String> names = [
//      'Library Building',
      'Old Academic Block',
      'R&D Block',
      'Seminar Block ',
//      'Sports Block'
    ];

    for (int i = 0; i < names.length; i++) {
      DataSnapshot dataSnapshot =
          await widget.Dref.child('Buildings').child(names[i]).once();
      if (dataSnapshot.value[1] != null) {
        print("dataSnapshot");
        print(dataSnapshot.value);
        print('INside here');
        building = Buildings.fromMappedJson(json.decode(dataSnapshot.value));
        print(building.name);
        b.add(building);
      }
    }
    if (b.length == 5) {
      setState(() {
        gotData = true;
      });
    }
    widget.allBuilding = b;
  }

  void getRequests() async {
    List<Request> reqList = List<Request>();
    DataSnapshot dataSnapshot = await widget.Dref.child('Requests').once();
    print(dataSnapshot.value);
    print(dataSnapshot.value.length);
    print(dataSnapshot.value.runtimeType);
    Map<dynamic, dynamic> values = dataSnapshot.value;
    values.forEach((key, values) {
      print(values);
      print(values.runtimeType);
      Request tempR = Request.fromMappedJson(json.decode(values));
      print(tempR.buildingName);
      print(tempR.toString());
      reqList.add(tempR);
    });
    setState(() {
      widget.requests = reqList;
    });
  }

  Widget _showHeading() {
    return Column(
      //1
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Center(
          child: Text(
            'Administration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
//        SizedBox(
//          height: MediaQuery.of(context).size.height*0.03,
//        ),
      ],
    );
//    return Card(
//      child: Text('Administration'),
//    );
  }

  Widget _showOptions() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
//          SizeBox(
//            width: MediaQuery.of(context).size.width * 0.03,
//          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text('Show Requests'),
            onPressed: () {
//              getRequests();
              setState(() {
                widget.tab=0;
              });
            },
          ),
//          SizedBox(
//            width: MediaQuery.of(context).size.width * 0.03,
//          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text('Previous Requests'),
            onPressed: () {
              setState(() {
                widget.tab=1;
              });
            },
          ),
//          SizedBox(
//            width: MediaQuery.of(context).size.width * 0.03,
//          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
              child: Text('Upload CSV'),
                 onPressed: null,

          ),
//          SizedBox(
//            width: MediaQuery.of(context).size.width * 0.03,
//          )
        ],
      ),
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

  Future<dynamic> showRejectAlertBox(title,content)
  {
    String description = 'Sorry... can\'t accept' ;
    var textCompleter = Completer();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: Container(
              height: MediaQuery.of(context).size.height*0.50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(content),
                  TextField(
                    autocorrect: false,
//                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
//            border: InputBorder.none,
                        border: OutlineInputBorder(),
                        hintText: 'Enter the remarks...eg - booked for other purposes etc '),
                    onChanged: (value){
                      description=value;
                    },
                    onSubmitted: (value) {

                      description = value;
//                    textCompleter.complete(description);
                      },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    textCompleter.complete(description);
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('DONE'),
                  onPressed: () {
                    textCompleter.complete(description);
                    Navigator.pop(context);
                  })
            ],
          );
        }
    );
    return textCompleter.future;
  }

  _bookRequest(Request request,int index)
  {
    print('IN here ...Book request body');
    int bindex = widget.allBuilding.indexWhere((b) => b.name==request.buildingName);
    print('bindex ${bindex}');
    int sindex = widget.allBuilding[bindex].spaces.indexWhere((s) => s.name==request.spaceName);
    List<TimeSlots> validTimeSlots = List.from(widget.allBuilding[bindex].spaces[sindex].timeSlots.where((slot)=>slot.day==request.day));

    String start=request.startTime;
    String end=request.endTime;

    bool startFound=false;
    // checking for validity
    for(int i=0;i<validTimeSlots.length;i++)
    {
      if(validTimeSlots[i].startTime==start || startFound)
      {
        startFound=true;
        if(validTimeSlots[i].isVacant==false)
        {
          print("Error "+"cannot book an already booked space for "+
              validTimeSlots[i].startTime+" to "+validTimeSlots[i].endTime);
          return;
        }
        if(validTimeSlots[i].endTime==end) {
          break;
        }
      }

    }
    // book rooms now
    startFound=false;

    for(int i=0;i<validTimeSlots.length;i++)
    {
      if(validTimeSlots[i].startTime==start || startFound)
      {
        startFound=true;
        validTimeSlots[i].isVacant=false;
        validTimeSlots[i].purpose= request.description;
        if(validTimeSlots[i].endTime==end) {
          break;
        }
      }
    }

    int timeslotIndex1 = widget.allBuilding[bindex].spaces[sindex].timeSlots.indexWhere((timeslot) => timeslot.day==request.day);
    int timeslotIndex2 =widget.allBuilding[bindex].spaces[sindex].timeSlots.lastIndexWhere((timeslot) => timeslot.day==request.day);
    widget.allBuilding[bindex].spaces[sindex].timeSlots.replaceRange(timeslotIndex1, timeslotIndex2, validTimeSlots);

    _postChanges(bindex,index,request);
  }

  _postChanges(bindex,reqindex,Request request) async
  {
    // make changes to building
    await widget.Dref.child('Buildings').child(widget.allBuilding[bindex].name).set(
        json.encode(widget.allBuilding[bindex].toJson()));

    // approving request, adding to previous requests section, deleting it locally and centrally
    String key=request.username+'_'+request.spaceName+'_'+request.day+'_'+request.startTime+'_'+request.endTime;
    widget.requests[reqindex].isApproved='true';
    request.isApproved ='true';
    widget.requests[reqindex].remarks='Approved by administration';
    request.remarks='Approved by administration';
    showAlertBox("Booking Confirmation", "Booking is succesful");
    widget.Dref.child('PreviousRequest').child(request.username).set(json.encode(request.toJson())).then((_) {

      widget.Dref.reference().child("Requests").child(key).remove().then((_) {
        print("Delete ${request.spaceName} successful after approving");
        print('DIDNT wait for remarks');
        setState(() {
          widget.requests.removeAt(reqindex);
        });
      });
    });
    setState(() {
      widget.requests.removeAt(reqindex);
    });
  }


  _rejectIt(Request request,int index)
  {
    request.isApproved='false';
    showRejectAlertBox('Rejected', 'Enter the remarks').then((notifyText){
      //send notification
      print('recieved notify text');
      print(notifyText);
      request.isApproved ='false';
      widget.requests[index].remarks=notifyText as String;
      request.remarks=notifyText as String;
      showAlertBox("Booking Confirmation", "Booking is succesful");
      String key=request.username+'_'+request.spaceName+'_'+request.day+'_'+request.startTime+'_'+request.endTime;
      widget.Dref.child('PreviousRequest').child(key).set(json.encode(request.toJson())).then((_) {

        widget.Dref.reference().child("Requests").child(key).remove().then((_) {
          print("Delete ${request.spaceName} successful");
          print('DIDNT wait for remarks');
          setState(() {
            widget.requests.removeAt(index);
          });
        });
      });
    });


  }

  Widget _showSubHeading()
  {
    return Column(
      //1
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Center(
          child: Text(
            widget.tab==0?'List of Recent Requests':'List of Previous Requests',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
//        SizedBox(
//          height: MediaQuery.of(context).size.height*0.03,
//        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _showHeading(),
        _showOptions(),
        _showSubHeading(),
//        Divider(),
        widget.subBody[widget.tab],

//        Expanded(
////      height: MediaQuery.of(context).size.height*0.60,
//          child: new ListView.builder(
//              itemCount: widget.requests.length,
//              itemBuilder: (BuildContext ctxt, int index) {
//                return widget.requests[index].isApproved=='false' ? Container(
//                    height: MediaQuery.of(context).size.height * 0.10,
//                    child: Card(
//                        child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              widget.requests[index].spaceName +
//                                  " in " +
//                                  widget.requests[index].buildingName,
//                              style: TextStyle(
//                                  fontSize: 14, fontWeight: FontWeight.w600),
//                            ),
//                            Text(
//                              "From " +
//                                  widget.requests[index].startTime +
//                                  " till " +
//                                  widget.requests[index].endTime,
//                              style: TextStyle(
//                                  fontSize: 12, fontWeight: FontWeight.w400),
//                            ),
//                            Text(
//                                "Reason -" +
//                                    widget.requests[index].description
//                                        .toString(),
//                                style: TextStyle(
//                                    fontSize: 12, fontWeight: FontWeight.w300)),
//                          ],
//                        ),
//                        FloatingActionButton(
//                          backgroundColor: Colors.lightGreen,
//                          child: Icon(Icons.check),
//                          onPressed: (){
//                            _bookRequest(widget.requests[index],index);
//                          },
//                        ),
//                        FloatingActionButton(
//                          backgroundColor: Colors.redAccent,
//                          child: Icon(Icons.cancel),
//                          onPressed: (){
//                            _rejectIt(widget.requests[index],index);
//                          },
//                        )
//                      ],
//                    ))): SizedBox();
//              }),
//        ),
////      _contentBody(),
      ],
    );
  }
}
