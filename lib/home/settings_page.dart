import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/model/db_operations.dart';
import 'package:knowledge_access_power/model/user.dart';
import 'package:knowledge_access_power/onboard/tutorial_page.dart';
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/resources/string_resource.dart';
import 'package:knowledge_access_power/popup/app_alert_dialog.dart';
import 'package:knowledge_access_power/sub_module/my_modules_page.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserItem user = new UserItem();

  @override
  void initState() {
    _updateUser();
    super.initState();
  }

  void _updateUser() {
    DBOperations().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColor.bgColor,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 270,
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
                        child: GestureDetector(
                            onTap: () {
                              _navigateToEditProfileScreen();
                            },
                            child: user.avatar.isEmpty
                                ? Image.asset(
                                    ImageResource.appLogo,
                                    fit: BoxFit.scaleDown,
                                    width: 100,
                                    height: 100,
                                  )
                                : Image(
                                    image:
                                        CachedNetworkImageProvider(user.avatar),
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                  )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      user.fullName,
                      style: AppTextStyle.semiBoldTextStyle(Colors.black, 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      user.email,
                      style: AppTextStyle.normalTextStyle(Colors.black, 12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      "username  • " + user.username,
                      style: AppTextStyle.normalTextStyle(Colors.black, 12.0),
                    ),
                  ),
                  Row(
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
                          "${user.points} POINTS",
                          style: AppTextStyle.boldTextStyle(
                              AppColor.primaryDarkColor, 12.0),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: AppButtonStyle.roundedColoredEdgeButton,
                    child: Container(
                        width: 150,
                        height: 20,
                        color: AppColor.primaryColor,
                        child: Text(
                          "Withdraw Points",
                          textAlign: TextAlign.center,
                          style:
                              AppTextStyle.normalTextStyle(Colors.white, 16.0),
                        )),
                    onPressed: () {
                      shareToSocialMedia();
                    },
                  )
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _navigateToEditProfileScreen();
                  },
                  child: _settingsCard("My Profile", "change profile settings",
                      CupertinoIcons.profile_circled, Colors.amber, false),
                ),
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
                    _navigateToRedemptionsScreen();
                  },
                ),
                GestureDetector(
                  child: _settingsCard(
                      "Leader Board",
                      "rank of all app learners",
                      CupertinoIcons.doc_on_doc_fill,
                      Colors.cyan,
                      false),
                  onTap: () {},
                ),
                GestureDetector(
                  child: _settingsCard("Help &  Support", "get help for somtin",
                      CupertinoIcons.phone_circle, Colors.blue, false),
                  onTap: () {
                    _contactSupport();
                  },
                ),
                GestureDetector(
                  child: _settingsCard(
                      "Privacy & Terms",
                      "somtin somtin privacy",
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
    // ManageSupport().sendEmail("KAP Feedback", "Please ...");
  }

  Future<void> shareToSocialMedia() async {
    await Share.share(StringResource.shareMessageBody(user.firstName, ""),
        subject: StringResource.shareMessageTitle(user.firstName));
  }

  void _navigateToModulesScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyModulesPage()));
  }

  void _navigateToRedemptionsScreen() {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => RedeemingSettingsScreen(this.user)));
  }

  void _navigateToEditProfileScreen() {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => EditProfileScreen()))
    //     .then((value) {
    //   this._updateUser();
    // });
  }

  void _showConfirmation() {
    AppAlertDialog().showAlertDialog(
        context, "Logout", "Proceed to logout of KAP", () async {
      await DBOperations().deleteUser(user.id);
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
}
