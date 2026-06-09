import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static double hPad(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 768)  return 24;
    if (w < 1100) return 48;
    return 80;
  }

  static double maxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > 1280 ? 1200 : w - hPad(context) * 2;
  }

  static double clampFont(BuildContext context, double min, double max) {
    final w = MediaQuery.of(context).size.width;
    return (w / 1440 * max).clamp(min, max);
  }
}
