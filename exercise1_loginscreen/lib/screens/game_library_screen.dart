import 'package:exercise1_loginscreen/core/data/games_datasource.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:exercise1_loginscreen/screens/game_detail_screen.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GamesLibraryScreen extends StatefulWidget {
  static const String name = 'gamesLibrary_screen';
  final String username;

  const GamesLibraryScreen({super.key, this.username = 'Undefined username'});

  @override
  State<GamesLibraryScreen> createState() => _GamesLibraryScreenState();
}

class _GamesLibraryScreenState extends State<GamesLibraryScreen> {
  bool _isLoading = true;
  List<Game> _gamesList = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    // Simula el tiempo que tarda en consultar y traer la lista completa (2 segundos)
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _gamesList = gamesDatasource;
      _isLoading = false;
    });
  }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GameLibrary(
              username: widget.username,
              gamesList: _gamesList,
            ),
    );
  }
}

class GameLibrary extends StatelessWidget {
  final String username;
  final List<Game> gamesList;

  const GameLibrary({
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
        return GameItem(game: game);
      },
    );
  }
}

class GameItem extends StatelessWidget {
  final Game game;

  const GameItem({
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: getGameCover(),
          ),
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

  Widget getGameCover() {
    if (game.gameCover == null) {
      return Icon(
        Icons.broken_image_rounded,
        size: 32,
        color: Colors.grey,
      );
    } else {
      return Image.network(
        game.gameCover!,
        fit: BoxFit.cover,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },

        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image_rounded,
              size: 32,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
}
