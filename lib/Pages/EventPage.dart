import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/Account.dart';
//import 'package:flutter/material.dart';
import '../models/Request.dart';
import 'dart:async';
import 'package:async/async.dart';
//import 'package:intl/intl.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../models/Spaces.dart';
import '../models/TimeSlots.dart';
import '../models/Buildings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:easy_dialog/easy_dialog.dart';


class EventPage extends StatefulWidget {
  List<Request> event_requests = List<Request>();
  final Dref = FirebaseDatabase.instance.reference();
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _eventsRequestsAddedSubscription;
  StreamSubscription<Event> _eventsRequestsChangedSubscription;

  Query _eventsRequestsQuery;

  //bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();


//    _todoList = new List();
    widget.event_requests= List();
    _eventsRequestsQuery = _database
        .reference()
        .child("Events");
    _eventsRequestsAddedSubscription = _eventsRequestsQuery.onChildAdded.listen(onEntryAdded);
    _eventsRequestsChangedSubscription =
        _eventsRequestsQuery.onChildChanged.listen(onEntryChanged);
//    getEventRequests();
  }

  @override
  void dispose() {
    _eventsRequestsAddedSubscription.cancel();
    _eventsRequestsChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = widget.event_requests.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      widget.event_requests[widget.event_requests.indexOf(oldEntry)] =
          Request.fromMappedJson(jsonDecode(event.snapshot.value));
      print('ONEntryChanged');
      print(widget.event_requests[widget.event_requests.indexOf(oldEntry)]);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      print('Added snapshot ');
      print(event.snapshot.value);
      widget.event_requests.add(Request.fromMappedJson(jsonDecode(event.snapshot.value)));
      print(widget.event_requests.length);
    });
  }





  void getEventRequests() async {
    List<Request> reqList = List<Request>();
    DataSnapshot dataSnapshot = await widget.Dref.child('Events').once();
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
      widget.event_requests = reqList;
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Check out the Events',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          )]);
  }


  void showCustomDialog(title,content)
  {
    final radius =10.0;
    EasyDialog(
        closeButton: false,
        cornerRadius: radius,
        fogOpacity: 0.2,
        width: MediaQuery.of(context).size.width*0.8,
        height: MediaQuery.of(context).size.height*0.5,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        descriptionPadding:
        EdgeInsets.only(left: 17.5, right: 17.5, bottom: 15.0),
        description: Text(
          content,
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        ),
        topImage:
        ExactAssetImage('assets/images/event2.jpg',),
        contentPadding:
        EdgeInsets.only(top: 12.0), // Needed for the button design
        contentList: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius))),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();},
              child: Text("Okay",
                textScaleFactor: 1.3,
              ),),
          ),
        ]).show(context);
  }


  void showAnimatedAlertBox(title,content)
  {
    showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
          image :Image.network("https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif"),
          title: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600)),
          description:Text(content,
            textAlign: TextAlign.center,
          ),
          entryAnimation: EntryAnimation.DEFAULT,

        ) );
  }

  Widget _showEvents()
  {
    return Expanded(
      child: new ListView.builder(
          itemCount: widget.event_requests.length,
          itemBuilder: (BuildContext ctxt, int index) {
            print(widget.event_requests[index].eventDetails);
            String title = widget.event_requests[index].eventDetails.split('&events&')[0];
            String hashtagstemp =widget.event_requests[index].eventDetails.split('&events&')[1];
            List<String> hastagsList = hashtagstemp.split(' ');
            String hashtag ="";
            for(int i=0;i<hastagsList.length;i++)
              {
                hashtag+=hastagsList[i] + '\n';
              }
            return Container(
//              height: MediaQuery.of(context).size.height * 0.19,
              child:Card(
                elevation: 3.0,
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.purple,),
                  title: Text(title.toUpperCase()),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.005,
                      ),
                      Text(
                        "Timings - "+
                            widget.event_requests[index].startTime +
                            " - " +
                            widget.event_requests[index].endTime+" on "+
                            widget.event_requests[index].day,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),

                      Text(
                          "Venue -" +
                              widget.event_requests[index].spaceName+",  "+
                              widget.event_requests[index].buildingName,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300)),
                      OutlineButton(

                        child: Text('More Details',style: TextStyle(color: Colors.purpleAccent),),
                        onPressed: (){
                          showCustomDialog(title,
                              'Description - '+widget.event_requests[index].description);
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      )
                    ],
                  ),
                  trailing: Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Text(hashtag),
                    ],
                  ),

                ),
              ),


