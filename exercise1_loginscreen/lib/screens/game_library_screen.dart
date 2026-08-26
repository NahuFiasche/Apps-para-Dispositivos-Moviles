import 'package:flutter/material.dart';

class GamesLibraryScreen extends StatelessWidget {
  static const String name = 'gamesLibrary_screen';
  final String username;

  const GamesLibraryScreen({super.key, this.username = 'Undefined username'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Juegos Disponibles'),
      ),
      body: GameLibraryBodyBuilder(username: username),
    );
  }
}

class GameLibraryBodyBuilder extends StatelessWidget {
  const GameLibraryBodyBuilder({
    super.key,
    required this.username,
  });

  final String username;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Bienvenido, $username'),
    );
  }
}
