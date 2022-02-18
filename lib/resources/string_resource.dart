import 'package:knowledge_access_power/api/api_url.dart';

class StringResource {
  static get dialogTitle => "KAP Error";
  static get successDialogTitle => "Knowledge Access Power";

  static shareMessageBody(String firstName, String code) {
    return "$firstName is inviting you to KAP. Download now on ${ApiUrl().mainDomain()} and get rewarded.";
  }

  static shareMessageTitle(String firstName) {
    return "KAP Invitation from $firstName";
  }
}
