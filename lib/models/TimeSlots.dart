//import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'TimeSlots.g.dart';

@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class TimeSlots{
  
  // TimeOfDay startTime;
  // TimeOfDay endTime;
  // DateTime day;

  String startTime;    //HHMM format, eg 1915
  String endTime;      //HHMM format
  // String day;       
  // String purpose;   //eg. Class
  bool isVacant;

  TimeSlots(startTime, endTime){
    this.startTime=startTime;
    this.endTime = endTime;
    this.isVacant = true;
    // this.day=null;
    // this.purpose = null;
  }
  // TimeSlots.withPurpose(startTime, endTime, day, purpose)
  // {
  //   this.startTime = startTime;
  //   this.endTime   = endTime;
  //   this.day       = day;
  //   this.purpose   = purpose;
  //   this.isVacant  = true;
  // }

  // void updateDescription(purpose) {
  //   this.purpose = purpose;
  // }

   @override
  String toString()
  {
    return this.startTime.toString()+"-"+this.endTime.toString()+","+this.isVacant.toString();
  }

  factory TimeSlots.fromMappedJson(Map<String, dynamic> json) => _$TimeSlotsFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotsToJson(this);
}