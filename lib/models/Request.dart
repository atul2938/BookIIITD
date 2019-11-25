import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import './Buildings.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Request.g.dart';
//@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class Request{
  String key;
  String buildingName;
  String spaceName;
  String day;
  String startTime;
  String endTime;
  String description;
  String isApproved;
  String makeItEvent;
  String eventDetails;
  String remarks;
  String username;
  String userId;
  String isCanceled;
  String isRejected;

  Request(buildingName,spaceName,day,startTime,endTime,description,isApproved,makeitevent,eventDetails,remarks,username,userId,isCanceled,isRejected)
  {
    this.key=userId+'_'+spaceName+'_'+day+'_'+startTime+'_'+endTime;
    this.buildingName=buildingName;
    this.spaceName=spaceName;
    this.day=day;
    this.startTime=startTime;
    this.endTime=endTime;
    this.description =description;
    this.isApproved=isApproved;
    this.makeItEvent=makeitevent;
    this.eventDetails=eventDetails;
    this.remarks=remarks;
    this.username=username;
    this.userId = userId;
    this.isCanceled = isCanceled;
    this.isRejected = isRejected;
  }

  Request.fromSnapshot(DataSnapshot dataSnapshot)
  {
    Request r = Request.fromMappedJson(jsonDecode(dataSnapshot.value));
    r.key = dataSnapshot.key;
  }

  @override
  String toString() {
    return 'Request to book '+this.spaceName.toString()+" of "+this.buildingName.toString()+"\n"+
        "From - "+this.startTime.toString()+"  Till - "+this.endTime.toString()+
        "\n"+"Description: "+this.description.toString()+"\n"+
        "Approval Status - "+this.isApproved.toString()+"\n"+
    'Request made by '+this.username+"\n"
    'its a event - '+this.makeItEvent+' details  - '+this.eventDetails+"\n";
  }


  factory Request.fromMappedJson(Map<String, dynamic> json) => _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);

}