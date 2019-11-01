import './Buildings.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Request.g.dart';
//@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class Request{
  String buildingName;
  String spaceName;
  String startTime;
  String endTime;
  String description;
  String isApproved;

  Request(buildingName,spaceName,startTime,endTime,description,isApproved)
  {
    this.buildingName=buildingName;
    this.spaceName=spaceName;
    this.startTime=startTime;
    this.endTime=endTime;
    this.description =description;
    this.isApproved=isApproved;
  }

  @override
  String toString() {
    return 'Request to book '+this.spaceName.toString()+" of "+this.buildingName.toString()+"\n"+
        "From - "+this.startTime.toString()+"  Till - "+this.endTime.toString()+
        "\n"+"Description: "+this.description.toString()+"\n"+
        "Approval Status - "+this.isApproved.toString()+"\n";
  }


  factory Request.fromMappedJson(Map<String, dynamic> json) => _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);

}