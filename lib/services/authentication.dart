import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project1_app/models/Account.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Dref = FirebaseDatabase.instance.reference();

  void _createAccount(String email,String id) async
  {
    String first = email.split('@')[0];
    String name = first;
    bool isStudent = false;
    List<String> no = ['0','1','2','3','4','5','6','7','8','9'];
    for(int i=0;i<no.length;i++)
      {
        if(name.contains(no[i]))
          {
            isStudent = true;
            name.replaceAll(no[i], '');
          }
      }
    String privilege = '3';
    String role = 'Administration';
//    if(isStudent)
//      {
//        privilege=1;
//        role = 'Student';
//      }
    Account account = Account(name,id,email,role,privilege);
    Dref.child('Users').child(id).set(json.encode(account.toJson()));
//    return Account(name,id,email,role);
  }

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
//    Dref.push().set();
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    _createAccount(email,user.uid);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
//    signOut();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
