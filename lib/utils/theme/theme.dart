import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/text_theme.dart';


class YAppTheme {
  YAppTheme._();

  // L I G H T   T H E M E
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: YColors.white,
    textTheme: YTextTheme.lightTextTheme,
    appBarTheme: YAppBarTheme.lightAppBarTheme,
  );
}