import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project1_app/models/Account.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:flutter/material.dart';
import '../models/Request.dart';
import 'dart:async';
import 'package:async/async.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../models/Spaces.dart';
import '../models/TimeSlots.dart';
import '../models/Buildings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';


class Room extends StatefulWidget {
  Buildings building;
  String buildingName;
  Function callRoomExit;
  List<Spaces> spaces;
  Spaces currentSpace;
  TimeSlots dropDownValueTimeSlot;
  String dropDownValueStart;
  String dropDownValueEnd;
  String description;
  bool underProgress=true;
  List<TimeSlots> validTimeSlots;
  bool isEvent =false;
  bool isSwitched=false;
  List<String> days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
  final Dref = FirebaseDatabase.instance.reference();
  Future<Buildings> fbuilding;
  String eventDescription = 'No details provided';
  Account user ;
  bool submittingRequest = false;
  DateTime choosenDate = DateTime.now();
  String description1 = "No title specified";
  String description2 = "forAll";
//  String startTime;
//  String endTime;

  Room(building, callRoomExit,userdetails) {
    print(building.toString());
    Dref.keepSynced(true);
    user =userdetails;
    print('INSIDE ROOM CONST');
    print(user);
//    this.building = building;
    this.buildingName=building;
    this.callRoomExit = callRoomExit;
//    if (building.spaces != null) {
//      this.spaces = building.spaces;
//      this.currentSpace = this.spaces[0];
//      this.validTimeSlots = List.from(this.currentSpace.timeSlots.where((slot)=>slot.day==days[DateTime.now().weekday-1]));
//      this.dropDownValueTimeSlot = this.validTimeSlots[0];
//      this.dropDownValueStart = this.dropDownValueTimeSlot.startTime.toString();
//      this.dropDownValueEnd = this.dropDownValueTimeSlot.endTime.toString();
//      print(this.dropDownValueStart+" "+this.dropDownValueEnd);
//      print(this.validTimeSlots.runtimeType);
//    }
    underProgress=false;
  }

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
//  final AsyncMemoizer _memoizer = AsyncMemoizer();
//  RangeValues _values = RangeValues(0.3, 0.7);
  StreamSubscription<Event> _buildingAddedSubscription;
  StreamSubscription<Event> _buildingChangedSubscription;
  Query _buildingRequestsQuery;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DateTime _selectedDate = DateTime.now();

//  @override
//  void initState(){
//    super.initState();
////    widget.fbuilding=_getData();
//    _buildingRequestsQuery = _database
//        .reference()
//        .child("Buildings").child(widget.buildingName);
//    _buildingAddedSubscription = _buildingRequestsQuery.onChildAdded.listen(onEntryAdded);
//    _buildingChangedSubscription =_buildingRequestsQuery.onChildChanged.listen(onEntryChanged);
//  }
//
//  @override
//  void dispose() {
//    _buildingAddedSubscription.cancel();
//    _buildingChangedSubscription.cancel();
//    super.dispose();
//  }
//
//  onEntryChanged(Event event) {
////    var oldEntry = widget.event_requests.singleWhere((entry) {
////      return entry.key == event.snapshot.key;
////    });
//
//    setState(() {
//      widget.building = Buildings.fromMappedJson(jsonDecode(event.snapshot.value));
//      print('ONEntryChanged');
//      print(widget.building.name);
//    });
//  }
//
//  onEntryAdded(Event event) {
//    setState(() {
//      print('ADDEDD SNAPSHOT USING QUERY ');
//      print(event.snapshot.value);
////      setState(() {
////      });
//      widget.building =Buildings.fromMappedJson(jsonDecode(event.snapshot.value));
//      print(widget.building.noofspaces);
//    });
//  }

