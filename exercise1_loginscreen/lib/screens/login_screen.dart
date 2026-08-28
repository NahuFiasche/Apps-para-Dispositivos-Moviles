import 'package:exercise1_loginscreen/screens/game_library_screen.dart';
import 'package:exercise1_loginscreen/core/data/users_credentials.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Juegos'),
        centerTitle: true,
      ),
      body: LoginBodyBuilder(),
    );
  }
}

class LoginBodyBuilder extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginBodyBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(
          flex: 2,
        ),

        Icon(
          Icons.sports_esports_rounded,
          size: 100,
        ),

        const Spacer(
          flex: 1,
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Usuario',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            obscureText: true,
            obscuringCharacter: '*',
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.key),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            onPressed: () {
              if (validateLogin() == true) {
                context.goNamed(
                  GamesLibraryScreen.name,
                  extra: usernameController.text,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuario y/o Contraseña incorrectos'),
                  ),
                );
              }
            },
          ),
        ),

        const Spacer(
          flex: 3,
        ),
      ],
    );
  }

  bool validateLogin() {
    return validUsers.any(
      (user) =>
          user['username'] == usernameController.text &&
          user['password'] == passwordController.text,
    );
  }
}
