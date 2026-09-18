import 'package:exercise1_loginscreen/entities/app_theme.dart';
import 'package:exercise1_loginscreen/providers/theme_provider.dart';
import 'package:exercise1_loginscreen/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme mainAppTheme = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: mainAppTheme.themeLight,
      darkTheme: mainAppTheme.themeDark,
      themeMode: mainAppTheme.themeMode,
      
    );
  }
}
