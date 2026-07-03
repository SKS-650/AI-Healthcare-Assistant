import '../themes/dark_theme.dart';
import '../themes/light_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => LightTheme.data;
  static ThemeData get dark => DarkTheme.data;
}
