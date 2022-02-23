import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/home/home_page.dart';
import 'package:knowledge_access_power/home/knowledge_page.dart';
import 'package:knowledge_access_power/home/settings_page.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/resources/string_resource.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeTabScreenState();
  }
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _numberUnreadCount = "0";
  UserItem _user = UserItem();
  String _displayTitle = "Knowledge & Access Power";
  final List<Widget> _children = [
    const HomePage(),
    const KnowledgePage(),
    const SettingsPage()
  ];
  final List<IconData> _tabIcons = [
    CupertinoIcons.home,
    CupertinoIcons.lightbulb,
    CupertinoIcons.settings
  ];
  @override
  void initState() {
    DBOperations().getUser().then((value) {
      setState(() {
        _user = value;
      });
      _getFirebaseToken();
      _getNoOfUnReadNotification();
    });

    //MARK: register and listen for foreground notifications that come in
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      String title = message.data["messageTitle"];
      String messageBody = message.data["messageBody"];
      AppAlertDialog().showAlertDialog(context, title, messageBody, () {
        _refreshThePage();
      });
    });

    super.initState();
  }

  //MARK: reload the page to reflect changes
  void _refreshThePage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const HomeTabScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _getFirebaseToken() async {
    //MARK: get token
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _updateToken(token);
    }
  }

  void _updateToken(String token) {
    Map<String, String> data = {};
    data.putIfAbsent("notification_token", () => token);
    ApiService.get(_user.token)
        .postData(ApiUrl().saveToken(), data)
        .then((result) {})
        .onError((error, stackTrace) => null);
  }

  void _getNoOfUnReadNotification() {
    ApiService.get(_user.token)
        .getData(ApiUrl().numberOfUnread())
        .then((result) {
      var responseCode = result["response_code"];
      if (responseCode == "100") {
        setState(() {
          _numberUnreadCount = result["num_of_unread"].toString();
        });
      }
    }).onError((error, stackTrace) {});
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _displayTitle = "Home";
      } else if (index == 1) {
        _displayTitle = "Knowledge & Access Power";
      } else {
        _displayTitle = "Settings & More";
      }
    });
  }

  void _navigateToNotificationScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            Badge(
              showBadge: _numberUnreadCount != "0",
              position: BadgePosition.topEnd(top: 0, end: 3),
              stackFit: StackFit.passthrough,
              badgeColor: Colors.blue,
              animationType: BadgeAnimationType.scale,
              badgeContent: Text(
                _numberUnreadCount,
                style: AppTextStyle.normalTextStyle(Colors.white, 10),
              ),
              child: IconButton(
                icon: const Icon(CupertinoIcons.bell, color: Colors.white),
                onPressed: () {
                  _navigateToNotificationScreen();
                },
              ),
            ),
          ],
          title: Text(_displayTitle,
              style: AppTextStyle.normalTextStyle(Colors.white, 16.0)),
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _children,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            iconSize: 18,
            selectedFontSize: 18,
            unselectedItemColor: Colors.black45,
            unselectedIconTheme:
                const IconThemeData(color: Colors.black, size: 18),
            selectedIconTheme:
                IconThemeData(color: AppColor.primaryColor, size: 18),
            selectedItemColor: AppColor.primaryColor,
            selectedLabelStyle:
                AppTextStyle.normalTextStyle(Colors.black45, 12.0),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(_tabIcons[0]),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _tabIcons[1],
                  color: AppColor.primaryColor,
                  size: 30,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(_tabIcons[2]),
                label: 'Settings',
              )
            ],
          ),
        ));
  }
}
