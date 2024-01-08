import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

bool isMobile(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth <= mobileWidth;
}

double getResponsifeWidth(BuildContext context,
    {bool isFullWidth = false, double width = desktopButtonWidth}) {
  if (isFullWidth) return double.infinity;

  return isMobile(context) ? double.infinity : width;
}

T responsifeCondition<T>(BuildContext context, T mobileValue, T desktopValue) {
  if (isMobile(context)) return mobileValue;
  return desktopValue;
}
