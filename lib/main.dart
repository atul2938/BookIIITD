import 'package:flutter/material.dart';
import './services/authentication.dart';
import 'Pages/RootPage.dart';


void main()=>(runApp(MyApp()));



class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RootPage(auth: new Auth());
  }

}