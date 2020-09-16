import 'package:flutter/material.dart';
import 'package:sk_onboarding_screen/flutter_onboarding.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';

import 'package:example/screens/pass.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(4280033838),
      key: _globalKey,
      body: Container(
        color: Color(4280033838),
        child: SKOnboardingScreen(
          bgColor: Color(4280033838),
          themeColor: Colors.orange,
          pages: pages,
          skipClicked: (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PasswordSet()),
                (route) => false);
          },
          getStartedClicked: (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PasswordSet()),
                (route) => false);
          },
        ),
      ),
    );
  }

  final pages = [
    SkOnboardingModel(
        title: 'Scan a document ',
        description: 'You can scan a document form  gallery or your camera',
        titleColor: Colors.orange,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/main1.jpeg'),
    SkOnboardingModel(
        title: 'Scanning the document ',
        description:
            'You can easily click a photo and then head on to cropping ',
        titleColor: Colors.orange,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/main2.jpeg'),
    SkOnboardingModel(
        title: 'Crop and done',
        description: 'You can easily crop the documents by moving the edges ',
        titleColor: Colors.orange,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/main3.jpeg'),
  ];
}
