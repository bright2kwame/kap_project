import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class AppInputDecorator {
  static InputDecoration decorate(String placeHolder) {
    return InputDecoration(
      hintText: placeHolder,
      counterText: "",
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      hintStyle: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
    );
  }

  static InputDecoration boxDecorate(String placeHolder) {
    return InputDecoration(
      counterText: "",
      fillColor: Colors.white,
      hintText: placeHolder,
      hintStyle: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
      labelStyle: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      labelText: placeHolder,
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
          borderSide: BorderSide(color: Colors.grey, width: 0.5)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
    );
  }

  static InputDecoration boxDecorateSuffix(
      String placeHolder, Function callback) {
    return InputDecoration(
      counterText: "",
      fillColor: Colors.white,
      hintText: placeHolder,
      hintStyle: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
      labelStyle: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      labelText: placeHolder,
      suffixIcon: IconButton(
        icon: Icon(
          Icons.add_task_rounded,
          color: AppColor.primaryColor,
          size: 16,
        ),
        onPressed: () {
          callback();
        },
      ),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
          borderSide: BorderSide(color: Colors.grey, width: 0.5)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
    );
  }

  static InputDecoration boxDecorateCode(String placeHolder) {
    return InputDecoration(
      counterText: "",
      fillColor: Colors.white,
      hintText: placeHolder,
      labelStyle: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
      hintStyle: AppTextStyle.normalTextStyle(Colors.grey, 14.0),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      labelText: placeHolder,
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
          borderSide: BorderSide(color: Colors.grey, width: 0.5)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
    );
  }
}
