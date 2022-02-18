import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

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

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>("auth/secrets.json",
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
