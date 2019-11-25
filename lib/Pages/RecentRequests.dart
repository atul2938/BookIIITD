import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project1_app/models/Buildings.dart';
import 'dart:convert';
import 'package:project1_app/models/Request.dart';
import 'package:project1_app/models/TimeSlots.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class RecentRequests extends StatefulWidget {
  final Dref = FirebaseDatabase.instance.reference();
  List<Request> requests = List<Request>();
  List<String> testList = ["a", "bsjddn", "leys"];
  List<Buildings> allBuilding;
  bool gotData = false;
  @override
  _RecentRequestsState createState() => _RecentRequestsState();
}

class _RecentRequestsState extends State<RecentRequests> {


  @override
  void initState() {
    super.initState();
    getRequests();
    getDatabase();
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
    if (b.length == 3) {
      setState(() {
        widget.gotData = true;
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
      // setting key directly
      Request tempR = Request.fromMappedJson(json.decode(values));
//      tempR.key=key;
//      Request tempR = Request.fromSnapshot(dataSnapshot);
      print(tempR.buildingName);
      print(tempR.toString());
      reqList.add(tempR);
    });
    setState(() {
      widget.requests = reqList;
    });
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

  void showAnimatedAlertBox(title,content)
  {
    showDialog(
      context: context,
      builder: (_) => NetworkGiffyDialog(
        image :Image.network("https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif"),
        title: Text('Granny Eating Chocolate',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w600)),
        description:Text('This is a granny eating chocolate dialog box. This library helps you easily create fancy giffy dialog',
        textAlign: TextAlign.center,
      ),
      entryAnimation: EntryAnimation.DEFAULT,
      onOkButtonPressed: () {},
    ) );
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
    print('posting changes');
    await widget.Dref.child('Buildings').child(widget.allBuilding[bindex].name).set(
        json.encode(widget.allBuilding[bindex].toJson()));

    // approving request, adding to previous requests section, deleting it locally and centrally
//    String key=request.username+'_'+request.spaceName+'_'+request.day+'_'+request.startTime+'_'+request.endTime;
    String key = request.key;
    widget.requests[reqindex].isApproved='true';
    request.isApproved ='true';
    widget.requests[reqindex].remarks='Approved by administration';
    request.remarks='Approved by administration';
    showAlertBox("Booking Confirmation", "Booking is succesful");

    widget.Dref.child('PreviousRequest').child(key).set(json.encode(request.toJson())).then((_) {

      widget.Dref.child('UserRequestRecord').child(request.username+request.userId).child(key).set(json.encode(request.toJson())).then((_){
        widget.Dref.reference().child("Requests").child(key).remove().then((_) {

          print("Delete ${request.spaceName} successful after approving");
          print(request.username+ " "+ request.userId);
          if(request.makeItEvent=='true')
          {
            widget.Dref.child('Events').child(key).set(json.encode(request.toJson()));
          }
          print('DIDNT wait for remarks');
          setState(() {
            widget.requests.removeAt(reqindex);
          });
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
      request.isRejected='true';
      widget.requests[index].remarks=notifyText as String;
      request.remarks=notifyText as String;

      showAlertBox("Request Cancellation", "Request has been cancelled");
//      String key=request.username+'_'+request.spaceName+'_'+request.day+'_'+request.startTime+'_'+request.endTime;
      String key = request.key;
      widget.Dref.child('PreviousRequest').child(key).set(json.encode(request.toJson())).then((_) {

        widget.Dref.child('UserRequestRecord').child(request.username+request.userId).child(key).set(json.encode(request.toJson())).then((_){
          widget.Dref.reference().child("Requests").child(key).remove().then((_) {
            print("Delete ${request.spaceName} successful");
            print('DIDNT wait for remarks');
            setState(() {
              widget.requests.removeAt(index);
            });
          });
        });
      });
    });


  }

  Widget _nodataDisplay()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: Icon(Icons.watch_later, size: 64.0, color: Colors.teal),),
        Text('No Requests to show !'),
      ],
    );
  }

  void showModelScreen(ctx,Request request) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          String title =request.makeItEvent=='true'?request.eventDetails.split('&events&')[0]:"Not provided";
          String hastags = 'Not Provided';
          hastags = request.makeItEvent=='true'?(request.eventDetails.contains('&events&')?request.eventDetails.split('&events&')[1]:"Not provided")
                  :"Not provided";

          return Container(
            height: MediaQuery.of(context).size.height*0.40,
            color: Color.fromRGBO(0, 160, 165, 70),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Request made by '+ request.username,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                  Text('For '+request.spaceName +', '+request.buildingName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                  Text('Time - '+request.startTime+' - '+request.endTime+' on '+request.day,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
                  Text(request.makeItEvent=='true'?"Request to make it a event - "+'Yes':"Request to make it a event - "+'No',
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                  Text("Description - "+request.description,
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                  request.makeItEvent=='true'?Column(
                    children: <Widget>[
                      Text('Title for the Event - '+title,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                      Text('Hashtags '+hastags,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)
                    ],
                  ):SizedBox(),

                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {


        return !widget.gotData?Center(child:LinearProgressIndicator()):
        widget.requests.length==0?_nodataDisplay():
        Expanded(
//      height: MediaQuery.of(context).size.height*0.60,
          child: new ListView.builder(
              itemCount: widget.requests.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return widget.requests[index].isApproved=='false' ? Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.007,
                                ),
                                Text(
                                  "By " +
                                      widget.requests[index].username,
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.requests[index].spaceName +
                                      " in " +
                                      widget.requests[index].buildingName,
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "From " +
                                      widget.requests[index].startTime +
                                      " till " +
                                      widget.requests[index].endTime+" on "+widget.requests[index].day,
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.35,
                                  child: Text(
                                      "Reason -" +
                                          widget.requests[index].description
                                              .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.w300)),
                                ),
                                Text(
                                      widget.requests[index].makeItEvent=='true'?"Make it an event - " +'Yes':"Make it an event - " +'No'
                                      ,
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w400),
                                ),
                                OutlineButton(
                                  child: Text('More Details'),
                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  onPressed: (){
                                    showModelScreen(context, widget.requests[index]);
                                  },
                                )
                              ],
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.lightGreen,
                              child: Icon(Icons.check),
                              onPressed: (){
                                _bookRequest(widget.requests[index],index);
                              },
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.redAccent,
                              child: Icon(Icons.cancel),
                              onPressed: (){
                                _rejectIt(widget.requests[index],index);
                              },
                            )
                          ],
                        ))): SizedBox();
              }),
        );
//      _contentBody(),


  }
}
