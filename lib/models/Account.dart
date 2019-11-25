import 'package:json_annotation/json_annotation.dart';
part 'Account.g.dart';
@JsonSerializable(explicitToJson: true)
@JsonSerializable()

class Account {
  String name;
  String id;
  String emailId;
  String role;
  String privilege;

  Account(name,id,emailId,role,privilege){
    this.name=name;
    this.id=id;
    this.emailId=emailId;
    this.role=role;
    this.privilege=privilege;
//    if(role=='Administration')
//      {
//        privilege=3;
//      }
//    else if(role=='Faculty')
//      {
//        privilege =2;
//      }
//    else
//      {
//        privilege =1;
//      }
  }

  @override
  String toString() {
      return this.name + ' ' + this.id + ' ' + this.role + ' ' + this.emailId + ' '+ this.privilege.toString();
  }

  factory Account.fromMappedJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}