//                child: Card(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10),
//                    side: BorderSide(
//                      color: Colors.purple,
//                      width: 2.0,
//                    ),
//                  ),
//                    child:Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        Column(
//                              children: <Widget>[
//                                Text(
//                                  'Title here',
//                                  style: TextStyle(
//                                      fontSize: 14, fontWeight: FontWeight.w600),
//                                ),
//                                Text(
//                                  'Details - '+ widget.event_requests[index].description,
//                                  style: TextStyle(
//                                      fontSize: 12, fontWeight: FontWeight.w600),
//                                ),
//                                Text(
//                                  "Timings - From " +
//                                      widget.event_requests[index].startTime +
//                                      " till " +
//                                      widget.event_requests[index].endTime+" on "+
//                                  widget.event_requests[index].day,
//                                  style: TextStyle(
//                                      fontSize: 13, fontWeight: FontWeight.w400),
//                                ),
//                                Text(
//                                    "Venue -" +
//                                        widget.event_requests[index].spaceName+",  "+
//                                            widget.event_requests[index].buildingName,
//                                    style: TextStyle(
//                                        fontSize: 13, fontWeight: FontWeight.w300)),
//                              ],
//                            ),
//                            Text(
//                                "#hastag",
//                                style: TextStyle(
//                                    fontSize: 16, fontWeight: FontWeight.w600))
//                      ],
//                    ),
//                    )
            );
          }),
    );
  }

  Widget _showemptyText()
  {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(Icons.event, size: 64.0, color: Colors.teal),
          ),),
          SizedBox(height: 3,),
          Text('No Events to Show', style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      _showHeading(),
      Divider(
        thickness: 2.0,
      ),
      widget.event_requests.length==0? _showemptyText():_showEvents(),




    ],);
//      Center(child: Icon(Icons.event, size: 64.0, color: Colors.teal),);
  }
}

















































//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:project1_app/models/Account.dart';
////import 'package:flutter/material.dart';
//import '../models/Request.dart';
//import 'dart:async';
//import 'package:async/async.dart';
////import 'package:intl/intl.dart';
////import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import '../models/Spaces.dart';
//import '../models/TimeSlots.dart';
//import '../models/Buildings.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'dart:convert';
//
//
//
//class EventPage extends StatefulWidget {
//  List<Request> event_requests = List<Request>();
//  final Dref = FirebaseDatabase.instance.reference();
//  @override
//  _EventPageState createState() => _EventPageState();
//}
//
//class _EventPageState extends State<EventPage> {
//
//  @override
//  void initState() {
//    super.initState();
//    getEventRequests();
//  }
//
//  void getEventRequests() async {
//    List<Request> reqList = List<Request>();
//    DataSnapshot dataSnapshot = await widget.Dref.child('Events').once();
//    print(dataSnapshot.value);
//    print(dataSnapshot.value.length);
//    print(dataSnapshot.value.runtimeType);
//    Map<dynamic, dynamic> values = dataSnapshot.value;
//    values.forEach((key, values) {
//      print(values);
//      print(values.runtimeType);
//      Request tempR = Request.fromMappedJson(json.decode(values));
//      print(tempR.buildingName);
//      print(tempR.toString());
//      reqList.add(tempR);
//    });
//    setState(() {
//      widget.event_requests = reqList;
//    });
//  }
//
//  Widget _showHeading() {
//    return Column(
//      //1
//      children: <Widget>[
//        SizedBox(
//          height: MediaQuery.of(context).size.height * 0.02,
//        ),
//        Center(
//          child: Text(
//            'Check out the Events',
//            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//          ),
//        )]);
//  }
//
//
//
//  Widget _showEvents()
//  {
//    return Expanded(
//      child: new ListView.builder(
//          itemCount: widget.event_requests.length,
//          itemBuilder: (BuildContext ctxt, int index) {
//            return Container(
//                height: MediaQuery.of(context).size.height * 0.10,
//                child: Card(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10),
//                    side: BorderSide(
//                      color: Colors.purple,
//                      width: 2.0,
//                    ),
//                  ),
//                    child:Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        Column(
//                              children: <Widget>[
//                                Text(
//                                  'Title here',
//                                  style: TextStyle(
//                                      fontSize: 14, fontWeight: FontWeight.w600),
//                                ),
//                                Text(
//                                  'Details - '+ widget.event_requests[index].description,
//                                  style: TextStyle(
//                                      fontSize: 12, fontWeight: FontWeight.w600),
//                                ),
//                                Text(
//                                  "Timings - From " +
//                                      widget.event_requests[index].startTime +
//                                      " till " +
//                                      widget.event_requests[index].endTime+" on "+
//                                  widget.event_requests[index].day,
//                                  style: TextStyle(
//                                      fontSize: 13, fontWeight: FontWeight.w400),
//                                ),
//                                Text(
//                                    "Venue -" +
//                                        widget.event_requests[index].spaceName+",  "+
//                                            widget.event_requests[index].buildingName,
//                                    style: TextStyle(
//                                        fontSize: 13, fontWeight: FontWeight.w300)),
//                              ],
//                            ),
//                            Text(
//                                "#hastag",
//                                style: TextStyle(
//                                    fontSize: 16, fontWeight: FontWeight.w600))
//                      ],
//                    ),
//                    ));
//          }),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(children: <Widget>[
//      _showHeading(),
//      Divider(),
//      widget.event_requests.length==0? Center(child: Icon(Icons.event, size: 64.0, color: Colors.teal),):_showEvents(),
//
//
//
//
//    ],);
////      Center(child: Icon(Icons.event, size: 64.0, color: Colors.teal),);
//  }
//}
