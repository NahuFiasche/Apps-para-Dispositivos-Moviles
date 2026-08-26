import 'package:flutter/material.dart';

class GameDetailScreen extends StatelessWidget {
  static const String name = 'gameDetail_screen';

  const GameDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
      ),
      body: Placeholder(),
    );
  }
}
