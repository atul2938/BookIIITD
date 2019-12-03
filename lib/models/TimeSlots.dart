//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'TimeSlots.g.dart';

@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class TimeSlots{
  

  // DateTime day;
  DateTime date;
  String startTime;    
  String endTime;      
  String day;       
  String purpose;   //eg. Class
  bool isVacant;

  TimeSlots(date,startTime, endTime,day,[purpose = "Not Specified"]){
    this.date = date;
    this.startTime=startTime;
    this.endTime = endTime;
    this.isVacant = true;
    this.day=day;
    this.purpose=purpose;
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
    return date.toString().split('T')[0]+ this.startTime.toString()+"-"+this.endTime.toString()+","+ this.day+","+this.isVacant.toString()+
    " "+this.purpose;
  }

  factory TimeSlots.fromMappedJson(Map<String, dynamic> json) => _$TimeSlotsFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotsToJson(this);
}