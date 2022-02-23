import 'dart:io';
import 'package:flutter/foundation.dart';

class ManagePlatform {
  String getChannelName() {
    var platformName = '';
    if (kIsWeb) {
      platformName = "WEB";
    } else {
      if (Platform.isAndroid) {
        platformName = "ANDROID";
      } else if (Platform.isIOS) {
        platformName = "IOS";
      } else if (Platform.isFuchsia) {
        platformName = "FUCHSIA";
      } else if (Platform.isLinux) {
        platformName = "LINUX";
      } else if (Platform.isMacOS) {
        platformName = "MAC_OS";
      } else if (Platform.isWindows) {
        platformName = "WINDOWS";
      }
    }
    return platformName;
  }
}
