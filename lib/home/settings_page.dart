import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:knowledge_access_power/api/api_service.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/api/parse_data.dart';
import 'package:knowledge_access_power/home/home_tab_page.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/onboard/tutorial_page.dart';
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/resources/string_resource.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/settings/events_check_in_page.dart';
import 'package:knowledge_access_power/settings/leader_board_page.dart';
import 'package:knowledge_access_power/sub_module/my_modules_page.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_input_decorator.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/util/app_util.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserItem user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String _defetworkType = "Select Network Type";
  final _networkTypes = [
    _defetworkType,
    "Airtel Tigo",
    "MTN",
    "Vodafone",
  ];
  final __networkTypeKeys = [_defetworkType, "AIR", "MTN", "VOD"];
  var _network = _defetworkType;
  static final TextEditingController _pointsController =
      TextEditingController();
  static final TextEditingController _phoneNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ProgressHUD(
            child: Builder(
      builder: (context) => _buildMainContent(context),
    )));
  }

  Widget _buildMainContent(BuildContext buildContext) {
    return Container(
        color: AppColor.bgColor,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 255,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.primaryDarkColor, width: 5),
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(100)),
                      child: ClipOval(
                        child: widget.user.avatar.isEmpty
                            ? Image.asset(
                                ImageResource.appLogo,
                                fit: BoxFit.scaleDown,
                                width: 100,
                                height: 100,
                              )
                            : Image(
                                image: CachedNetworkImageProvider(
                                    widget.user.avatar),
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      widget.user.fullName,
                      style: AppTextStyle.semiBoldTextStyle(Colors.black, 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      widget.user.email,
                      style: AppTextStyle.normalTextStyle(Colors.black, 12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      "username  • " + widget.user.username,
                      style: AppTextStyle.normalTextStyle(Colors.black, 12.0),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _shareToSocialMedia();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.badge_outlined,
                                size: 20,
                                color: AppColor.primaryDarkColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                "${widget.user.points} POINTS",
                                style: AppTextStyle.boldTextStyle(
                                    AppColor.primaryDarkColor, 14.0),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      style: AppButtonStyle.squaredSmallColoredEdgeButton,
                      child: Container(
                          color: AppColor.primaryColor,
                          child: Text(
                            "Withdraw Points",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.normalTextStyle(
                                Colors.white, 12.0),
                          )),
                      onPressed: () {
                        _navigateToRedemptionsScreen(buildContext);
                      },
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  child: _settingsCard(
                      "Modules Completed",
                      "all modules you have completed",
                      CupertinoIcons.book,
                      Colors.green,
                      false),
                  onTap: () {
                    _navigateToModulesScreen();
                  },
                ),
                GestureDetector(
                  child: _settingsCard(
                      "Badges Warned",
                      "list of all badges earned",
                      CupertinoIcons.heart,
                      Colors.brown,
                      false),
                  onTap: () {
                    _navigateToRedemptionsScreen(buildContext);
                  },
                ),
                GestureDetector(
                  child: _settingsCard(
                      "Leader Board",
                      "rank of all app learners",
                      CupertinoIcons.doc_on_doc_fill,
                      Colors.cyan,
                      false),
                  onTap: () {
                    _navigateToLeadersScreen();
                  },
                ),
                GestureDetector(
                  child: _settingsCard("My CheckIns", "all events I attended",
                      CupertinoIcons.time, Colors.black, false),
                  onTap: () {
                    _navigateEventCheckInScreen();
                  },
                ),
                GestureDetector(
                  child: _settingsCard("Help &  Support", "get help for KAP",
                      CupertinoIcons.phone_circle, Colors.blue, false),
                  onTap: () {
                    _contactSupport();
                  },
                ),
                GestureDetector(
                  child: _settingsCard(
                      "Privacy & Terms",
                      "KAP privacy and policy",
                      CupertinoIcons.eye_slash,
                      Colors.red,
                      false),
                  onTap: () {
                    _openUrlPage(ApiUrl().privacyDomain());
                  },
                ),
                GestureDetector(
                  child: _settingsCard(
                      "Logout",
                      "log out of account",
                      CupertinoIcons.chevron_left_slash_chevron_right,
                      Colors.pink,
                      false),
                  onTap: () {
                    _showConfirmation();
                  },
                )
              ],
            ),
          ],
        )));
  }

  Future<void> _contactSupport() async {
    AppUtil().sendEmail("KAP Feedback", "Please ...");
  }

  Future<void> _shareToSocialMedia() async {
    await Share.share(
        StringResource.shareMessageBody(widget.user.firstName, ""),
        subject: StringResource.shareMessageTitle(widget.user.firstName));
  }

  void _navigateToModulesScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyModulesPage()));
  }

  void _navigateToRedemptionsScreen(BuildContext buildContext) {
    _showWithdrawalAction(buildContext);
  }

  //MARK: start withdrawal action
  _showWithdrawalAction(BuildContext buildContext) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0), topRight: Radius.circular(0.0)),
        ),
        context: context,
        builder: (context) {
          return SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 16),
                child: Text(
                  "WITHDRAW MY POINT",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                ),
              ),
              const Divider(
                height: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 0),
                child: Text(
                  "Provide information below and proceed to withdraw points.",
                  textAlign: TextAlign.start,
                  style: AppTextStyle.normalTextStyle(Colors.black, 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 0),
                child: TextField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                  textAlign: TextAlign.left,
                  controller: _pointsController,
                  decoration: AppInputDecorator.boxDecorate("Points to redeem"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 0),
                child: TextField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                  textAlign: TextAlign.left,
                  controller: _phoneNumberController,
                  decoration:
                      AppInputDecorator.boxDecorate("Enter phone number"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: DropdownButton<String>(
                  value: _network,
                  isExpanded: true,
                  hint: const Text('Choose Network'),
                  items: _networkTypes.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _network = value.toString();
                    });
                  },
                ),
              ),
              Container(
                height: 44,
                width: MediaQuery.of(context).size.width - 32,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _redeemPoint(buildContext);
                  },
                  child: Text(
                    "REDEEM POINT",
                    style: AppTextStyle.normalTextStyle(Colors.white, 14),
                  ),
                  style: AppButtonStyle.squaredSmallColoredEdgeButton,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ));
        });
  }

  void _navigateEventCheckInScreen() {
    Navigator.of(context)
        .push(
            MaterialPageRoute(builder: (context) => const EventsCheckInPage()))
        .then((value) {});
  }

  void _navigateToLeadersScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LeaderBoardPage()));
  }

  void _showConfirmation() {
    AppAlertDialog().showAlertDialog(
        context, "Logout", "Proceed to logout of KAP", () async {
      await DBOperations().deleteUser(widget.user.id);
      _navigateHome();
    });
  }

  void _navigateHome() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const TutorialPage(),
      ),
      (route) => false,
    );
  }

  void _refreshPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const HomeTabScreen(),
      ),
      (route) => false,
    );
  }

  //MARK: take user to url
  void _openUrlPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _settingsCard(String title, String subtitle, IconData icons,
      Color color, bool hideAction) {
    return Container(
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2.0),
          child: Card(
            elevation: 0.5,
            color: Colors.white,
            child: ListTile(
                title: Text(
                  title,
                  style: AppTextStyle.normalTextStyle(Colors.black, 16),
                ),
                subtitle: Text(
                  subtitle,
                  style: AppTextStyle.normalTextStyle(Colors.grey, 14),
                ),
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    color: color,
                    height: 30,
                    width: 30,
                    child: Icon(
                      icons,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                trailing: !hideAction
                    ? const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 16,
                        color: Colors.grey,
                      )
                    : null),
          ),
        ));
  }

  //MARK: check  user in
  void _redeemPoint(BuildContext buildContext) async {
    var number = _phoneNumberController.text.toString().trim();
    var points = _pointsController.text.toString().trim();
    var mobileNetwork = __networkTypeKeys[_networkTypes.indexOf(_network)];

    String title = "KAP Point Redemption";
    if (number.isEmpty || points.isEmpty || mobileNetwork.isEmpty) {
      AppAlertDialog().showAlertDialog(
          context, title, "Provide information and proceed", () {});
      return;
    }
    final progress = ProgressHUD.of(buildContext);
    progress?.show();
    Map<String, String> data = {};
    data.putIfAbsent("point", () => points);
    data.putIfAbsent("phone_number", () => number);
    data.putIfAbsent("mobile_network", () => mobileNetwork);

    ApiService.get(widget.user.token)
        .postData(ApiUrl().redeemPoints(), data)
        .then((value) async {
      var statusCode = value["response_code"].toString();
      if (statusCode == "100") {
        var message = value["message"].toString();
        var userData = ParseApiData().parseUser(value["results"]);
        await DBOperations().updateUser(userData);
        AppAlertDialog().showAlertDialog(context, title, message, () {
          _refreshPage();
        });
      } else {
        var message = value["detail"].toString();
        AppAlertDialog().showAlertDialog(context, title, message, () {});
      }
    }).whenComplete(() {
      progress?.dismiss();
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