  Future<Buildings> _getData() async {

    DataSnapshot dataSnapshot = await widget.Dref.child('Buildings').child(widget.buildingName).once();
    if (dataSnapshot.value[1] != null) {
      print('Inside room');
      print("dataSnapshot");
      print(dataSnapshot.value);
      print('INside here');
      setState(() {
        widget.building = Buildings.fromMappedJson(json.decode(dataSnapshot.value));
        print(widget.building.name);
        if (widget.building.spaces != null) {
          widget.spaces = widget.building.spaces;
          widget.currentSpace = widget.spaces[0];
//          slot.day==widget.days[DateTime.now().weekday-1]) &&
        widget.validTimeSlots = List.from(widget.currentSpace.timeSlots.where((slot)=> (slot.date.toIso8601String().split("T")[0]==DateTime.now().toString().split(" ")[0])));
        print('Valid TimeSlots');
        print(widget.validTimeSlots);
        print(DateTime.now().toString().split(" ")[0]);
        _selectedDate =  DateTime.now();
        widget.choosenDate = DateTime.now();
        print(widget.currentSpace.timeSlots[0].date.toIso8601String().split("T")[0]);
        widget.dropDownValueTimeSlot = widget.currentSpace.timeSlots[0];
          widget.dropDownValueStart = widget.dropDownValueTimeSlot.startTime.toString();
          widget.dropDownValueEnd = widget.dropDownValueTimeSlot.endTime.toString();
          print('End of get data');
          widget.underProgress=true;
        }
      });
    }
    return widget.building;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.fbuilding=_getData();
  }


