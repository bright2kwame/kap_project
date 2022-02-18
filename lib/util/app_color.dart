import 'package:flutter/material.dart';
import 'package:knowledge_access_power/resources/color_resource.dart';

class AppColor {
  static get primaryColor => HexColor.fromHex(ColorResource.primaryColor);
  static get primaryLightColor =>
      HexColor.fromHex(ColorResource.primaryLightColor);
  static get primaryDarkColor =>
      HexColor.fromHex(ColorResource.primaryDarkColor);
  static get bgColor => HexColor.fromHex(ColorResource.bgColor);
  static get secondaryColor => HexColor.fromHex(ColorResource.secondaryColor);
  static get twitterColor => HexColor.fromHex(ColorResource.twitterColor);
  static get facebookColor => HexColor.fromHex(ColorResource.facebookColor);
  static get googleColor => HexColor.fromHex(ColorResource.googleColor);
  static MaterialColor primaryMaterialColor = MaterialColor(0xFF5CC5E8, color);
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Map<int, Color> color = {
  50: const Color.fromRGBO(92, 197, 232, .1),
  100: const Color.fromRGBO(92, 197, 232, .2),
  200: const Color.fromRGBO(92, 197, 232, .3),
  300: const Color.fromRGBO(92, 197, 232, .4),
  400: const Color.fromRGBO(92, 197, 232, .5),
  500: const Color.fromRGBO(92, 197, 232, .6),
  600: const Color.fromRGBO(92, 197, 232, .7),
  700: const Color.fromRGBO(92, 197, 232, .8),
  800: const Color.fromRGBO(92, 197, 232, .9),
  900: const Color.fromRGBO(92, 197, 232, 1),
};
