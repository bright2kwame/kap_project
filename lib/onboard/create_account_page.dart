import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knowledge_access_power/api/api_url.dart';
import 'package:knowledge_access_power/auth/keys.dart';
import 'package:knowledge_access_power/home/home_tab_page.dart';
import 'package:knowledge_access_power/model/user.dart' as UserItem;
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/util/app_bar_widget.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_enum.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:twitter_login/twitter_login.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(ImageResource.onboardOne),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBarWidget.transparentAppBar("ACCOUNT"),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Container(
                    color: Colors.transparent,
                    child: SafeArea(
                        child: ProgressHUD(
                            child: Builder(
                      builder: (context) => _buildMainContent(context),
                    )))))));
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(ImageResource.appLogoPlain),
          height: 80,
          width: 100,
          fit: BoxFit.contain,
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text(
            "To Effectively use KAP, kindly conect with any of your social media accounts",
            textAlign: TextAlign.center,
            style: AppTextStyle.normalTextStyleShadowed(Colors.white, 16),
          ),
        )),
        Container(
          width: 320,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              _initialiseSocialLogin(context, SocialLoginType.GOOGLE);
            },
            child: _signInButton(AppColor.googleColor, "Connect With Google",
                ImageResource.googleIcon),
            style: AppButtonStyle.roundedPlainEdgeButton,
          ),
        ),
        Container(
          width: 320,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              _initialiseSocialLogin(context, SocialLoginType.TWITTER);
            },
            child: _signInButton(AppColor.twitterColor, "Connect With Twitter",
                ImageResource.twitterIcon),
            style: AppButtonStyle.roundedPlainEdgeButton,
          ),
        ),
        Container(
          width: 320,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              _initialiseSocialLogin(context, SocialLoginType.FACEBOOK);
            },
            child: _signInButton(AppColor.facebookColor,
                "Connect With FaceBook", ImageResource.facebookIcon),
            style: AppButtonStyle.roundedPlainEdgeButton,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Text(
              "I agree with the Terms & Conditions",
              style: AppTextStyle.normalTextStyle(Colors.white, 14.0),
            ),
          ),
        )
      ],
    );
  }

  void _launchURL() async {
    if (!await launch(ApiUrl().mainDomain())) throw 'Could not launch';
  }

  void _navigateToNextScreen() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const HomeTabScreen(),
      ),
      (route) => false,
    );
  }

  Widget _signInButton(Color color, String title, String icon) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          height: 24.0,
          width: 24.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                scale: 1.0,
                image: AssetImage(
                  icon,
                ),
                fit: BoxFit.cover),
            shape: BoxShape.circle,
          ),
        ),
        Text(
          title,
          style: AppTextStyle.normalTextStyle(color, 16.0),
        ),
      ],
    ));
  }

  Future<void> _initialiseSocialLogin(
      BuildContext context, SocialLoginType type) async {
    final progress = ProgressHUD.of(context);
    progress?.show();

    UserCredential? userCredential;
    switch (type) {
      case SocialLoginType.FACEBOOK:
        userCredential = await signInWithFacebook();
        break;
      case SocialLoginType.TWITTER:
        userCredential = await signInWithTwitter();
        break;
      case SocialLoginType.GOOGLE:
        userCredential = await signInWithGoogle();
        break;
      default:
    }

    if (userCredential != null) {
      User? user = await _getUser(userCredential);
      print(user?.email);
    } else {
      print("No credentials");
    }
    progress?.dismiss();
  }

//MARK: sign in with google
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth == null) {
      return null;
    }
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

//MARK:  facebook login
  Future<UserCredential?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.accessToken == null) {
      return null;
    }
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

//MARK: twitter login
  Future<UserCredential?> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final twitterLogin1 = TwitterLogin(
        apiKey: 'qQWAbMDseZ8QLevpC0QsokHZH',
        apiSecretKey: 'bnIvyfXCsJDl1NKTnb4tTDdNOrtNVlkiVVfuVUpSn33cvloytk',
        redirectURI:
            "https://knowledge-access-and-power.firebaseapp.com/__/auth/handler");

    var secretLoader = await SecretLoader().load();
    final twitterLogin = TwitterLogin(
        apiKey: secretLoader.twitterApiKey,
        apiSecretKey: secretLoader.twitterApiSecret,
        redirectURI: secretLoader.twitterRedirectUrl);

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();
    if (authResult.authToken == null) {
      return null;
    }
    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );
    return await FirebaseAuth.instance
        .signInWithCredential(twitterAuthCredential);
  }

//MARK: get the user object
  Future<User?> _getUser(UserCredential credential) async {
    User? user;
    try {
      user = credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        // handle the error here
      }
    } catch (e) {
      // handle the error here
    }
    return user;
  }
}
