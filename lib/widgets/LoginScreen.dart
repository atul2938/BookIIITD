import 'package:flutter/material.dart';
import 'package:project1_app/models/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  String _email, _password;
  final Account myaccount = Account('Himanshu','himanshu17291@iiitd.ac.in','Student');
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen", style: TextStyle(color: Colors.white, fontSize: 12),),
      ) ,
      body: Container(
        child: Center(
          child: Container(
            width: 300,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration.collapsed(hintText: "e-mail", border: UnderlineInputBorder()),
                  onChanged: (value){
                    this.setState((){_email = value;});
                  },
                ),
                TextField(
                  decoration: InputDecoration.collapsed(hintText: "Password", border: UnderlineInputBorder()),
                  onChanged: (value){
                    this.setState((){_password = value;});
                  },
                ),
                RaisedButton(child: Text("Sign In"), onPressed: (){
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _email,password: _password).then((onvalue){
                    
                  }).catchError((error){
                    debugPrint("Error: " + error);
                  });
                } ,)
              ],
            ),
          ),
        ),
      ),
      );
  }
}