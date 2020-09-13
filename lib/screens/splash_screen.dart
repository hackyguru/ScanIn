import 'dart:async';
import 'package:example/main.dart';
import 'intro.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new Screen());
}

class Screen extends StatelessWidget {
  static String route = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scr(),
    );
  }
}

class Scr extends StatefulWidget {
  @override
  _ScrState createState() => _ScrState();
}

class _ScrState extends State<Scr> {
  bool visitingFlag = false;

  Future<void> getFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("alreadyVisited") == null) {
      visitingFlag = false;
    } else {
      visitingFlag = true;
    }
    await preferences.setBool('alreadyVisited', true);
  }

  Timer getTimerWid() {
    return Timer(Duration(seconds: 3), () {
      (visitingFlag)
          ? Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => Home()), (route) => false)
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => GettingStartedScreen(
                  showSkip: true,
                ),
              ),
            );
    });
  }

  getFlagInfo() async {
    await getFlag();
  }

  @override
  void initState() {
    super.initState();
    getFlagInfo();
    getTimerWid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4281545523),
      body: Column(children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
          reverse: true,
          child: Image.asset(
            "assets/logog.png",
            height: 680,
            width: 700,
          ),
        ))
      ]),
    );
  }
}
