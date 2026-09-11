import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:exercise1_loginscreen/screens/game_add_screen.dart';
import 'package:exercise1_loginscreen/screens/game_edit_screen.dart';
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
      builder: (context, state) => GamesLibraryScreen(
        username: (state.extra as String?) ?? 'Undefined username',
      ),
    ),
    GoRoute(
      name: 'gameDetail_screen',
      path: '/gameDetail_screen',
      builder: (context, state) => GameDetailScreen(gameId: state.extra as String),
    ),
    GoRoute(
      name: 'userSettings_screen',
      path: '/userSettings_screen',
      builder: (context, state) =>
          UserSettingsScreen(username: state.extra as String),
    ),
    GoRoute(
      name: '/generalSettings_screen',
      path: '/generalSettings_screen',
      builder: (context, state) => GeneralSettingsScreen(),
    ),
    GoRoute(
      name: GameAddScreen.name,
      path: '/addGame_screen',
      builder: (context, state) => GameAddScreen(),
    ),
    GoRoute(
      name: GameEditScreen.name,
      path: '/editGame_screen',
      builder: (context, state) => GameEditScreen(game: state.extra as Game),
    ),
  ],
);
