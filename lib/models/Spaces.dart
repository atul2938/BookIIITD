import 'TimeSlots.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Spaces.g.dart';
@JsonSerializable(explicitToJson: true)

@JsonSerializable()
class Spaces{
  String name;
  String type;            //eg. Lecture Hall, Lab
  int floorNo;            //Floor number
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
  
  @override
  String toString() {
    String time = " . ";
    for(int i=0;i<this.timeSlots.length;i++)
    {
        time = time + " "+i.toString()+") "+this.timeSlots[i].toString();
    }
    return this.name.toString() + " is of type "+this.type.toString()+" at floor "+this.floorNo.toString()+
    " with capacity "+ this.capacity.toString() +" and timeSlots = "+"[ "+ time+ " ]"+"\n";
  }



  factory Spaces.fromMappedJson(Map<String, dynamic> json) => _$SpacesFromJson(json);

  Map<String, dynamic> toJson() => _$SpacesToJson(this);
}