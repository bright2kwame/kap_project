import 'package:flutter/material.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_enum.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';
import 'package:knowledge_access_power/model/module_reproductive_kit.dart';

import '../util/app_input_decorator.dart';

class BottomSheetPage {
  var bottomRadiusCorner = 0.0;

  showLoginTypeAction(BuildContext context, Function callback) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bottomRadiusCorner),
              topRight: Radius.circular(bottomRadiusCorner)),
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
                  "Create KAP Account",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                ),
              ),
              const Divider(
                height: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 16, left: 16, bottom: 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.account_box,
                    size: 32,
                  ),
                  subtitle: const Text("Have account with KAP ? Login Instead"),
                  title: const Text("Login"),
                  onTap: () {
                    Navigator.of(context).pop();
                    callback(AccessType.LOGIN.name);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 16, left: 16, bottom: 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.email,
                    size: 32,
                  ),
                  subtitle: const Text("New to KAP? create new account"),
                  title: const Text("Register"),
                  onTap: () {
                    Navigator.of(context).pop();
                    callback(AccessType.REGISTER.name);
                  },
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ));
        });
  }

  void showLoginAction(BuildContext context, Function actionCompleted) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
                child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 16),
                          child: Text(
                            "KAP Login",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: Text(
                            "Provide information below and proceed to login",
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 12.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: emailController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter email address"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: passwordController,
                            decoration:
                                AppInputDecorator.boxDecorate("Enter password"),
                          ),
                        ),
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              String info = emailController.text.trim() +
                                  "±" +
                                  passwordController.text.trim();
                              actionCompleted(info);
                            },
                            child: Text(
                              "LOGIN",
                              style: AppTextStyle.normalTextStyle(
                                  Colors.white, 14),
                            ),
                            style: AppButtonStyle.squaredSmallColoredEdgeButton,
                          ),
                        ),
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              String info = emailController.text.trim() +
                                  "±" +
                                  AccessType.RESET_PASSWORD.name;
                              actionCompleted(info);
                            },
                            child: Text(
                              "Forgot Password",
                              style:
                                  AppTextStyle.normalTextStyle(Colors.blue, 14),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    )));
          });
        });
  }

  void showResetAction(
      BuildContext context, String email, Function actionCompleted) {
    TextEditingController uniqueController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmController = TextEditingController();
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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
                child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 16),
                          child: Text(
                            "Password Reset",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: Text(
                            "Enter the unique code sent to email:" + email,
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 12.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: uniqueController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter unique code"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: confirmController,
                            decoration:
                                AppInputDecorator.boxDecorate("Enter password"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: confirmController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter password again"),
                          ),
                        ),
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              String info = uniqueController.text.trim() +
                                  "±" +
                                  passwordController.text.trim() +
                                  "±" +
                                  confirmController.text.trim();
                              actionCompleted(info);
                            },
                            child: Text(
                              "RESET PASSWORD",
                              style: AppTextStyle.normalTextStyle(
                                  Colors.white, 14),
                            ),
                            style: AppButtonStyle.squaredSmallColoredEdgeButton,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    )));
          });
        });
  }

  void showRegisterAction(BuildContext context, Function actionCompleted) {
    TextEditingController firstController = TextEditingController();
    TextEditingController lastController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmController = TextEditingController();
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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
                child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 16),
                          child: Text(
                            "Account Setup",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                          ),
                        ),
                        const Divider(
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: Text(
                            "Provide information below and proceed to create account",
                            textAlign: TextAlign.start,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 12.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: firstController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter first name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: lastController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter last name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: emailController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter email address"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: passwordController,
                            decoration:
                                AppInputDecorator.boxDecorate("Enter password"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16, bottom: 0),
                          child: TextField(
                            maxLines: 1,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: AppTextStyle.normalTextStyle(
                                Colors.black, 14.0),
                            textAlign: TextAlign.left,
                            controller: confirmController,
                            decoration: AppInputDecorator.boxDecorate(
                                "Enter password again"),
                          ),
                        ),
                        Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              String info = firstController.text.trim() +
                                  "±" +
                                  lastController.text.trim() +
                                  "±" +
                                  emailController.text.trim() +
                                  "±" +
                                  passwordController.text.trim() +
                                  "±" +
                                  confirmController.text.trim();
                              actionCompleted(info);
                            },
                            child: Text(
                              "CREATE ACCOUNT",
                              style: AppTextStyle.normalTextStyle(
                                  Colors.white, 14),
                            ),
                            style: AppButtonStyle.squaredSmallColoredEdgeButton,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    )));
          });
        });
  }

