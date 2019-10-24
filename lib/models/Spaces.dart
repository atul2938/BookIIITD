import 'package:project1_app/models/TimeSlots.dart';

class Spaces{
  String name;
  String type;            //eg. Lecture Hall, Lab
  String floorNo;            //Floor number
  String capacity;
  List<TimeSlots> timeSlots;

  Spaces(name,type,floorNo,capacity,timeSlots)
  {
    this.name=name;
    this.type=type;
    this.floorNo=floorNo;
    this.capacity=capacity;
    this.timeSlots=timeSlots;
  }
}