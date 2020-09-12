import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;

  Slide({
    @required this.imageUrl,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/sc5.png',
  ),
  Slide(
    imageUrl: 'assets/sc4.png',
  ),
  Slide(
    imageUrl: 'assets/sc3.png',
  ),
  Slide(
    imageUrl: 'assets/sc2.png',
  ),
  Slide(
    imageUrl: 'assets/sc1.png',
  ),
];