//MARK: start main options
  showModuleExamsResult(BuildContext context, String score, String message,
      Function(String result) callback) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bottomRadiusCorner),
              topRight: Radius.circular(bottomRadiusCorner)),
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
                  "QUIZ RESULT",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                ),
              ),
              const Divider(
                height: 0.5,
              ),
              Image.asset(
                double.parse(score) > 50
                    ? ImageResource.smileIcon
                    : ImageResource.sadIcon,
                width: 100,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 0),
                child: Text(
                  "$score%",
                  textAlign: TextAlign.start,
                  style: AppTextStyle.semiBoldTextStyle(Colors.black, 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 0),
                child: Text(
                  message,
                  textAlign: TextAlign.start,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
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
                    callback("");
                  },
                  child: Text(
                    "OK, THANK YOU !",
                    style: AppTextStyle.normalTextStyle(Colors.white, 14),
                  ),
                  style: AppButtonStyle.squaredSmallColoredEdgeButton,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        callback(AnswerResponseType.RETRY.name);
                      },
                      child: Text(
                        "Retry Quiz",
                        style: AppTextStyle.normalTextStyle(
                            AppColor.primaryColor, 14),
                      )),
                  const SizedBox(
                    width: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        callback(AnswerResponseType.MARKING_SCHEME.name);
                      },
                      child: Text(
                        "Marking Scheme",
                        style: AppTextStyle.normalTextStyle(
                            AppColor.primaryColor, 14),
                      ))
                ],
              )
            ],
          ));
        });
  }

  showEventAction(
      BuildContext context, ModuleEvent moduleEvent, Function callback) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bottomRadiusCorner),
              topRight: Radius.circular(bottomRadiusCorner)),
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
                  moduleEvent.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                ),
              ),
              const Divider(
                height: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 16, left: 16, bottom: 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.directions,
                    size: 32,
                  ),
                  subtitle: const Text("get map direction to event location"),
                  title: const Text("Get Direction"),
                  onTap: () {
                    Navigator.of(context).pop();
                    callback(FeedActionType.EVENT_DIRECTION.name);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 16, left: 16, bottom: 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.event,
                    size: 32,
                  ),
                  subtitle:
                      const Text("scan the QR at the premise to check in"),
                  title: const Text("Check In to this event"),
                  onTap: () {
                    Navigator.of(context).pop();
                    callback(FeedActionType.EVENT_SCAN.name);
                  },
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ));
        });
  }

  showBuyingAction(BuildContext context,
      ReproductiveKitModule reproductiveKitModule, Function callback) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bottomRadiusCorner),
              topRight: Radius.circular(bottomRadiusCorner)),
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
                  reproductiveKitModule.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                ),
              ),
              const Divider(
                height: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 16, left: 16, bottom: 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.credit_card,
                    size: 32,
                  ),
                  subtitle: const Text("buy this item and make payment"),
                  title: const Text("Purchase Item"),
                  onTap: () {
                    Navigator.of(context).pop();
                    callback(FeedActionType.BUY_KIT.name);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 16, left: 16, bottom: 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.directions,
                    size: 32,
                  ),
                  subtitle: const Text("get the direction to shop"),
                  title: const Text("Get direction"),
                  onTap: () {
                    Navigator.of(context).pop();
                    callback(FeedActionType.KIT_SHOP_DIRECTION.name);
                  },
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ));
        });
  }
}
