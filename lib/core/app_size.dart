
import 'package:flutter/material.dart';

class AppSize {
  AppSize._();
  static const double _mobileMax  = 600;
  static const double _tabletMax  = 1024;
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _mobileMax;
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= _mobileMax && w < _tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _tabletMax;
  static ScreenType screenType(BuildContext context) {
    if (isMobile(context))  return ScreenType.mobile;
    if (isTablet(context))  return ScreenType.tablet;
    return ScreenType.desktop;
  }
  static T value<T>(
      BuildContext context, {
        required T mobile,
        required T tablet,
        required T desktop,
      }) {
    if (isMobile(context))  return mobile;
    if (isTablet(context))  return tablet;
    return desktop;
  }
  static double horizontalPadding(BuildContext context) =>
      value(context, mobile: 16, tablet: 32, desktop: 64);
  static double gridColumns(BuildContext context) =>
      value(context, mobile: 1, tablet: 2, desktop: 3);
}
enum ScreenType { mobile, tablet, desktop }