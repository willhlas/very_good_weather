import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) => 
  max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
  tintValue(color.red, factor),
  tintValue(color.green, factor),
  tintValue(color.blue, factor), 1,
);

int shadeValue(int value, double factor) => 
  max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
  shadeValue(color.red, factor),
  shadeValue(color.green, factor),
  shadeValue(color.blue, factor), 1,
);

class AppThemeData {
  ThemeData get materialTheme {
    return ThemeData(
      primarySwatch: generateMaterialColor(const Color(0xFF01687D)),
      textTheme: GoogleFonts.nunitoTextTheme(
        const TextTheme(
          headline2: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 64,
          ),
          headline5: TextStyle(fontWeight: FontWeight.bold),
          headline6: TextStyle(fontWeight: FontWeight.bold),
          subtitle1: TextStyle(fontWeight: FontWeight.bold),
        ),
      ).apply(
        bodyColor: const Color(0xFF00272f),
        displayColor: const Color(0xFF00272f),
      ),
      splashFactory: InkRipple.splashFactory,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: const Color(0xFFE6F6F9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE6F6F9),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 70,
        elevation: 0,
        titleSpacing: 2,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }
}
