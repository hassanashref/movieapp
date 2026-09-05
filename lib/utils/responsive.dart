import 'package:flutter/material.dart';

class Responsive {
  static const double designWidth = 430;
  static const double designHeight = 932;

  final BuildContext context;
  late double screenWidth;
  late double screenHeight;

  Responsive(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  double w(double px) => (px / designWidth) * screenWidth;
  double h(double px) => (px / designHeight) * screenHeight;
  double sp(double px) => (px / designWidth) * screenWidth;
}