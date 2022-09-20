import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class AppAlertDialog {
//MARK: present the dialog
  showAlertDialog(
      BuildContext context, String title, String message, Function callback) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: AppTextStyle.boldTextStyle(Colors.black, 16.0),
                  ),
                ],
              ),
              content: Text(
                message.replaceFirst("Exception: ", ""),
                style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(
                    "CANCEL",
                    style: AppTextStyle.normalTextStyle(
                        CupertinoColors.systemRed, 14.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    "OK",
                    style: AppTextStyle.boldTextStyle(
                        CupertinoColors.activeBlue, 14.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback();
                  },
                ),
              ],
            ));
  }

  //MARK: present the dialog
  showIputAlertDialog(BuildContext context, String title, Function callback) {
    TextEditingController _firstController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: AppTextStyle.boldTextStyle(Colors.black, 16.0),
                  ),
                ],
              ),
              content: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 8),
                      child: Text(
                        "enter code in the field provided below",
                        style: AppTextStyle.normalTextStyle(Colors.black, 14),
                      ),
                    ),
                    CupertinoTextField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      style: AppTextStyle.normalTextStyle(Colors.black, 16.0),
                      textAlign: TextAlign.start,
                      controller: _firstController,
                      placeholder: "Enter code",
                      autofocus: false,
                      obscureText: false,
                      autocorrect: false,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("DONE"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback(_firstController.text.trim());
                  },
                ),
              ],
            ));
  }

  //MARK: present the dialog for chnaging username
  showUsernameAlertDialog(
      BuildContext context, String title, Function callback) {
    TextEditingController _firstController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: AppTextStyle.boldTextStyle(Colors.black, 16.0),
                  ),
                ],
              ),
              content: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 8),
                      child: Text(
                        "Enter username in the field provided below",
                        style: AppTextStyle.normalTextStyle(Colors.black, 14),
                      ),
                    ),
                    CupertinoTextField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      style: AppTextStyle.normalTextStyle(Colors.black, 16.0),
                      textAlign: TextAlign.start,
                      controller: _firstController,
                      placeholder: "Enter username",
                      autofocus: false,
                      obscureText: false,
                      autocorrect: false,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("DONE"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback(_firstController.text.trim());
                  },
                ),
              ],
            ));
  }
}
