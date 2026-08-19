import 'package:exercise1_loginscreen/screens/home_screen.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      name: 'login_screen',
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'home_screen',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
