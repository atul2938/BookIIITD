import './Spaces.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Buildings.g.dart';
@JsonSerializable(explicitToJson: true)
@JsonSerializable()

class Buildings {
  String name;
  String noofspaces;
  List<Spaces> spaces;

  Buildings(name,noofspaces,spaces)
  {
    this.name=name;
    this.noofspaces=noofspaces;
    this.spaces=spaces;
  }

  @override
   String toString() {
    String spaceTemp = ". ";
    for(int i=0;i<this.spaces.length;i++)
      {
        spaceTemp = spaceTemp+" "+ i.toString()+") "+this.spaces[i].toString();
      }
    return this.name.toString()+" has "+this.noofspaces.toString()+" spaces which are "+"{ "+spaceTemp+"}";
  }

  factory Buildings.fromMappedJson(Map<String, dynamic> json) => _$BuildingsFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingsToJson(this);
}