import 'package:flutter/material.dart';
import 'package:knowledge_access_power/home/home_page.dart';
import 'package:knowledge_access_power/home/home_tab_page.dart';
import 'package:knowledge_access_power/onboard/tutorial_page.dart';
import 'package:knowledge_access_power/util/app_color.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knowledge Access Power',
      theme: ThemeData(
          primarySwatch: AppColor.primaryMaterialColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto'),
      home: isLoggedIn ? const HomeTabScreen() : const TutorialPage(),
    );
  }
}