  Widget showHeading() {
    return Row(
      //1
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(14),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back,),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
            padding: EdgeInsets.all(14),
            child: RaisedButton(
//                Color.fromRGBO(136, 86, 204, 80)
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                color: space.name==widget.currentSpace.name?Colors.deepPurple:Color.fromRGBO(80, 80, 80, 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(space.name,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                    Text(space.type,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.white),),
                    Text(_findFloor(space.floorNo.toString()),style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,color: Colors.white),)
                  ],
                ),
                onPressed: () {

                  setState(() {

                    widget.currentSpace = space;
                    widget.validTimeSlots = List.from(widget.currentSpace.timeSlots.where((slot)=>(slot.date.toIso8601String().split("T")[0]==DateTime.now().toString().split(" ")[0])));
                    widget.dropDownValueTimeSlot = widget.validTimeSlots[0];
                    _selectedDate = DateTime.now();
                    widget.choosenDate = DateTime.now();
                    widget.dropDownValueStart = widget.dropDownValueTimeSlot.startTime.toString();
                    widget.dropDownValueEnd = widget.dropDownValueTimeSlot.endTime.toString();
//                    print(this.dropDownValueStart+" "+this.dropDownValueEnd);
                  });
                  showAlertBox("Information about "+widget.currentSpace.name, widget.currentSpace.name.toString() +
                      " is a "+widget.currentSpace.type.toString()+" at "+_findFloor(widget.currentSpace.floorNo.toString())+ ' of ' +
                      widget.buildingName+
                      " with capacity "+ widget.currentSpace.capacity.toString());
                }));
      }).toList(),
    );
  }

  void showAlertBox(title,content)
  {

//    showDialog(
//        context: context,
//        builder: (BuildContext context){
//          return AlertDialog(
//            title: Text(title),
//            content: Text(content),
//          );
//        }
//    );
//    return;
    String path = 'assets/images/';
    if(title == 'Error')
      {
        path = path+'error1.gif';
      }
    else if(title == 'Successful Booking')
      {
        path = path+'confirm.gif';
      }
    else if (title == "Successful Submission")
      {
        path = path+'message_sent1.jpg';
      }
    else
      {
        path = path+'info.jpg';
      }
    Alert(
    context:context,
    title: title,
    desc: content,
    image: Image.asset(path,),
  ).show();
    setState(() {
      widget.submittingRequest=false;
    });
  }

  Future<dynamic> showEventAlertBox(title,content)
  {
    String description = 'Event Title not present' ;
    String description2 = '#forAll' ;
    var textCompleter = Completer();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: Container(
              height: MediaQuery.of(context).size.height*0.50,
              width:  MediaQuery.of(context).size.width*0.80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(content),
                  TextField(
                    autocorrect: false,
//                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
//            border: InputBorder.none,
//                        border: OutlineInputBorder(),
                        hintText: 'Enter the title of the Event'),
                    onChanged: (value){
                      description=value;
                    },
                    onSubmitted: (value) {

                      description = value;
//                    textCompleter.complete(description);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.005,
                  ),
//                  MultiSelect(
//                      autovalidate: false,
//                      titleText: 'Choose Hastags',
//                      validator: (value) {
//                        if (value == null) {
//                          return 'Please select one or more option(s)';
//                        }
//                      },
//                      errorText: 'Please select one or more option(s)',
//                      dataSource: [
//                        {
//                          "display": "#forAll",
//                          "value": 1,
//                        },
//                        {
//                          "display": "#CSE",
//                          "value": 2,
//                        },
//                        {
//                          "display": "#CSAM",
//                          "value": 3,
//                        },
//                        {
//                          "display": "#CSD",
//                          "value": 4,
//                        },
//                        {
//                          "display": "#CSSS",
//                          "value": 5,
//                        },
//                        {
//                          "display": "#CSAI",
//                          "value": 6,
//                        },
//                        {
//                          "display": "#CSB",
//                          "value": 7,
//                        },
//                        {
//                          "display": "#Meeting",
//                          "value": 8,
//                        },
//                      ],
//                      textField: 'display',
//                      valueField: 'value',
//                      filterable: true,
//                      required: true,
//                      value: null,
//                      onSaved: (value) {
//                        print('The value is $value');
//                      }
//                  ),
                  TextField(
                    autocorrect: false,
//                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
//            border: InputBorder.none,
//                        border: OutlineInputBorder(),
                        hintText: 'Enter hastags. eg #forAll, #CSE, etc'),
                    onChanged: (value){
                      description2=value;
                    },
                    onSubmitted: (value) {

                      description2 = value;
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
//                    textCompleter.complete(description+' &events& '+description2);
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('DONE'),
                  onPressed: () {
                    textCompleter.complete(description+' &events& '+description2);
                    Navigator.pop(context);
                  })
            ],
          );
        }
    );
    return textCompleter.future;
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
    widget.eventDescription = widget.description1+'&events&'+widget.description2;
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
    if(widget.description==null)
      {
        showAlertBox("Error","Kindly enter the description" );
        return;
      }
    Request r = Request(widget.building.name, widget.currentSpace.name,widget.days[DateTime.now().weekday-1],
        widget.dropDownValueStart,widget.dropDownValueEnd, widget.description,'false',widget.isEvent.toString(),
        widget.eventDescription,'no remarks',widget.user.name,widget.user.id,'false','false');

    if(widget.buildingName=='Library Building' || widget.buildingName=='Sports Block')
      {
        _bookLibAndSports(r);
      }
    else
      {
        _uploadRequest(r);

      }
  }

  _uploadRequest(Request request) async
  {
    String start=widget.dropDownValueStart;
    String end = widget.dropDownValueEnd;

    bool startFound=false;
    // checking for validity
    for(int i=0;i<widget.validTimeSlots.length;i++)
    {
      if(widget.validTimeSlots[i].startTime==start || startFound)
      {
        startFound=true;
        if(widget.validTimeSlots[i].isVacant==false)
        {
          showAlertBox("Error","cannot book an already booked space for "+
              widget.validTimeSlots[i].startTime+" to "+widget.validTimeSlots[i].endTime);
          return;
        }
        if(widget.validTimeSlots[i].endTime==end) {
          break;
        }
      }

    }
    print('uploading requests till here');
    print('EVENT STATUS');
    print(request.makeItEvent.toString());
    print(request.eventDetails);
    String key = request.key;
     widget.Dref.child('Requests').child(key).set(json.encode(request.toJson())).then((value){
        print('SENDING REQUESTS AND SEEING THE RETURED VALUE');
//        print(value);
        // how to store this in user record
       widget.Dref.child('UserRequestRecord').child(request.username+request.userId).child(key).set(json.encode(request.toJson()));
    });
//    await widget.Dref.child('UserRequestRecord').child(request.username+request.userId).child(key).set(json.encode(request.toJson()));
    showAlertBox("Successful Submission", "Your request has been recorded and will be processed soon");
  }

  _bookLibAndSports(Request request) async
  {
    String start=widget.dropDownValueStart;
    String end = widget.dropDownValueEnd;

    bool startFound=false;
    // checking for validity
    for(int i=0;i<widget.validTimeSlots.length;i++)
      {
        if(widget.validTimeSlots[i].startTime==start || startFound)
          {
            startFound=true;
            if(widget.validTimeSlots[i].isVacant==false)
              {
                showAlertBox("Error","cannot book an already booked space for "+
                widget.validTimeSlots[i].startTime+" to "+widget.validTimeSlots[i].endTime);
                return;
              }
            if(widget.validTimeSlots[i].endTime==end) {
              break;
            }
          }

      }
    // book rooms now
    startFound=false;

    for(int i=0;i<widget.validTimeSlots.length;i++)
    {
      if(widget.validTimeSlots[i].startTime==start || startFound)
      {
        startFound=true;
        widget.validTimeSlots[i].isVacant=false;
        widget.validTimeSlots[i].purpose= widget.description;
        if(widget.validTimeSlots[i].endTime==end) {
          break;
        }
      }
    }

    int spaceIndex = widget.building.spaces.indexWhere((space) => space.name==widget.currentSpace.name);
    int timeslotIndex1 = widget.building.spaces[spaceIndex].timeSlots.indexWhere((timeslot) => timeslot.day==widget.days[DateTime.now().weekday-1]);
    int timeslotIndex2 =widget.building.spaces[spaceIndex].timeSlots.lastIndexWhere((timeslot) => timeslot.day==widget.days[DateTime.now().weekday-1]);
    widget.building.spaces[spaceIndex].timeSlots.replaceRange(timeslotIndex1, timeslotIndex2, widget.validTimeSlots);

    _postChanges();
    String key = request.key;
    await widget.Dref.child('UserRequestRecord').child(request.username+request.userId).child(key).set(json.encode(request.toJson()));
    showAlertBox("Successful Booking", "Your requested space has been booked for you");

  }

  _postChanges() async{
    await widget.Dref.child('Buildings').child(widget.buildingName).set(
        json.encode(widget.building.toJson()));
  }

  void _presentDatePicker()
  {
    var firstDateValue = DateTime.now();
    var initialdDateValue = _selectedDate;
    if (firstDateValue.isAfter(initialdDateValue))
      {
        firstDateValue= initialdDateValue;
      }
    showDatePicker(context: context,
        firstDate: firstDateValue,
        initialDate: initialdDateValue,
//        lastDate: DateTime(2020)
        lastDate: widget.currentSpace.timeSlots[widget.currentSpace.timeSlots.length-1].date
    ).then((date){
      print(date);
      if(date==null)
      {
        print('NO choice made');
        return;
      }
      setState(() {
        _selectedDate=date;
        widget.choosenDate = date;
        print('ChoosenDate by DAtePicker');
        print(date);
        widget.validTimeSlots = List.from(widget.currentSpace.timeSlots.where((slot)=> (slot.date.toString().split(" ")[0].trim() == _selectedDate.toString().split(" ")[0].trim())));
        print('Final Date Choice in DAtepIcker');
        print(_selectedDate.toString().split(" ")[0]);
        print(widget.currentSpace.timeSlots[0].date);
        print(widget.currentSpace.timeSlots);
        print(widget.validTimeSlots);
        widget.dropDownValueTimeSlot = widget.validTimeSlots[0];
        widget.dropDownValueStart = widget.dropDownValueTimeSlot.startTime.toString();
        widget.dropDownValueEnd = widget.dropDownValueTimeSlot.endTime.toString();
      });

    });
  }

