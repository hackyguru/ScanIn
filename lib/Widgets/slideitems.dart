import 'package:example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:example/Utilities/slide.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SlideItem extends StatelessWidget {
  final int index;

  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: 430,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(slideList[index].imageUrl),
              ),
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        Padding(
          padding: EdgeInsets.only(top: 450, left: 10),
          child: Container(
            width: 170,
            height: 50,
            child: StepProgressIndicator(
              totalSteps: 6,
              currentStep: 1,
              size: 4,
              padding: 0,
              selectedColor: Colors.yellow,
              unselectedColor: Colors.cyan,
              roundedEdges: Radius.circular(10),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DocIt()));
          },
          child: Padding(
              padding: EdgeInsets.only(top: 450, left: 270),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange),
                child: Image.asset("assets/forward.png"),
              )),
        )
      ],
    );
  }
}
