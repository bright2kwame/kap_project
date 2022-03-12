import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/home/home_page.dart';
import 'package:knowledge_access_power/home/knowledge_page.dart';
import 'package:knowledge_access_power/home/settings_page.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/util/manage_platform.dart';

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
  UserItem _user = UserItem();
  String _displayTitle = "Knowledge & Access Power";
  List<Widget> _children = [];
  final List<IconData> _tabIcons = [
    CupertinoIcons.home,
    CupertinoIcons.lightbulb,
    CupertinoIcons.settings
  ];
  @override
  void initState() {
    _getData(true);
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

  void _getData(bool reload) {
    DBOperations().getUser().then((value) {
      setState(() {
        _user = value;
        _children = [
          HomePage(
            user: _user,
          ),
          KnowledgePage(
            user: _user,
          ),
          SettingsPage(user: _user)
        ];
      });
      if (reload) {
        _getFirebaseToken();
        _getUserProfile();
        _updatePoint();
      }
    });
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
    data.putIfAbsent("token", () => token);
    data.putIfAbsent("request_source", () => ManagePlatform().getChannelName());
    ApiService.get(_user.token)
        .postData(ApiUrl().saveToken(), data)
        .then((result) {})
        .onError((error, stackTrace) => null);
  }

  void _updatePoint() {
    Map<String, String> data = {};
    data.putIfAbsent("request_source", () => ManagePlatform().getChannelName());
    ApiService.get(_user.token)
        .postData(ApiUrl().updatePoint(), data)
        .then((result) {})
        .onError((error, stackTrace) => null);
  }

  void _getUserProfile() {
    ApiService.get(_user.token)
        .getData(ApiUrl().myProfile())
        .then((result) async {
      var responseCode = result["response_code"].toString();
      if (responseCode == "100") {
        UserItem userItem = ParseApiData().parseUser(result["results"]);
        await DBOperations().updateUser(userItem);
        _getData(false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
