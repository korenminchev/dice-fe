import 'package:flutter/material.dart';

class AppUI {
  static const Color primaryColor = Color(0xFFA02BB4);
  static const Color lightPurpleColor = Color(0xFFF3ABFF);
  static const Color lightGrayColor = Color(0xFF756F76);

  static const int widthUnitsCount = 62;
  static const int heightUintsCount = 110;

  static double widthUnitSize = 0;
  static double heightUnitSize = 0;

  static void setUntitsSize(BuildContext context) {
    widthUnitSize = (MediaQuery.of(context).size.width / widthUnitsCount);
    heightUnitSize = (MediaQuery.of(context).size.height / heightUintsCount);
  }

  static double get widthUnit => widthUnitSize;
  static double get heightUnit => heightUnitSize;
}
