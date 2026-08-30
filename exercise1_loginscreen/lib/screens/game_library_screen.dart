import 'package:exercise1_loginscreen/core/data/games_datasource.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:exercise1_loginscreen/screens/game_detail_screen.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GamesLibraryScreen extends StatelessWidget {
  static const String name = 'gamesLibrary_screen';
  final String username;
  final List<Game> gamesList = gamesDatasource;

  GamesLibraryScreen({super.key, this.username = 'Undefined username'});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Catálogo de Juegos',
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              context.goNamed(LoginScreen.name);
            },
          ),
        ],
      ),
      body: GameLibraryBodyBuilder(username: username, gamesList: gamesList),
    );
  }
}

class GameLibraryBodyBuilder extends StatelessWidget {
  final String username;
  final List<Game> gamesList;

  const GameLibraryBodyBuilder({
    super.key,
    required this.username,
    required this.gamesList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gamesList.length,
      itemBuilder: (BuildContext context, int index) {
        final game = gamesList[index];
        return GamesListBuilder(game: game);
      },
    );
  }
}

class GamesListBuilder extends StatelessWidget {
  final Game game;

  const new({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      clipBehavior: Clip.antiAlias,

      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 70,
          child: game.gameCover != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(game.gameCover!),
                )
              : const Icon(Icons.movie),
        ),
        title: Text(
          game.title,
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          game.developer,
          style: textTheme.titleSmall,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),

        onTap: () {
          context.pushNamed(GameDetailScreen.name, extra: game);
        },
      ),
    );
  }
}
