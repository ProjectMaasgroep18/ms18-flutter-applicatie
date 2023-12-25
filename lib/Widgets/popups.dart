import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ms18_applicatie/config.dart';

class PopupAndLoading {
  static bool isLoading = false;
  static bool otherPopup = false;

//set the base style for the loading popups
  static void baseStyle() {
    EasyLoading.removeAllCallbacks();
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..progressColor = Colors.white
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskType = EasyLoadingMaskType.black
      ..indicatorWidget = const CircularProgressIndicator(
        color: Colors.white,
      )
      ..dismissOnTap = false;
  }

//show and set the loading popup
  static void showLoading() {
    isLoading = true;
    if (!otherPopup) {
      EasyLoading.removeAllCallbacks();
      EasyLoading.instance
        ..backgroundColor = mainColor
        ..dismissOnTap = false;
      EasyLoading.show(
        status: 'Laden...',
      );
    }
  }

//end the loading popup if a certain codition
  static void endLoading() {
    isLoading = false;
    if (!otherPopup) {
      EasyLoading.dismiss();
    }
  }

//show and set the error popup
  static void showError(String message) {
    EasyLoading.removeAllCallbacks();
    EasyLoading.instance
      ..backgroundColor = dangerColor
      ..dismissOnTap = true;
    EasyLoading.showError(
      message,
    );
    addCalback();
  }

//show and set the success popup
  static void showSuccess(String message) {
    EasyLoading.removeAllCallbacks();
    EasyLoading.instance
      ..backgroundColor = successColor
      ..dismissOnTap = true;
    EasyLoading.showSuccess(
      message,
    );
    addCalback();
  }

//add calback to know if pupup is showing
  static void addCalback() {
    otherPopup = true;
    EasyLoading.addStatusCallback((status) {
      if (status.index == 1) {
        otherPopup = false;
        if (isLoading) {
          showLoading();
        }
      }
    });
  }
}