//  void showAnimatedAlertBox(title,content)
//  {
//    showDialog(
//        context: context,
//        builder: (_) => NetworkGiffyDialog(
//          image :Image.network("https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif"),
//          title: Text('Granny Eating Chocolate',
//              textAlign: TextAlign.center,
//              style: TextStyle(
//                  fontSize: 22.0,
//                  fontWeight: FontWeight.w600)),
//          description:Text('This is a granny eating chocolate dialog box. This library helps you easily create fancy giffy dialog',
//            textAlign: TextAlign.center,
//          ),
//          entryAnimation: EntryAnimation.DEFAULT,
//          onOkButtonPressed: () {},
//        ) );
//  }

  Widget _showEventFields()
  {
    widget.description1 = 'No title Specified';
    widget.description2 = '#forAll';
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.multiline,
//            maxLines: 2,
            validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
            decoration: InputDecoration(
//            border: InputBorder.none,
                border: OutlineInputBorder(),
                hintText: 'Enter title of the event..'),
            onChanged: (value){
//              widget.description=value;
              widget.description1=value;
            },
            onSaved: (value) {
//              widget.description = value;
              widget.description1 =value;
            },
          ),
        ),
        SizedBox(height: 4,),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.multiline,
//            maxLines: 2,
            validator: (value) => value.isEmpty ? 'Description can\'t be empty' : null,
            decoration: InputDecoration(
//            border: InputBorder.none,
                border: OutlineInputBorder(),
                hintText: 'Give some hastags...eg #forAll #CSAM etc '),
            onChanged: (value){
//              widget.description=value;
              widget.description2=value;
            },
            onSaved: (value) {
//              widget.description = value;
              widget.description2=value;
            },
          ),
        )
      ],
    );

  }

  Widget showBookSection() {
    print("its here");
    bool showEventOption = true;
    if(widget.buildingName=='Library Building' || widget.buildingName=='Sports Block')
      {
        showEventOption = false;
      }
//    widget.isEvent=false;
    var stime = widget.dropDownValueStart;
    var etime = widget.dropDownValueEnd;
    print(widget.dropDownValueEnd+ "  in showbook "+widget.dropDownValueStart);
    String description = 'Event Title not present' ;
    String description2 = '#forAll' ;

    return Card(
      color: Color.fromRGBO(211, 211, 211, 100),
      elevation: 2,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: Text(
              'Book Your Space',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Date picker
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_selectedDate==null?'No Date Chosen':'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
              FlatButton(
                child: Text('Choose Date'),
                onPressed: (){
                  _presentDatePicker();

                },
              )
            ],
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.multiline,
//            maxLines: 2,
              validator: (value) => value.isEmpty ? 'Description can\'t be empty' : null,
              decoration: InputDecoration(
//            border: InputBorder.none,
                  border: OutlineInputBorder(),
                  hintText: 'Enter the description...eg - Project Discussion etc '),
              onChanged: (value){
                widget.description=value;
              },
              onSaved: (value) {
                widget.description = value;
              },
            ),
          ),
          showEventOption?Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Want to make it a event ?'),
