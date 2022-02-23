import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/model/module_stage.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class BottomSheetPage {
  var bottomRadiusCorner = 0.0;
//MARK: start main options
  showModuleStag(
      BuildContext context, ModuleStage moduleStage, Function callback) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, right: 16, left: 16, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        moduleStage.title,
                        textAlign: TextAlign.start,
                        style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.clear_circled_solid,
                          color: AppColor.primaryColor,
                          size: 24,
                        ))
                  ],
                ),
              ),
              const Divider(
                height: 0.5,
              ),
              moduleStage.image.isEmpty
                  ? Container()
                  : Image(
                      image: CachedNetworkImageProvider(moduleStage.image),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, left: 16, bottom: 0),
                child: Text(
                  moduleStage.content,
                  textAlign: TextAlign.start,
                  style: AppTextStyle.normalTextStyle(Colors.black, 14.0),
                ),
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        callback();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Mark  As Completed",
                        style: AppTextStyle.normalTextStyle(Colors.white, 10),
                      ),
                      style: AppButtonStyle.squaredSmallColoredEdgeButton,
                    ),
                  )
                ],
              ),
            ],
          ));
        });
  }
}
