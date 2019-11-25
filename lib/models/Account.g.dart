// GENERATED CODE - DO NOT MODIFY BY HAND
//import 'dart:convert';
part of 'Account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {

  return Account(json['name'],
  json['id'],
  json['emailId'],
  json['role'],
  json['privilge']);
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'name': instance.name,
  'id': instance.id,
  'emailId':instance.emailId,
  'role':instance.role,
  'privilege':instance.privilege,

};
