import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project1_app/models/Buildings.dart';
import 'dart:convert';
//import './widgets/RecentRequests.dart';
import 'package:project1_app/models/Request.dart';
import 'package:project1_app/models/TimeSlots.dart';


class PreviousRequests extends StatefulWidget {
  final Dref = FirebaseDatabase.instance.reference();
  List<Request> requests = List<Request>();
  bool gotData =false;
  @override
  _PreviousRequestsState createState() => _PreviousRequestsState();
}

class _PreviousRequestsState extends State<PreviousRequests> {
//  bool gotData = false;

  @override
  void initState() {
    super.initState();
    getRequests();
//    getDatabase();
  }

  void getRequests() async {
    List<Request> reqList = List<Request>();
    DataSnapshot dataSnapshot = await widget.Dref.child('PreviousRequest').once();
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
    widget.gotData=true;
  }

  Widget _nodataDisplay()
  {
    return Column(
      children: <Widget>[
        Center(child: Icon(Icons.history, size: 64.0, color: Colors.teal),),
        Text('No previous Requests'),
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
                  Text(request.isApproved=='true'?'Approved':'Rejected',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
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

  Widget _showemptyText()
  {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(Icons.history, size: 64.0, color: Colors.teal),
          ),),
          SizedBox(height: 3,),
          Text('No Requests to Show', style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    return !gotData?Center(child:CircularProgressIndicator()):;
    return !widget.gotData?Center(child:LinearProgressIndicator()):widget.requests.length==0?_showemptyText():
    Expanded(
//      height: MediaQuery.of(context).size.height*0.60,
      child: new GridView.builder(
          itemCount: widget.requests.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
          itemBuilder: (BuildContext ctxt, int index) {
            double widthlimit =0.40;
            return Container(
                height: MediaQuery.of(context).size.height * 0.13,
                child: Card(
                  elevation: 3.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                    widget.requests[index].isApproved=='true'?'Approved'.toUpperCase():'Not Approved'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * widthlimit,
                              child: Text(
                                'Request by ' +
                                    widget.requests[index].username,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * widthlimit,
                              child: Text(
                                widget.requests[index].spaceName +
                                    " in " +
                                    widget.requests[index].buildingName,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              "From " +
                                  widget.requests[index].startTime +
                                  " till " +
                                  widget.requests[index].endTime,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*widthlimit,
                              child: Text(
                                    "Reason -" +
                                        widget.requests[index].description
                                            .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w300)),
                            ),
                           

                             SizedBox(
                               width: MediaQuery.of(context).size.width * widthlimit,
                               child: Text(
                                    "Remarks -" +
                                        widget.requests[index].remarks
                                            .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w300)),
                             ),
                            FlatButton(
                              child: Text('More Details',style: TextStyle(color: Colors.green),),
                              onPressed: (){
                                showModelScreen(context, widget.requests[index]);
                              },
                            )
                          ],
                        ),
                      ],
                    )));
          }),
    );
//      _contentBody(),


  }
}
