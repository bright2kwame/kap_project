import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class AppBarWidget {
  static get whiteAppBar => AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // Navigation bar
        statusBarColor: Colors.white, // Status bar
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: const BackButton(color: Colors.white));

  static primaryAppBar(String title) => AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          title,
          style: AppTextStyle.semiBoldTextStyle(Colors.white, 16.0),
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        elevation: 0,
      );

  static transparentAppBar(String title) => AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          title,
          style: AppTextStyle.semiBoldTextStyle(Colors.white, 16.0),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      );
}
