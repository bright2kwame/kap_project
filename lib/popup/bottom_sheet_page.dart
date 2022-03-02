import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_enum.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class BottomSheetPage {
  var bottomRadiusCorner = 0.0;
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
}
