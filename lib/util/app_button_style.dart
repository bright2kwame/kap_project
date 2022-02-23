import 'package:flutter/material.dart';
import 'package:knowledge_access_power/util/app_color.dart';

class AppButtonStyle {
  static get squaredPlainEdgeButton => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(color: AppColor.primaryColor))));

  static get squaredColoredEdgeButton => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
      shadowColor: MaterialStateProperty.all(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(color: AppColor.primaryColor))));

  static get squaredSmallColoredEdgeButton => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(color: AppColor.primaryColor))));

  static get roundedColoredEdgeButton => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: AppColor.primaryColor))));

  static get roundedPlainEdgeButton => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: AppColor.primaryColor, width: 0.5))));

  static get circularPlainButton => ButtonStyle(
        shape: MaterialStateProperty.all(const CircleBorder()),
        padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
        backgroundColor: MaterialStateProperty.all(AppColor.primaryColor),
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return AppColor.primaryLightColor;
          }
        }),
      );
}
