import 'package:exercise1_loginscreen/entities/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() {
    return _createAppTheme(
      themeMode: ThemeMode.dark,
      seedColor: Colors.deepPurple,
    );
  }

  AppTheme _createAppTheme({
    required ThemeMode themeMode,
    required Color seedColor,
  }) {
    return AppTheme(
      themeMode: themeMode,
      seedColor: seedColor,
      themeLight: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      ),
      themeDark: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
    );
  }

  void toggleTheme() {
    ThemeMode newMode;

    if (state.themeMode == ThemeMode.dark) {
      newMode = ThemeMode.light;
    } else {
      newMode = ThemeMode.dark;
    }

    state = state.copyWith(themeMode: newMode);
  }

  void changeSeedColor(Color newSeedColor) {
    state = _createAppTheme(
      themeMode: state.themeMode,
      seedColor: newSeedColor,
    );
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppTheme>(() {
  return ThemeNotifier();
});
