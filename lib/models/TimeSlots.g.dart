// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimeSlots.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlots _$TimeSlotsFromJson(Map<String, dynamic> json) {

  return TimeSlots(json['startTime'], json['endTime'],json['day'])
    ..isVacant = json['isVacant'] as bool;
}

Map<String, dynamic> _$TimeSlotsToJson(TimeSlots instance) => <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'day': instance.day,
      'isVacant': instance.isVacant
    };
