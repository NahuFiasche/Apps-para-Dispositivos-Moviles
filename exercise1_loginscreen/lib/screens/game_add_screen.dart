import 'package:flutter/material.dart';

class GameAddScreen extends StatelessWidget {
  static const String name = 'addGame_screen';

  const GameAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Nuevo Juego')),
      body: Placeholder(),
    );
  }
}
