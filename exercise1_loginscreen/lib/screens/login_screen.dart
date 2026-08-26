import 'package:exercise1_loginscreen/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<Map<String, String>> validUsers = [
    {'username': 'admin', 'password': 'admin'},
    {'username': 'user1', 'password': '1234'},
    {'username': 'juan', 'password': 'password'},
    {'username': 'Nahuel', 'password': '123456'},
  ];

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de Inicio'),
      ),
      body: Column(
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
            onPressed: () {
              if (validateLogin() == true) {
                context.pushNamed(
                  HomeScreen.name,
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
            child: const Text('Login'),
          ),
        ],
      ),
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
