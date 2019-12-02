// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimeSlots.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlots _$TimeSlotsFromJson(Map<String, dynamic> json) {

  return TimeSlots(DateTime.parse(json['date'] as String),json['startTime'], json['endTime'],json['day'],json['purpose'])
    ..isVacant = json['isVacant'] as bool;
}

Map<String, dynamic> _$TimeSlotsToJson(TimeSlots instance) => <String, dynamic>{
      'date': instance.date.toIso8601String().split('T')[0],
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'day': instance.day,
      'isVacant': instance.isVacant,
      'purpose': instance.purpose
    };
