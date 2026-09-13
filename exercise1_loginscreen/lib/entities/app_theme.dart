import 'package:flutter/material.dart';

class AppTheme {
  final ThemeMode themeMode;
  final ThemeData themeLight;
  final ThemeData themeDark;
  final Color seedColor;

  AppTheme({
    required this.themeMode,
    required this.themeLight,
    required this.themeDark,
    required this.seedColor,
  });

  AppTheme copyWith({
    ThemeMode? themeMode,
    ThemeData? themeLight,
    ThemeData? themeDark,
    Color? seedColor,
  }) {
    return AppTheme(
      themeMode: themeMode ?? this.themeMode,
      themeLight: themeLight ?? this.themeLight,
      themeDark: themeDark ?? this.themeDark,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}
