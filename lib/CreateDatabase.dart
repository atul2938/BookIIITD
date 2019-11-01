//import 'dart:io';
import 'dart:async';
//import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:project1_app/models/Buildings.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:project1_app/models/TimeSlots.dart';
import 'models/Spaces.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class CreateDatabse  {

  static List<List<dynamic>> venueDB;
  static List<List<dynamic>> timeTableDB;

  static List<Buildings> Bhavans;
  static List<List<String>> SamaySarini;

  static var spaceToBuilding = Map();

  /*For venue database*/
  static Future<String> _loadVenueDatabase() async {
    return await rootBundle.loadString('assets/VenueDatabase.csv');
  }

  static Future<List<List<dynamic>>> loadVenuedatabase() async {
    String data = await _loadVenueDatabase();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);
    return rowsAsListOfValues;
  }

  /*For TimeTable database*/
  static Future<String> _loadTimeTableDatabase() async {
    return await rootBundle.loadString('assets/TimeTable.csv');
  }

  static Future<List<List<dynamic>>> loadTimeTabledatabase() async {
    String data = await _loadTimeTableDatabase();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);
    return rowsAsListOfValues;
  }

  static Future<void> fetchVenueDatabase() async{
    List<Buildings> bhavans = List<Buildings>();
    var SpaceToBuilding = Map();
    venueDB = await loadVenuedatabase();
    List<List<Spaces>> space = List<List<Spaces>>(100);
    String buildingName = venueDB[1][0];
    int count = 0;       //to count how many spaces a building has
    int idx = 0;
    space[idx] = List<Spaces>();

    for(int i=1;i<venueDB.length;i++){
      if(venueDB[i][0] == buildingName){
        //This building has more spaces
        //append this space to the end of the list "space"
        count++;
        // print(venueDB[i][4].runtimeType);
        if(!(venueDB[i][4] is String)){
          venueDB[i][4] = venueDB[i][4].toString();
        }
        SpaceToBuilding[venueDB[i][1]] = buildingName;
        space[idx].add(Spaces(venueDB[i][1], venueDB[i][3], venueDB[i][2], venueDB[i][4],createTimeSlots(buildingName)));
      }
      else{
        bhavans.add(Buildings(venueDB[i-1][0],count.toString(),space[idx]));
        idx+=1;
        space[idx] = List<Spaces>();
        buildingName = venueDB[i][0];
        count = 1;
        if(!(venueDB[i][4] is String)){
          venueDB[i][4] = venueDB[i][4].toString();
        }
        SpaceToBuilding[venueDB[i][1]] = buildingName;
        space[idx].add(Spaces(venueDB[i][1], venueDB[i][3], venueDB[i][2], venueDB[i][4],createTimeSlots(buildingName)));
      }
    }

    bhavans.add(Buildings(venueDB[venueDB.length-1][0],count.toString(),space[idx]));

    // for(int i=0;i<bhavans.length;i++){
    //    print("#"+bhavans[i].name  + " " + bhavans[i].spaces.length.toString());
    //   for(int j=0;j<bhavans[i].spaces.length;j++){
    //     print(bhavans[i].spaces[j].name+" "+bhavans[i].spaces[j].type);
    //   }
    // }

    if(bhavans.isEmpty)
      print("Leaving fetch"+bhavans.isEmpty.toString());
    CreateDatabse.Bhavans=bhavans;
    CreateDatabse.spaceToBuilding=SpaceToBuilding;

  }

  /*######################################################## */

  static Future<void> fetchTimeTableDatabase() async{
    List<List<String>> samaySarini = List<List<String>>();
    timeTableDB = await loadTimeTabledatabase();
    for(int i=1;i<timeTableDB.length;i++){
      List<String> temp = new List<String>();
      temp.add(timeTableDB[i][11]);   //Venue
      temp.add(timeTableDB[i][1]);    //Course Code
      temp.add(timeTableDB[i][6]);    //Day
      temp.add(timeTableDB[i][7]);    //Start Time
      temp.add(timeTableDB[i][8]);    //End Time
      temp.add(timeTableDB[i][10]);   //Purpose
      samaySarini.add(temp);
    }
    CreateDatabse.SamaySarini=samaySarini;

  }

  //Each Space has 336 time slots: 24hours*2*7days
  static List<TimeSlots> createTimeSlots(String buildingName)
  {
    List<int> buildingTimings = buildingToStartEndTime(buildingName);
    List<TimeSlots> ts = List<TimeSlots>();
    int timeDuration  =30;
    int startTime = buildingTimings[0];
    int endTime = buildingTimings[0]+timeDuration;

    for(int i=0;i<days.length;i++){
      int startTimeTemp = startTime;
      int endTimeTemp = endTime;
      int temp;
      while(endTimeTemp<=buildingTimings[1])
      {
        ts.add(TimeSlots(minuteToTime(startTimeTemp),minuteToTime(endTimeTemp),days[i]));
        temp=endTimeTemp;
        endTimeTemp=temp+timeDuration;
        startTimeTemp=temp;
      }

    }

    return ts;
  }

}

String minuteToTime(int time){
  String formatted = "";
  double h = time/60;
  int hours = h.toInt();
  int minutes = time%60;
  if(hours.toString().length<2)
    formatted= formatted + "0"+ hours.toString();
  else formatted+=hours.toString();
  formatted+=":";
  if(minutes.toString().length<2)
    formatted = formatted+"0"+minutes.toString();
  else formatted+=minutes.toString();
  return formatted;
}

List<int> buildingToStartEndTime(String buildingName){
  switch(buildingName){
    case 'Seminar Block':
    case 'Old Academic Block':
    case 'R&D Block':
      return [480,1080];
      break;
    case 'Library Building':
    case 'Sports Block':
      return [0,1440];
      break;
    default: return [0,1440];
  }
}

var days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

int dayToIndex(String day){
  switch(day){
    case 'Monday':
    case 'monday':
      return 0;
      break;
    case 'Tuesday':
    case 'tuesday':
      return 1;
      break;
    case 'Wednesday':
    case 'wednesday':
      return 2;
      break;
    case 'Thursday':
    case 'thursday':
      return 3;
      break;
    case 'Friday':
    case 'friday':
      return 4;
      break;
    case 'Saturday':
    case 'saturday':
      return 5;
      break;
    case 'Sunday':
    case 'sunday':
      return 6;
      break;
    default:
      print("~~~INVALID DAY~~~");

  }
  return -1;
}




// DateTime _date = new DateTime.now();
// TimeOfDay _startTime = new TimeOfDay.now();
// TimeOfDay _endTime   = new TimeOfDay.now();

// Future<Null> _selectDate(BuildContext context) async{
//   final DateTime picked = await showDatePicker(
//     context: context,
//     initialDate: _date,
//     firstDate: _date,
//     lastDate: new DateTime(_date.year,_date.month,_date.day+2),
//     );
//     if(picked!=null){
//       _date = picked;
//     }
// }

// Future<Null> _selectStartTime(BuildContext context) async{
//   final TimeOfDay picked = await showTimePicker(
//     context: context,
//     initialTime: _startTime,
//   );
//   if(picked!=null){
//     _startTime = picked;
//   }
// }

// Future<Null> _selectEndTime(BuildContext context) async{
//   final TimeOfDay picked = await showTimePicker(
//     context: context,
//     initialTime: _endTime,
//   );
//   if(picked!=null){
//     _endTime = picked;
//   }
// }