//              Switch(
//                value: isSwitched,
//                onChanged: (value) {
//
//                  showEventAlertBox('Event Details','Please provide few additional details.').then((detail){
//                    widget.eventDescription =detail;
//                  });
//                  setState(() {
//                    isSwitched = value;
//                    widget.isEvent =value;
//
//
//                  });
//                },
//                activeTrackColor: Colors.purpleAccent,
//                activeColor: Colors.purple,
//              ),
                Checkbox(
                value: widget.isEvent,
                onChanged: (bool value) {
                  setState(() {
//                    widget.isSwitched = value;
                    widget.isEvent =value;
//                    if(widget.isEvent)
//                    {
//                      showEventAlertBox('Event Details','Please provide few additional details.').then((detail){
//                        widget.eventDescription =detail;
//                      });
//                    }
                  });
                },
              ),



            ],
          ):SizedBox(),
          widget.isEvent?_showEventFields():SizedBox(),
//          widget.isEvent?TextFormField(
//            autocorrect: false,
//            keyboardType: TextInputType.multiline,
////            maxLines: 2,
//            validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
//            decoration: InputDecoration(
////            border: InputBorder.none,
//                border: OutlineInputBorder(),
//                hintText: 'Enter title of the event..'),
//            onChanged: (value){
//              widget.description=value;
//            },
//            onSaved: (value) {
//              widget.description = value;
//            },
//          ):SizedBox(),
//          widget.isEvent?TextFormField(
//            autocorrect: false,
//            keyboardType: TextInputType.multiline,
////            maxLines: 2,
//            validator: (value) => value.isEmpty ? 'Description can\'t be empty' : null,
//            decoration: InputDecoration(
////            border: InputBorder.none,
//                border: OutlineInputBorder(),
//                hintText: 'Enter the description...eg - Project Discussion etc '),
//            onChanged: (value){
//              widget.description=value;
//            },
//            onSaved: (value) {
//              widget.description = value;
//            },
//          ):SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                child: RaisedButton(
                  child: Text('BookIt'),
                  onPressed: () {
//                  widget.Dref.keepSynced(true);
                  setState(() {
                    widget.submittingRequest = true;
                  });
                    submitRequest();
                  },
                ),
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
            color: Colors.tealAccent,
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


    return widget.submittingRequest?Center(child: CircularProgressIndicator()):FutureBuilder<Buildings>(
      future: widget.underProgress? widget.fbuilding:_getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          print('done as by cinnection state');
          print(snapshot.hasData);
        }

        if (snapshot.hasError) {
          print('error is');
          print(snapshot.error);
          return Text("Error!");
        }
        if (snapshot.data == null) {
          print("In progreess");
          return Center(child: CircularProgressIndicator(),);
        }
        print("Lets go");
        print(snapshot.data);

        return ListView(
          children: <Widget>[

            Container(
                color: Colors.grey,
                height: MediaQuery.of(context).size.height*0.08,
                child: showHeading()),
            Divider(), // Now Displaying Space Options
            Container(
                height:MediaQuery.of(context).size.height*0.22,
                child: showSpacesButtons()),
            Divider(), //Selecting Time

            Container(
                height:(widget.buildingName=='Library Building' || widget.buildingName=='Sports Block')?
              MediaQuery.of(context).size.height*0.42:
                (widget.isEvent?MediaQuery.of(context).size.height*0.69:MediaQuery.of(context).size.height*0.47),
                width: MediaQuery.of(context).size.width*0.94,
                child: Card(
                    elevation: 5,
                    child: showBookSection())),
            Divider(),
            Container(child: showTimeSlots(context)),
            Divider(),
          ],
        );
      },
    );
  }
}










































































































