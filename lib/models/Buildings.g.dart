// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Buildings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Buildings _$BuildingsFromJson(Map<String, dynamic> json) {
  //  print('json spaces');
//  print(json['spaces'].runtimeType);
//  print(json['spaces'].length);
//  print(json['spaces'][1].toString());
//  print(json['spaces'][1].runtimeType);
  List<Spaces> spacelist = new List<Spaces>();
  for(int i=0;i<json['spaces'].length;i++)
  {
    spacelist.add(Spaces.fromMappedJson(json['spaces'][i]));
  }
  return Buildings(json['name'], json['noofspaces'], spacelist);
}

Map<String, dynamic> _$BuildingsToJson(Buildings instance) => <String, dynamic>{
      'name': instance.name,
      'noofspaces': instance.noofspaces,
      'spaces': instance.spaces?.map((e) => e?.toJson())?.toList(),
    };
