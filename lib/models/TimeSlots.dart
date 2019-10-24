//import 'package:flutter/cupertino.dart';
class TimeSlots{
  
  int startTime;    //HHMM format, eg 1915
  int endTime;      //HHMM format
  String day;       
  String purpose;   //eg. Class
  bool isVacant;

  TimeSlots(startTime, endTime){
    this.startTime=startTime;
    this.endTime = endTime;
    this.isVacant = true;
    this.day=null;
    this.purpose = null;
  }
  TimeSlots.withPurpose(startTime, endTime, day, purpose)
  {
    this.startTime = startTime;
    this.endTime   = endTime;
    this.day       = day;
    this.purpose   = purpose;
    this.isVacant  = true;
  }

  void updateDescription(purpose) {
    this.purpose = purpose;
  }
}