// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Spaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Spaces _$SpacesFromJson(Map<String, dynamic> json) {
  //  print('INside timeslots');
  List<TimeSlots> timeList = new List<TimeSlots>();
  for(int i=0;i<json['timeSlots'].length;i++)
  {
    timeList.add(TimeSlots.fromMappedJson(json['timeSlots'][i]));
  }
  return Spaces(json['name'], json['type'], json['floorNo'], json['capacity'],
      timeList);

}

Map<String, dynamic> _$SpacesToJson(Spaces instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'floorNo': instance.floorNo,
      'capacity': instance.capacity,
      'timeSlots': instance.timeSlots?.map((e) => e?.toJson())?.toList(),
    };
