// import 'package:project1_app/models/TimeSlots.dart';

class Spaces{
  String name;
  String type;            //eg. Lecture Hall, Lab
  int floorNo;            //Floor number
  int capacity;
  // List<TimeSlots> times;

  Spaces(name,type,floorNo,capacity,times)
  {
    this.name=name;
    this.type=type;
    this.floorNo=floorNo;
    this.capacity=capacity;
    // this.times=times;
  }
}