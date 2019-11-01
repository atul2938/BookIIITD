import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

import 'package:project1_app/models/Request.dart';

class AdministratorPage extends StatefulWidget {
  final Dref = FirebaseDatabase.instance.reference();
  List<Request> requests = List<Request>();
  List<String> testList = ["a", "bsjddn", "leys"];

  @override
  _AdministratorPageState createState() => _AdministratorPageState();
}

class _AdministratorPageState extends State<AdministratorPage> {
  @override
  void initState() {
    super.initState();
    getRequests();
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          RaisedButton(
            child: Text('Show Requests'),
            onPressed: () {
              getRequests();
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          RaisedButton(
            child: Text('Upload CSV'),
            onPressed: null,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
        ],
      ),
    );

//    return Card(child: GridView.count(
//      crossAxisCount: 4,
//      scrollDirection: Axis.vertical,
//      controller: new ScrollController(keepScrollOffset: false),
//      shrinkWrap: true,
//      children: widget.currentSpace.timeSlots.map((time) {
//        return Container(
//            padding: EdgeInsets.all(15),
//            child: RaisedButton(
//                child: Text(time.startTime.toString()+" "+time.endTime.toString()),
//                onPressed: () { //here timeslots button is pressed
//                  showModelScreen(ctx);
//                }));
//      }).toList(),
//    ),,);
  }

//  Widget _contentBody() {
//    return Expanded(
////      height: MediaQuery.of(context).size.height*0.60,
//      child: ListView.builder(
//          itemCount: widget.requests.length,
//          itemBuilder: (BuildContext ctxt, int index) {
//            return new Text(widget.requests[index].description);
//          }),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _showHeading(),
        _showOptions(),


        Column(
          //1
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            Center(
              child: Text(
                'List of Requests',
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
        ),

        Expanded(
//      height: MediaQuery.of(context).size.height*0.60,
          child: new ListView.builder(
              itemCount: widget.requests.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Container(
                    height: MediaQuery.of(context).size.height*0.10,
                    child:
                        Card(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(widget.requests[index].spaceName+" in "+widget.requests[index].buildingName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                Text("From "+widget.requests[index].startTime+" till "+widget.requests[index].endTime,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                                Text("Reason -"+widget.requests[index].description.toString(),style:TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
                              ],
                            ),
                            FloatingActionButton(backgroundColor:Colors.lightGreen,child: Icon(Icons.check),onPressed: null,),
                            FloatingActionButton(backgroundColor:Colors.redAccent,child: Icon(Icons.cancel),onPressed: null,)
                          ],
                        )));
              }),
        ),
//      _contentBody(),
      ],
    );
  }
}
