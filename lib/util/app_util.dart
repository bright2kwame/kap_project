import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:share/share.dart';

import '../home/home_tab_page.dart';

class AppUtil {
  //MARK: share message to social message
  Future<void> shareToSocialMedia(String title, String message) async {
    await Share.share(title, subject: message);
  }

  void refreshPage(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const HomeTabScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> sendEmail(String subject, String body) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: ['kapiniitiative@gmail.com'],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }
}
