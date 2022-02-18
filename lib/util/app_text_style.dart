import 'package:flutter/material.dart';

class AppTextStyle {
  static normalTextStyleShadowed(
    Color color,
    double fontSize,
  ) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        shadows: [
          Shadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0.5, 0.5),
              blurRadius: 5),
        ],
        fontWeight: FontWeight.normal);
  }

  static normalTextStyle(
    Color color,
    double fontSize,
  ) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal);
  }

  static italicTextStyle(Color color, double fontSize) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal);
  }

  static semiBoldTextStyle(Color color, double fontSize) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700);
  }

  static boldTextStyle(Color color, double fontSize) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold);
  }
}
