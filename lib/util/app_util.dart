import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:share/share.dart';

class AppUtil {
  //MARK: share message to social message
  Future<void> shareToSocialMedia(String title, String message) async {
    await Share.share(title, subject: message);
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
