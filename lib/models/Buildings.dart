import './Spaces.dart';

class Buildings {
  String name;
  int noofspaces;
  List<Spaces> spaces;

  Buildings(name,noofspaces,spaces)
  {
    this.name=name;
    this.noofspaces=noofspaces;
    this.spaces=spaces;
  }
}