import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project1_app/models/TimeSlots.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/Buildings.dart';
import '../models/Request.dart';
import '../models/Account.dart';

class AccountScreen extends StatefulWidget {
  final Account myAccount;
  List<Request> previousRequests=List();
  List<Buildings> allBuilding=List();
  final Dref = FirebaseDatabase.instance.reference();
  bool gotData = false;
  AccountScreen(this.myAccount);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _previousRequestsAddedSubscription;
  StreamSubscription<Event> _previousRequestsChangedSubscription;

  StreamSubscription<Event> _buildingsAddedSubscription;
  StreamSubscription<Event> _buildingsChangedSubscription;

  Query _previousRequestsQuery;
  Query _allBuildingsQuery;

  //bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();


//    _todoList = new List();
    _allBuildingsQuery = _database.reference().child('Buildings');
    _buildingsAddedSubscription = _allBuildingsQuery.onChildAdded.listen(onEntryAdded1);
    _buildingsChangedSubscription = _allBuildingsQuery.onChildChanged.listen(onEntryChanged1);

    widget.previousRequests= List();
    print('ACCOUNT screen');
    print(widget.myAccount);
    print(widget.myAccount.name);
    _previousRequestsQuery = _database.reference().child("UserRequestRecord").child(widget.myAccount.name+widget.myAccount.id);
    _previousRequestsAddedSubscription = _previousRequestsQuery.onChildAdded.listen(onEntryAdded);
    _previousRequestsChangedSubscription = _previousRequestsQuery.onChildChanged.listen(onEntryChanged);

