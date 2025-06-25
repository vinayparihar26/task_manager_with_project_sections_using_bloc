import 'dart:io';

import 'package:flutter/material.dart';

class ResponsiveValues {
  final double screenWidth;

  late final double fontSize;
  late final double iconSize;
  late final double btnHeight;
  late final double sizeBox;
  ResponsiveValues(BuildContext context)
    : screenWidth = MediaQuery.of(context).size.width {
    fontSize =
        screenWidth > 900
            ? 25
            : screenWidth > 800
            ? 24
            : screenWidth > 600
            ? 20
            : 14;

    iconSize = screenWidth > 600 ? 24 : 20;
    btnHeight = screenWidth > 600 ? 44 : 36;
    sizeBox = screenWidth > 600 ? 55 : 45;
  }
}

double getHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(context) {
  return MediaQuery.of(context).size.width;
}

// double getResponsive(context) {
//   return MediaQuery.of(context).size.height * 0.001;
// }

double getResponsive(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final shortestSide = size.shortestSide;
  return (shortestSide / 375).clamp(0.85, 1.1);
}

double getResponsiveText(context) {
  if (Platform.isAndroid) {
    return 0.8;
  } else {
    return 0.9;
  }
}

double getResponsiveOnWidth(context) {
  return MediaQuery.of(context).size.width * 0.001;
}
