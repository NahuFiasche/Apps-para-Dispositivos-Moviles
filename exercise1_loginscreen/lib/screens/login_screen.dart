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
        title: const Text('Pantalla de Inicio'),
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
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Usuario',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            obscureText: true,
            obscuringCharacter: '*',
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: 'Contraseña',
            ),
          ),
        ),
        ElevatedButton(
          child: const Text('Login'),
          onPressed: () {
            if (validateLogin() == true) {
              context.pushNamed(
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
