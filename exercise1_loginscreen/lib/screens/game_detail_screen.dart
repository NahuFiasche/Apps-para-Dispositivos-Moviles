import 'package:flutter/material.dart';
import 'package:exercise1_loginscreen/entities/games.dart';

class GameDetailScreen extends StatelessWidget {
  static const String name = 'gameDetail_screen';
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        centerTitle: true,
        titleTextStyle: textTheme.headlineMedium,
      ),
      body: GameDetailBodyBuilder(textTheme: textTheme, game: game),
    );
  }
}

class GameDetailBodyBuilder extends StatelessWidget {
  final TextTheme textTheme;
  final Game game;

  const new({super.key, required this.textTheme, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 600,
          child: ListView.builder(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    game.gameImage1,
                    width: 400, // Ancho de cada captura
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            game.developer,
            style: textTheme.titleMedium,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            game.releaseYear,
            style: textTheme.titleMedium,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            game.plattform,
            style: textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
