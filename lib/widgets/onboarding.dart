import 'package:flutter/material.dart';

import 'util.dart';
//import 'package:flutter_click_app/empty.dart';

class Onboarding extends StatefulWidget {
//  Onboarding({Key key}) : super(key: key);
  Function goBackFunc;
  Onboarding(this.goBackFunc);
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child:  Image(image: AssetImage("assets/images/512a.png")),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Easy Booking',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.TextHeader),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Book any venue across campus easily anytime and forget the problem of finding spaces. Just use Space Jet',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.TextBody,
                          fontFamily: 'opensans'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Onboarding_2(widget.goBackFunc)),
                    );
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          CustomColors.Green,
                          CustomColors.GreenDark,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.GreenShadow,
                          blurRadius: 15.0,
                          spreadRadius: 7.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class Onboarding_2 extends StatefulWidget {
//  Onboarding_2({Key key}) : super(key: key);
  Function goback;
  Onboarding_2(this.goback);

  _OnboardingState_2 createState() => _OnboardingState_2();
}

class _OnboardingState_2 extends State<Onboarding_2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child:  Image(image: AssetImage("assets/images/512b.png")),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Just Pick Data and Time',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.TextHeader),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Select your preferred date and time for a venue and book it easily if it is not already booked.',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.TextBody,
                          fontFamily: 'opensans'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Onboarding_3(widget.goback)),
                    );
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          CustomColors.Green,
                          CustomColors.GreenDark,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.GreenShadow,
                          blurRadius: 15.0,
                          spreadRadius: 7.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class Onboarding_3 extends StatefulWidget {
//  Onboarding_3({Key key}) : super(key: key);
    Function goback;

    Onboarding_3(this.goback);
  _OnboardingState_3 createState() => _OnboardingState_3();
}

class _OnboardingState_3 extends State<Onboarding_3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child:  Image(image: AssetImage("assets/images/512c.png")),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Events on to go',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.TextHeader),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Get the information about all the events happening in the campus at one place.',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.TextBody,
                          fontFamily: 'opensans'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: () {
                    widget.goback();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
//                  onPressed: () => widget.goback,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          CustomColors.Green,
                          CustomColors.GreenDark,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.GreenShadow,
                          blurRadius: 15.0,
                          spreadRadius: 7.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
//                  onPressed: () => widget.goback,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}


///////////////////////////////////////////////////////////////////////////////
class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  PageIndicator(this.currentIndex, this.pageCount);

  _indicator(bool isActive) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          height: 4.0,
          decoration: BoxDecoration(
              color: isActive ? Colors.white : Color(0xFF3E4750),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }

  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList
          .add(i == currentIndex ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: _buildPageIndicators(),
    );
  }
}

class DrawCircle extends CustomPainter {
  Paint _paint;

  DrawCircle() {
    _paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 100.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}