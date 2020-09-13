import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/Utilities/constants.dart';
import 'package:example/Widgets/slidedots.dart';
import 'package:example/Widgets/slideitems.dart';
import 'home_screen.dart';
import 'package:example/Utilities/slide.dart';

class GettingStartedScreen extends StatefulWidget {
  static String route = 'GettingStarted';

  GettingStartedScreen({this.showSkip});

  final bool showSkip;

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: (!widget.showSkip)
            ? IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'How to use the app?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, fontFamily: "space"),
        ),
      ),
      body: Container(
        color: primaryColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      accentColor: primaryColor,
                    ),
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => SlideItem(i),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
