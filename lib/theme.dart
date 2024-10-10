import 'package:flutter/material.dart';

class FontSizes {
  static const extraSmall = 14.0;
  static const small = 16.0;
  static const standart = 18.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
  static const doubleExtraLarge = 26.0;
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xffffffff),
    primary: Color(0xff3369FF),
    secondary: Color(0xffffffff),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xffffffff),
    ),
    bodySmall: TextStyle(
      color: Color(0xff000000),
    ),
    titleLarge: TextStyle(
      color: Color(0xff000000),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xff000000),
    primary: Color(0xff3369FF),
    secondary: Color(0xffffffff),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xffffffff),
    ),
    bodySmall: TextStyle(
      color: Color(0xff000000),
    ),
    titleLarge: TextStyle(
      color: Color(0xffffffff),
    ),
  ),
);
