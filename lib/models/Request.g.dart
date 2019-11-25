// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request(
    json['buildingName'],
    json['spaceName'],
    json['day'],
    json['startTime'],
    json['endTime'],
    json['description'],
    json['isApproved'],
    json['makeItEvent'],
    json['eventDetails'],
    json['remarks'],
    json['username'],
    json['userId'],
    json['isCanceled'],
    json['isRejected'],
  );
}

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'key': instance.key,
      'buildingName': instance.buildingName,
      'spaceName': instance.spaceName,
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'description': instance.description,
      'isApproved': instance.isApproved,
      'makeItEvent': instance.makeItEvent,
      'eventDetails': instance.eventDetails,
      'remarks': instance.remarks,
      'username': instance.username,
      'userId':instance.userId,
      'isCanceled': instance.isCanceled,
      'isRejected': instance.isRejected,
    };
