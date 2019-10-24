//import 'dart:io';
import 'dart:async';
//import 'dart:convert';
import 'package:csv/csv.dart';
//import 'package:flutter/material.dart';
import 'package:project1_app/models/Buildings.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:project1_app/models/TimeSlots.dart';
import 'models/Spaces.dart';


class CreateDatabse {

  List<List<dynamic>> venueDB;
  List<Buildings> Bhavans;

  Future<String> _loadVenueDatabase() async {
    print('File Access');
    return await rootBundle.loadString('assets/VenueDatabase.csv');
  }

  Future<List<List<dynamic>>> loadVenuedatabase() async {
    String data = await _loadVenueDatabase();
    print('After file acess');
    List<List<String>> rowsAsListOfValues = const CsvToListConverter().convert(data);
    print("loadVenuedatabase = "+rowsAsListOfValues.toString());
    return rowsAsListOfValues;
  }


  List<TimeSlots> createTimeSlots(int start,int end,int duration)
  {
    List<TimeSlots> ts;
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

    fetchVenueDatabase() async{
    print("Inside fetch");
    List<Buildings> bhavans = List<Buildings>();
    venueDB = await loadVenuedatabase();
    print("After await , venueDB = ");
    List<Spaces> space = List<Spaces>();
    String buildingName = venueDB[1][0];
    int count = 0;       //to count how many spaces a building has
    print("Length of venue dynamic list is "+venueDB.length.toString());
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
    this.Bhavans=bhavans;

  }

  List<Buildings> returnFetchedBuildings()
  {
    fetchVenueDatabase();
    return Bhavans;

  }



//  void main()
//  {
//    fetchVenueDatabase();
//    for(int i=0;i<bhavans.length;i++){
//          print(bhavans[i].noofspaces);
//    }
//  }


}