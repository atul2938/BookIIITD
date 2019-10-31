import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> signInWithEmail(String email, String password) async{
    try{
    var user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if(user != null)
     return true;
    else return false;
    }
    catch(e){
      return false;
    }
  }
}