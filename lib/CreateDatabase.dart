//import 'dart:io';
import 'dart:async';
//import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter/material.dart';
import 'package:project1_app/models/Buildings.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:project1_app/models/TimeSlots.dart';
import 'models/Spaces.dart';


class CreateDatabse  {

  static List<List<dynamic>> venueDB;
  static List<Buildings> Bhavans;

  List<Buildings> getBhavans(){
    return Bhavans;
  }

  static Future<String> _loadVenueDatabase() async {
    return await rootBundle.loadString('assets/VenueDatabase.csv');
  }

  static Future<List<List<dynamic>>> loadVenuedatabase() async {
    String data = await _loadVenueDatabase();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);
    return rowsAsListOfValues;
  }


  static List<TimeSlots> createTimeSlots(int start,int end,int duration)
  {
    List<TimeSlots> ts = List<TimeSlots>();
    int timeDuration  =duration;
    int startTime = start;
    int endTime = start+timeDuration;
    int temp;
    while(endTime<=end)
      {
        ts.add(TimeSlots(startTime,endTime));
        temp=endTime;
        endTime=temp+timeDuration;
        startTime=temp;
      }

      return ts;

  }

   static Future<void> fetchVenueDatabase() async{
    // print("Inside fetch");
    List<Buildings> bhavans = List<Buildings>();
    venueDB = await loadVenuedatabase();
    // print("After await , venueDB = ");
    List<Spaces> space = List<Spaces>();
    String buildingName = venueDB[1][0];
    int count = 0;       //to count how many spaces a building has
    // print("Length of venue dynamic list is "+venueDB.length.toString());
    for(int i=1;i<venueDB.length;i++){
      if(venueDB[i][0] == buildingName){
        //This building has more spaces
        //append this space to the end of the list "space"
        count++;
        // print(venueDB[i][4].runtimeType);
        if(!(venueDB[i][4] is String)){
          venueDB[i][4] = venueDB[i][4].toString();
        }
        space.add(Spaces(venueDB[i][1], venueDB[i][3], venueDB[i][2], venueDB[i][4],createTimeSlots(800, 1800, 30)));
      }
      else{
        bhavans.add(Buildings(venueDB[i-1][0],count,space));
        buildingName = venueDB[i][0];
        count = 1;
        space.clear();
        if(!(venueDB[i][4] is String)){
          venueDB[i][4] = venueDB[i][4].toString();
        }
        space.add(Spaces(venueDB[i][1], venueDB[i][3], venueDB[i][2], venueDB[i][4],createTimeSlots(800, 1800, 30)));
      }
    }
    bhavans.add(Buildings(venueDB[venueDB.length-1][0],count,space));

    for(int i=0;i<bhavans.length;i++){
      print(bhavans[i].noofspaces);
    }

    if(bhavans.isEmpty)
      print("Leaving fetch"+bhavans.isEmpty.toString());
    CreateDatabse.Bhavans=bhavans;

  }

  // List<Buildings> returnFetchedBuildings()
  // {
  //   fetchVenueDatabase();
  //   return bhavans;

  // }


//  void main()
//  {
//    fetchVenueDatabase();
//    for(int i=0;i<bhavans.length;i++){
//          print(bhavans[i].noofspaces);
//    }
//  }


}