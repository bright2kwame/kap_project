import 'package:share/share.dart';

class AppUtil {
  //MARK: share message to social message
  Future<void> shareToSocialMedia(String title, String message) async {
    await Share.share(title, subject: message);
  }
}
