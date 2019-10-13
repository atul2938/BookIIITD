import 'package:flutter/material.dart';

class SearchSpaceHome extends StatelessWidget {
  final List<String> SpaceOptions = ['Library','Old Acad','R&D Building','Seminar Building','Sports Courts'];
  @override
  Widget build(BuildContext context) {

    return Column(children:

      SpaceOptions.map( (str){
        return Container(
          margin: EdgeInsets.all(13),
          height: 70,
          width: double.infinity,
          child: RaisedButton(child: Text(str),onPressed: (){},),
        );
    }).toList()

    );
  }
}
