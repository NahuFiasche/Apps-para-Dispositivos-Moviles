import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:exercise1_loginscreen/screens/game_library_screen.dart';
import 'package:exercise1_loginscreen/screens/general_settings_screen.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:exercise1_loginscreen/screens/game_detail_screen.dart';
import 'package:exercise1_loginscreen/screens/user_settings_screen.dart';

import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      name: 'login_screen',
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: 'gamesLibrary_screen',
      path: '/gamesLibrary_screen',
      builder: (context, state) =>
          GamesLibraryScreen(username: state.extra as String),
    ),
    GoRoute(
      name: 'gameDetail_screen',
      path: '/gameDetail_screen',
      builder: (context, state) => GameDetailScreen(game: state.extra as Game),
    ),
    GoRoute(
      name: 'userSettings_screen',
      path: '/userSettings_screen',
      builder: (context, state) => UserSettingsScreen(username: state.extra as String),
    ),
    GoRoute(
      name: '/generalSettings_screen',
      path: '/generalSettings_screen',
      builder: (context, state) => GeneralSettingsScreen(),
    ),
  ],
);
