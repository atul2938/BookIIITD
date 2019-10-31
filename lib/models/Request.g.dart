// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request(
    json['buildingName'],
    json['spaceName'],
    json['startTime'],
    json['endTime'],
    json['description'],
    json['isApproved'],
  );
}

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'buildingName': instance.buildingName,
      'spaceName': instance.spaceName,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'description': instance.description,
      'isApproved': instance.isApproved,
    };
