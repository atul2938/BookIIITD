
import 'package:project1_app/models/Buildings.dart';

class Request{
  Buildings building;
  String spaceName;
  int startTime;
  int endTime;
  String decription;

  Request(building,startTime,endTime,description)
  {
    this.building=building;
    this.decription =description;
    this.startTime=startTime;
    this.endTime=endTime;
  }

}