//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
////import 'package:flutter/material.dart';
//import '../models/Request.dart';
//
//
////import 'package:intl/intl.dart';
////import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import '../models/Spaces.dart';
//import '../models/TimeSlots.dart';
//import '../models/Buildings.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'dart:convert';
//
//
//class Room extends StatefulWidget {
//  Buildings building;
//  Function callRoomExit;
//  List<Spaces> spaces;
//  Spaces currentSpace;
//  TimeSlots dropDownValueTimeSlot;
//  String dropDownValueStart;
//  String dropDownValueEnd;
//  String description;
//  bool underProgress=true;
//  List<TimeSlots> validTimeSlots;
//  List<String> days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
//  final Dref = FirebaseDatabase.instance.reference();
////  String startTime;
////  String endTime;
//
//  Room(building, callRoomExit) {
//    print(building.toString());
//    this.building = building;
//    this.callRoomExit = callRoomExit;
//    if (building.spaces != null) {
//      this.spaces = building.spaces;
//      this.currentSpace = this.spaces[0];
//      this.validTimeSlots = List.from(this.currentSpace.timeSlots.where((slot)=>slot.day==days[DateTime.now().weekday-1]));
//      this.dropDownValueTimeSlot = this.validTimeSlots[0];
//      this.dropDownValueStart = this.dropDownValueTimeSlot.startTime.toString();
//      this.dropDownValueEnd = this.dropDownValueTimeSlot.endTime.toString();
//      print(this.dropDownValueStart+" "+this.dropDownValueEnd);
//      print(this.validTimeSlots.runtimeType);
//    }
//    underProgress=false;
//  }
//
//  @override
//  _RoomState createState() => _RoomState();
//}
//
//class _RoomState extends State<Room> {
////  RangeValues _values = RangeValues(0.3, 0.7);
//
//
////  Widget showSpaceOptions() {
////    if (widget.spaces == null) {
////      return Text('NO Space options ');
////    }
////    return Column(
////        children: widget.spaces.map((building) {
////      return Container(
////        margin: EdgeInsets.all(10),
////        height: 70,
////        width: double.infinity,
////        child: RaisedButton(child: Text(building.type), onPressed: () {}),
////      );
////    }).toList());
////  }
//
//  Widget showHeading() {
//    return Row(
//      //1
//      children: <Widget>[
//        Container(
//          margin: EdgeInsets.all(20),
//          child: FloatingActionButton(
//            child: Icon(Icons.arrow_back),
//            onPressed: () {
//              widget.callRoomExit();
//            },
//          ),
//        ),
//        SizedBox(
//          width: MediaQuery.of(context).size.width*0.12,
//        ),
//        Center(
//          child: Text(
//            widget.building.name,
//            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//          ),
//        ),
//      ],
//    );
//  }
//
//
//  String _findFloor(floorno)
//  {
//    var fno = int.parse(floorno);
//    List<String> temp = ['Ground','First','Second','Third','Fourth','Fifth','Sixth''Seventh'];
//    if(fno>=temp.length){
//      return floorno+ "  Floor";
//    }
//    return temp[fno]+" Floor";
//  }
//
//  Widget showSpacesButtons() {
//    return GridView.count(
//      crossAxisCount: 3,
//      scrollDirection: Axis.vertical,
//      controller: new ScrollController(keepScrollOffset: false),
//      shrinkWrap: true,
//      children: widget.spaces.map((space) {
//        return Container(
//            padding: EdgeInsets.all(10),
//            child: RaisedButton(
//                color: Color.fromRGBO(136, 86, 204, 80),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Text(space.name,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
//                    Text(space.type,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),),
//                    Text(_findFloor(space.floorNo.toString()),style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),)
//                  ],
//                ),
//                onPressed: () {
//                  setState(() {
//
//                    widget.currentSpace = space;
//                    widget.validTimeSlots = List.from(widget.currentSpace.timeSlots.where((slot)=>slot.day==widget.days[DateTime.now().weekday-1]));
//                    widget.dropDownValueTimeSlot = widget.validTimeSlots[0];
//                    widget.dropDownValueStart = widget.dropDownValueTimeSlot.startTime.toString();
//                    widget.dropDownValueEnd = widget.dropDownValueTimeSlot.endTime.toString();
////                    print(this.dropDownValueStart+" "+this.dropDownValueEnd);
//                  });
//                  showAlertBox("Information about the Choosen Space", widget.currentSpace.name.toString() +
//                      " is a "+widget.currentSpace.type.toString()+" at "+_findFloor(widget.currentSpace.floorNo.toString())+
//                      " with capacity "+ widget.currentSpace.capacity.toString());
//                }));
//      }).toList(),
//    );
//  }
//
//  void showAlertBox(title,content)
//  {
//    showDialog(
//        context: context,
//        builder: (BuildContext context){
//          return AlertDialog(
//            title: Text(title),
//            content: Text(content),
//          );
//        }
//    );
//    return;
//  }
//
//  int _getIntTime(timeString)
//  {
//    var s =timeString;
//    var hmlist=s.split(":");
//    var h = int.parse(hmlist[0]);
//    var min = int.parse(hmlist[1]);
//    return (h*60+min);
//
//  }
//
//  void submitRequest() {
//    print("INside ReQUESTS");
//    var stime = _getIntTime(widget.dropDownValueStart);
//    var etime = _getIntTime(widget.dropDownValueEnd);
//    var duration = etime-stime;
//    print(stime.toString()+" "+etime.toString());
//    if(stime>=etime)
//      {
//        showAlertBox("Error", "Incorrect range of timings entered");
//        return;
//      }
//    if((widget.building.name=='Library Building' || widget.building.name=='Sports Block') && duration>60)
//      {
//        showAlertBox("Error","Cannot Book for more than 1 hour" );
//        return;
//      }
//    showAlertBox("Successful Submission", "Your request has been recorded and will be processed soon");
//    _uploadRequest(Request(widget.building.name, widget.currentSpace.name,widget.dropDownValueStart,
//        widget.dropDownValueEnd, widget.description,'false'));
//
//  }
//  _uploadRequest(Request request) async
//  {
//    await widget.Dref.child('Requests').child(request.startTime+request.endTime).set(json.encode(request.toJson()));
//  }
//
//  Widget showBookSection() {
//    print("its here");
//    var stime = widget.dropDownValueStart;
//    var etime = widget.dropDownValueEnd;
//    print(widget.dropDownValueEnd+ "  in showbook "+widget.dropDownValueStart);
//    return Card(
//      color: Color.fromRGBO(211, 211, 211, 100),
//      elevation: 2,
//      child: Column(
//        children: <Widget>[
//          SizedBox(
//            height: 10,
//          ),
//          Text(
//            'Book Your Space',
//            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//          ),
//          SizedBox(
//            height: 20,
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              Text('From..'),
//              DropdownButton<String>(
//                value:widget.dropDownValueStart,
//                icon: Icon(Icons.arrow_drop_down_circle),
//                iconSize: 24,
//                elevation: 16,
//                style: TextStyle(color: Colors.deepPurple),
//                underline: Container(
//                  height: 2,
//                  color: Colors.deepPurpleAccent,
//                ),
//                onChanged: (newValue) {
////                  stime = newValue;
//                  setState(() {
//                    widget.dropDownValueStart = newValue;
////                    widget.startTime=newValue;
//                  });
//                  print(widget.dropDownValueStart);
//                },
//                items: widget.validTimeSlots
//                    .map<DropdownMenuItem<String>>((value) {
////                  widget.startTime = value.startTime.toString();
////                  print("Coming inide map+ "+widget.currentSpace.timeSlots.length.toString());
//                  return DropdownMenuItem<String>(
//                    value: value.startTime.toString(),
//                    child: Text(value.startTime.toString()),
//                  );
//                  }).toList(),
//
//              ),
////              SizedBox(width: MediaQuery.of(context).size.width*03,),
//
//              Text('Till..'),
//              DropdownButton<String>(
//                value:widget.dropDownValueEnd,
//                icon: Icon(Icons.arrow_drop_down_circle),
//                iconSize: 24,
//                elevation: 16,
//                style: TextStyle(color: Colors.deepPurple),
//                underline: Container(
//                  height: 2,
//                  color: Colors.deepPurpleAccent,
//                ),
//                onChanged: (newValue) {
//                  setState(() {
//                    widget.dropDownValueEnd = newValue;
//
////                    widget.endTime = newValue;
//                    print('endtime' + widget.dropDownValueEnd);
//                  });
//                },
//                items: widget.validTimeSlots
//                    .map<DropdownMenuItem<String>>((value) {
////                  widget.endTime = value.endTime.toString();
//                  return DropdownMenuItem<String>(
//                    value: value.endTime.toString(),
//                    child: Text(value.endTime.toString()),
//                  );
//                }).toList(),
//              ),
//            ],
//          ),
//          SizedBox(
//            height: 10,
//          ),
//          TextField(
//            autocorrect: false,
//            decoration: InputDecoration(
////            border: InputBorder.none,
//                border: OutlineInputBorder(),
//                hintText: 'Enter the description...eg - Project Discussion etc '),
//            onChanged: (value){
//              widget.description=value;
//            },
//            onSubmitted: (value) {
//              widget.description = value;
//            },
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              RaisedButton(
//                child: Text('BookIt'),
//                onPressed: () {
//                  submitRequest();
//                },
//              ),
//            ],
//          )
//        ],
//      ),
//    );
//  }
//
//  void showModelScreen(ctx,TimeSlots time) {
//    showModalBottomSheet(
//        context: ctx,
//        builder: (_) {
//          return Container(
//            height: MediaQuery.of(context).size.height*0.40,
//            color: Color.fromRGBO(0, 160, 165, 70),
//            child: GestureDetector(
//              onTap: () {},
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Text('Time slot ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
//                  Text(time.startTime+"-"+time.endTime,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
//                  Text('Status- '+(time.isVacant?'Vacant':'Occupied'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
//                  Text("Reason- "+time.purpose,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
//                ],
//              ),
//            ),
//          );
//        });
//  }
//
//  Widget showTimeSlots(ctx) {
//    return Column(
//      children: <Widget>[
//        Text(
//          'Time Slots',
//          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//        ),
//        SizedBox(
//          height: 10,
//        ),
//        GridView.count(
//          crossAxisCount: 4,
//          scrollDirection: Axis.vertical,
//          controller: new ScrollController(keepScrollOffset: false),
//          shrinkWrap: true,
//          children: widget.validTimeSlots.map((time) {
//            return Container(
//                padding: EdgeInsets.all(15),
//                child: RaisedButton(
//                  color: time.isVacant?Colors.lightGreen:Colors.redAccent,
//                    child: Text(time.startTime.toString() +"-\n" +time.endTime.toString()+"\n"+time.day,
//                      style:TextStyle(fontSize:10,fontWeight:FontWeight.w500) ,),
//                    onPressed: () {
//                      //here timeslots button is pressed
//                      showModelScreen(ctx,time);
//                    }));
//          }).toList(),
//        ),
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return widget.underProgress?Container(child: Center(child: CircularProgressIndicator(),),):
//    ListView(
//      children: <Widget>[
//        Container(height: MediaQuery.of(context).size.height*0.08, child: showHeading()),
////        showSpaceOptions(),
//        Divider(), // Now Displaying Space Options
//        Container(height: MediaQuery.of(context).size.height*0.25, child: showSpacesButtons()),
//        Divider(), //Selecting Time
//
//        showBookSection(),
//        Divider(),
//        showTimeSlots(context),
//        Divider(),
//      ],
//    );
//  }
//}
