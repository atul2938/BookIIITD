//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:project1_app/backend/Auth.dart';
//
//class AuthScreen extends StatefulWidget {
//  @override
//  const AuthScreen({
//    Key key,
//  }) : super(key: key);
//  _AuthScreenState createState() => _AuthScreenState();
//}
//
//class _AuthScreenState extends State<AuthScreen> {
//  final GlobalKey<FormState> _formKey = GlobalKey();
//  TextEditingController _emailController;
//  TextEditingController _passwordController;
//
//  @override
//  void initState() {
//    super.initState();
//    _emailController = TextEditingController(text: "");
//    _passwordController = TextEditingController(text: "");
//  }
//
//  // int validatePassword(String value) {
//  //   Pattern pattern =
//  //       r'^(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//  //   RegExp regex = new RegExp(pattern);
//  //   if (!regex.hasMatch(value))
//  //     return 1;
//  //   else
//  //     return 0;
//  // }
//
//  @override
//  Widget build(BuildContext context) {
//    final deviceSize = MediaQuery.of(context).size;
//    return Scaffold(
//      body: SingleChildScrollView(
//        child: Container(
//          height: deviceSize.height,
//          width: deviceSize.width,
//          child: Form(
//            key: _formKey,
//            autovalidate: true,
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                const SizedBox(height: 100.0),
//                Stack(
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.only(left: 32.0),
//                      child: Text(
//                        "Sign In",
//                        style: TextStyle(
//                            fontSize: 30.0, fontWeight: FontWeight.bold),
//                      ),
//                    ),
//                  ],
//                ),
//                const SizedBox(height: 30.0),
//                Padding(
//                  padding:
//                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
//                  child: TextFormField(
//                    controller: _emailController,
//                    keyboardType: TextInputType.emailAddress,
//                    validator: (value) {
//                      if (value.isEmpty || !value.contains('@') || value.length <8) {
//                        return 'Invalid email!';
//                      }
//                      else if(!value.contains('@iiitd.ac.in')){
//                        return 'Use official IIITD email';
//                      }
//                      else
//                        return null;
//                    },
//                    textInputAction: TextInputAction.done,
//                    autocorrect: false,
//                    maxLength: 30,
//                    decoration: InputDecoration(
//                        labelText: "Email",
//                        hasFloatingPlaceholder: true,
//                        border: OutlineInputBorder(),
//                        counterText: ""),
//                  ),
//                ),
//                Padding(
//                  padding:
//                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
//                  child: TextFormField(
//                    controller: _passwordController,
//                    obscureText: true,
//                    validator: (value) {
//                      if (value.isEmpty || value.length < 5) {
//                        return 'Password is too short!';
//                      }
//                      else return null;
//                    },
//                    decoration: InputDecoration(
//                        labelText: "Password",
//                        hasFloatingPlaceholder: true,
//                        border: OutlineInputBorder()),
//                  ),
//                ),
//                Container(
//                    padding: const EdgeInsets.only(right: 30.0),
//                    alignment: Alignment.centerRight,
//                    child: Text("Forgot your password?")),
//                const SizedBox(height: 100.0),
//                Align(
//                  alignment: Alignment.centerRight,
//                  child: RaisedButton(
//                    padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
//                    color: Color(0xff3FADA8),
//                    elevation: 0,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(30.0),
//                            bottomLeft: Radius.circular(30.0))),
//                    onPressed: () async{
//                      //What happens when "Sign In" is clicked
//                      if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
//                        return;
//                      }
//                      bool res = await AuthProvider().signInWithEmail(
//                          _emailController.text, _passwordController.text);
//                      if(!res){
//                        print("Login Failed");
//                      }
//                    },
//                    child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        Text(
//                          "Sign In".toUpperCase(),
//                          style: TextStyle(fontSize: 16.0, color: Colors.white),
//                        ),
//                        const SizedBox(width: 40.0),
//                        Icon(
//                          FontAwesomeIcons.arrowRight,
//                          size: 18.0,
//                          color: Colors.white,
//                        )
//                      ],
//                    ),
//                  ),
//                ),
//                // const SizedBox(height: 50.0),
//                // Row(
//                //   mainAxisAlignment: MainAxisAlignment.center,
//                //   children: <Widget>[
//                //     OutlineButton.icon(
//                //       padding: const EdgeInsets.symmetric(
//                //         vertical: 8.0,
//                //         horizontal: 30.0,
//                //       ),
//                //       shape: RoundedRectangleBorder(
//                //           borderRadius: BorderRadius.circular(20.0)),
//                //       borderSide: BorderSide(color: Colors.red),
//                //       color: Colors.red,
//                //       highlightedBorderColor: Colors.red,
//                //       textColor: Colors.red,
//                //       icon: Icon(
//                //         FontAwesomeIcons.googlePlusG,
//                //         size: 18.0,
//                //       ),
//                //       label: Text("Google"),
//                //       onPressed: () {},
//                //     ),
//                //   ],
//                // )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