    //    getEventRequests();
  }

  @override
  void dispose() {
    _previousRequestsAddedSubscription.cancel();
    _previousRequestsChangedSubscription.cancel();

    _buildingsAddedSubscription.cancel();
    _buildingsChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = widget.previousRequests.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      widget.previousRequests[widget.previousRequests.indexOf(oldEntry)] =
          Request.fromMappedJson(jsonDecode(event.snapshot.value));
      print('INSIDE CHANGED FUNC - ONEntryChanged');
      print(widget.previousRequests[widget.previousRequests.indexOf(oldEntry)]);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      print('INSIDE ADDED FUNC - Added snapshot ');
      print(event.snapshot.value);
      widget.previousRequests.add(Request.fromMappedJson(jsonDecode(event.snapshot.value)));
      print(widget.previousRequests.length);
    });
  }

  onEntryChanged1(Event event) {
    var oldEntry = widget.allBuilding.singleWhere((entry) {
      return entry.name == event.snapshot.key;
    });

    setState(() {
      widget.allBuilding[widget.allBuilding.indexOf(oldEntry)] =
          Buildings.fromMappedJson(jsonDecode(event.snapshot.value));
      print('BUILDINGS ...INSIDE CHANGED FUNC - ONEntryChanged');
      print(widget.allBuilding[widget.allBuilding.indexOf(oldEntry)]);
    });
  }

  onEntryAdded1(Event event) {
    setState(() {
      print('BUILDINGS , INSIDE ADDED FUNC - Added snapshot ');
      print(event.snapshot.value);
      widget.allBuilding.add(Buildings.fromMappedJson(jsonDecode(event.snapshot.value)));
      print(widget.allBuilding.length);
      if(widget.allBuilding.length>4) {
        setState(() {
          widget.gotData=true;
        });
      }
    });
  }


  _cancelRequest(Request request,int index)
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
//    for(int i=0;i<validTimeSlots.length;i++)
//    {
//      if(validTimeSlots[i].startTime==start || startFound)
//      {
//        startFound=true;
//        if(validTimeSlots[i].isVacant==false)
//        {
//          print("Error "+"cannot book an already booked space for "+
//              validTimeSlots[i].startTime+" to "+validTimeSlots[i].endTime);
//          return;
//        }
//        if(validTimeSlots[i].endTime==end) {
//          break;
//        }
//      }
//
//    }
    // book rooms now
    startFound=false;

    for(int i=0;i<validTimeSlots.length;i++)
    {
      if(validTimeSlots[i].startTime==start || startFound)
      {
        startFound=true;
        validTimeSlots[i].isVacant=true;
        validTimeSlots[i].purpose= 'Not Specified';
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
    request.isCanceled = 'true';
    widget.previousRequests[reqindex].isCanceled='true';
//    request.isApproved ='true';
    widget.previousRequests[reqindex].remarks+= ' and then Canceled by the user';
    request.remarks += ' and then Canceled by the user';

    if(request.buildingName=='Library Building' || request.buildingName =='Sports Block')
      {
        await widget.Dref.child('UserRequestRecord').child(widget.myAccount.name+widget.myAccount.id).child(key).set(json.encode(request.toJson()));
        print("CANCELATION -   for ${request.spaceName} by ${request.username}successful (1 Lib/ Sports block)");
      }
    else if(request.isApproved=='false')
      {
        // no need to save the request
        await widget.Dref.child('Requests').child(key).remove();
        print("CANCELATION -   for ${request.spaceName} by ${request.username}successful (2 Not approved)");
        setState(() {
          widget.previousRequests.removeAt(reqindex);
        });

      }
      
    else if(request.isApproved=='true' && request.makeItEvent=='true')
      {
        await widget.Dref.child('PreviousRequest').child(key).set(json.encode(request.toJson()));
        await widget.Dref.child('Events').child(key).remove();
        await widget.Dref.child('UserRequestRecord').child(widget.myAccount.name+widget.myAccount.id).child(key).set(json.encode(request.toJson()));
        print("CANCELATION -   for ${request.spaceName} by ${request.username}successful (3 approved and event)");
      }
    else if(request.isApproved=='true'  && request.makeItEvent!='true')
      {
        await widget.Dref.child('PreviousRequest').child(key).set(json.encode(request.toJson()));
        await widget.Dref.child('UserRequestRecord').child(widget.myAccount.name+widget.myAccount.id).child(key).set(json.encode(request.toJson()));
        print("CANCELATION -   for ${request.spaceName} by ${request.username}successful (4 approved and not an event)");
      }
    showAlertBox("Cancellation Done", "Your Request has been canceled");
    setState(() {
      null;
    });
  }

  void showAlertBox(title,content)
  {

    Alert(
      context:context,
      title: title,
      desc: content,
      image: Image.asset('assets/images/confirm.gif',),
    ).show();
//    setState(() {
//      widget.submittingRequest=false;
//    });
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
  }


  Widget _showRequests()
  {
    return Expanded(
//      height: MediaQuery.of(context).size.height*0.60,
      child: new ListView.builder(
          itemCount: widget.previousRequests.length,
          itemBuilder: (BuildContext ctxt, int index) {
            String statusText="";
            if(widget.previousRequests[index].isCanceled=='true')
              {
                statusText='Canceled';
              }
            else if(widget.previousRequests[index].isRejected=='true')
              {
                statusText='Rejected';
              }
            else if(widget.previousRequests[index].isApproved=='true')
              {
                statusText='Approved';
              }
            else
              {
              statusText = 'Pending';
            }
            bool dontShowCancelButton =(widget.previousRequests[index].isRejected=='true' ||widget.previousRequests[index].isCanceled=='true');

            return Container(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: dontShowCancelButton?Color.fromRGBO(9, 102, 164, 100):Color.fromRGBO(0, 204, 102, 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.007,
                              ),
                              Text(
                                'Status : '+statusText,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                widget.previousRequests[index].spaceName +
                                    " in " +
                                    widget.previousRequests[index].buildingName,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "From " +
                                    widget.previousRequests[index].startTime +
                                    " till " +
                                    widget.previousRequests[index].endTime+" on "+widget.previousRequests[index].day,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.50,
                                child: Text(
                                    "Reason -" +
                                        widget.previousRequests[index].description
                                            .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w300)),
                              ),
                              Text(
                                widget.previousRequests[index].makeItEvent=='true'?"Make it an event - " +'Yes':"Make it an event - " +'No'
                                ,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              OutlineButton(
                                child: Text('More Details'),
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                onPressed: (){
                                  showModelScreen(context, widget.previousRequests[index]);
                                },
                              )
                            ],
                          ),
//                        FloatingActionButton(
//                          backgroundColor: Colors.redAccent,
//                          child: Icon(Icons.cancel),
//                          onPressed: (){
//                            _rejectIt(widget.requests[index],index);
//                          },
//                        )
                          dontShowCancelButton?
                          SizedBox():OutlineButton(
                            child: Text('Cancel'),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: (){
                              _cancelRequest(widget.previousRequests[index], index);
                            },
                          ),
            ],
                      )),
                ));
          }),
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
          String statusText="";
          if(request.isCanceled=='true')
          {
            statusText='Canceled';
          }
          else if(request.isRejected=='true')
          {
            statusText='Rejected';
          }
          else if(request.isApproved=='true')
          {
            statusText='Approved';
          }
          else
          {
            statusText = 'Pending';
          }
          return Container(
            height: MediaQuery.of(context).size.height*0.40,
            color: Color.fromRGBO(0, 160, 165, 70),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
//                  Text('Request made by '+ request.username,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                  Text('Status: '+statusText,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
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

  Widget _showemptyText()
  {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(Icons.notifications_none, size: 64.0, color: Colors.teal),
          ),),
          SizedBox(height: 3,),
          Text('No Requests to Show', style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
//    return Container(child:Text(myAccount.name));
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.20,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                  colors: [Colors.blue, Colors.teal])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child:
                    Icon(Icons.account_circle, size: 64.0, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                widget.myAccount.name.toUpperCase(),
                style: TextStyle(fontSize: 34),
              ),
            ],
          ),
        ),
        ListTile(
          title: Text(
            'Email',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          subtitle: Text(widget.myAccount.emailId, style: TextStyle(fontSize: 18)),
        ),
        Divider(),
        ListTile(
          title: Text(
            'Role',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          subtitle: Text(widget.myAccount.role, style: TextStyle(fontSize: 18)),
        ),
        Divider(),
        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(' Your Previous Requests ',style: TextStyle(fontSize: 20),),
        ),
        Divider(),
        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
//        widget.previousRequests.length!=0?Text(' Will show soon ... working on it!1 '):SizedBox(),
        !widget.gotData?LinearProgressIndicator():widget.previousRequests.length!=0?_showRequests():_showemptyText(),
      ],
    );
  }
}
