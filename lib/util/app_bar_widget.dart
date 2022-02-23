import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class AppBarWidget {
  static get whiteAppBar => AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // Navigation bar
        statusBarColor: Colors.white,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: const BackButton(color: Colors.white));

  static primaryAppBar(String title) => AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // Navigation bar
          statusBarColor: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          title,
          style: AppTextStyle.normalTextStyle(Colors.white, 16.0),
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        elevation: 0,
      );

  static transparentAppBar(String title) => AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          title,
          style: AppTextStyle.normalTextStyleShadowed(Colors.white, 16.0),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      );
}
