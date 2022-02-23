import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

//create a keys folder and add a file called secrets.json containing the keys
class Secret {
  final String twitterApiKey;
  final String twitterApiSecret;
  final String twitterRedirectUrl;

  Secret(
      {required this.twitterApiKey,
      required this.twitterApiSecret,
      required this.twitterRedirectUrl});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return Secret(
        twitterApiKey: jsonMap["twitter_api_key"],
        twitterApiSecret: jsonMap["twitter_api_secret"],
        twitterRedirectUrl: jsonMap["twitter_redirect_url"]);
  }
}

class SecretLoader {
  SecretLoader();

  Future<Secret> load() async {
    String path = "assets/secrets.json";
    final jsondata = await rootBundle.loadString(path);
    return Secret.fromJson(json.decode(jsondata));
  }
}
