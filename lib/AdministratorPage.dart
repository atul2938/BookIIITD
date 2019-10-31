import 'package:flutter/material.dart';

class AdministratorPage extends StatefulWidget {
  @override
  _AdministratorPageState createState() => _AdministratorPageState();
}

class _AdministratorPageState extends State<AdministratorPage> {

  Widget _showHeading(){
    return Card(
      child: Text('Administration'),
    );
  }


  Widget _showOptions()
  {
    return Card(
      child: Row(
        children: <Widget>[
          RaisedButton(
            child: Text('Show Requests'),
            onPressed: null,
          ),
          RaisedButton(
            child: Text('Upload CSV'),
            onPressed: null,
          )
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

  Widget _contentBody()
  {
    return Card(
      child: Text('Content is here'),
    );

  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      _showHeading(),
      _showOptions(),
      _contentBody(),
    ],);
  }
}
