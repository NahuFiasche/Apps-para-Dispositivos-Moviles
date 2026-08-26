import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  final String username;

  const HomeScreen({super.key, this.username = 'Undefined username'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
      ),
      body: Center(
        child: Text('Bienvenido, $username'),
      ),
    );
  }
}
