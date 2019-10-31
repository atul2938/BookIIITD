import 'package:flutter/material.dart';
import '../models/Account.dart';

class AccountScreen extends StatelessWidget {
  final Account myAccount;

  AccountScreen(this.myAccount);

  @override
  Widget build(BuildContext context) {
//    return Container(child:Text(myAccount.name));
    return ListView(
      children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                  colors: [Colors.blue, Colors.purple])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child:
                    Icon(Icons.account_circle, size: 64.0, color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                myAccount.name,
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
        ),
        ListTile(
          title: Text(
            'Email',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          subtitle: Text(myAccount.emailId, style: TextStyle(fontSize: 18)),
        ),
        Divider(),
        ListTile(
          title: Text(
            'Role',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          subtitle: Text(myAccount.role, style: TextStyle(fontSize: 18)),
        ),
        Divider(),
      ],
    );
  }
}
