import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingScreen extends StatefulWidget {
  @override
  const BookingScreen({
    Key key,
  }) : super(key: key);
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "C101",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 10, //Number Of Columns
                children: new List<Widget>.generate(30, (index) {
                  return new GridTile(
                    child: new Card(
                        color: Colors.lightGreen.shade400,
                        child: new Center(
                          child: new Text('$index'),
                        )),
                  );
                }),
              ),
            ),
          ]),
    );
  }
}
