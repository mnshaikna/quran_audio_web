import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QAColors {
  QAColors._();

  static const bgDeep   = Color(0xFF060E0D);
  static const bgMid    = Color(0xFF0A1714);
  static const bgCard   = Color(0xFF0F2020);
  static const teal     = Color(0xFF1A4A42);
  static const tealMid  = Color(0xFF2A6B5F);
  static const tealGlow = Color(0xFF3D9B8A);
  static const gold     = Color(0xFFC8974A);
  static const goldLight= Color(0xFFE8B96A);
  static const goldPale = Color(0xFFF5D9A0);
  static const textMain = Color(0xFFE8E2D6);
  static const textMuted= Color(0xFF8A9E9A);
  static const textFaint= Color(0xFF4A6560);
  static const divider  = Color(0xFF1A3832);
}

class QATextStyles {
  QATextStyles._();

  static TextStyle display(double size, {Color? color, FontStyle? style}) =>
    GoogleFonts.cormorantGaramond(
      fontSize: size,
      fontWeight: FontWeight.w900,
      color: color ?? QAColors.textMain,
      fontStyle: style ?? FontStyle.normal,
      height: 1.1,
    );

  static TextStyle cinzel(double size, {Color? color, FontWeight? weight}) =>
    GoogleFonts.cinzel(
      fontSize: size,
      fontWeight: weight ?? FontWeight.w400,
      color: color ?? QAColors.textMain,
      letterSpacing: size > 14 ? 3.0 : 1.5,
    );

  static TextStyle body(double size, {Color? color, double? height}) =>
    GoogleFonts.dmSans(
      fontSize: size,
      fontWeight: FontWeight.w300,
      color: color ?? QAColors.textMuted,
      height: height ?? 1.75,
    );

  static TextStyle label(double size, {Color? color}) =>
    GoogleFonts.dmSans(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? QAColors.textMuted,
      letterSpacing: 1.2,
    );

  static TextStyle arabic(double size, {Color? color}) =>
    TextStyle(
      fontFamily: 'Hafs',
      fontSize: size,
      color: color ?? QAColors.goldPale,
      height: 1.8,
    );
}

class QATheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: QAColors.bgDeep,
    colorScheme: const ColorScheme.dark(
      surface: QAColors.bgDeep,
      primary: QAColors.tealGlow,
      secondary: QAColors.gold,
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thumbVisibility: WidgetStatePropertyAll(false),
    ),
  );
}
