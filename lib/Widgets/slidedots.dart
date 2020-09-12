import 'package:flutter/material.dart';
import 'package:example/Utilities/constants.dart';

class SlideDots extends StatelessWidget {
  final bool isActive;

  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? 10 : 10,
      width: isActive ? 18 : 10,
      decoration: BoxDecoration(
        color: isActive ? secondaryColor : Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}
