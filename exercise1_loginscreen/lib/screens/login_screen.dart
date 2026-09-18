import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:exercise1_loginscreen/screens/game_library_screen.dart';
import 'package:exercise1_loginscreen/screens/user_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoginBodyBuilder(),
      ),
    );
  }
}

class LoginBodyBuilder extends ConsumerStatefulWidget {
  const LoginBodyBuilder({super.key});

  @override
  ConsumerState<LoginBodyBuilder> createState() => _LoginBodyBuilderState();
}

class _LoginBodyBuilderState extends ConsumerState<LoginBodyBuilder> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 48),

            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_esports_rounded,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Catálogo de Juegos',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Inicia sesión para continuar',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            TextField(
              controller: usernameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Usuario',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              obscuringCharacter: '*',
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.key_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                //TODO: Implementar nuevo Widget ForgotPasswordDialog
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _login(context),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No tienes una cuenta?',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed(UserAddScreen.name);
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (ref
            .read(usersProvider.notifier)
            .validateLogin(
              username,
              password,
            ) ==
        true) {
      context.goNamed(
        GamesLibraryScreen.name,
        extra: usernameController.text,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          width: 320,
          content: const Text('Usuario y/o contraseña incorrectos'),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        ),
      );
    }
  }
}
