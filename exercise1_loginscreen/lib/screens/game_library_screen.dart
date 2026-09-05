import 'package:exercise1_loginscreen/core/data/games_datasource.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:exercise1_loginscreen/screens/game_detail_screen.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:exercise1_loginscreen/core/widgets/drawer_menu.dart';
import 'package:exercise1_loginscreen/core/widgets/floating_button.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    // Simula el tiempo que tarda en consultar y traer la lista completa (0.5 segundos)
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _gamesList = gamesDatasource;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Catálogo de Juegos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              context.goNamed(LoginScreen.name);
            },
          ),
        ],
      ),
      drawer: DrawerMenu(
        scaffoldkey: _scaffoldKey,
        username: widget.username,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GameLibrary(
              username: widget.username,
              gamesList: _gamesList,
            ),
      floatingActionButton: FloatingButton(),
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
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: gamesList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: SizedBox(
          width: 48,
          height: 72,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: getGameCover(colorScheme.onSurfaceVariant),
          ),
        ),
        title: Text(
          game.title,
          style: textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          game.developer,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: colorScheme.onSurfaceVariant,
        ),

        onTap: () {
          context.pushNamed(GameDetailScreen.name, extra: game);
        },
      ),
    );
  }

  Widget getGameCover(Color errorColor) {
    if (game.gameCover == null) {
      return Icon(
        Icons.broken_image_rounded,
        size: 32,
        color: errorColor,
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
          return Center(
            child: Icon(
              Icons.broken_image_rounded,
              size: 32,
              color: errorColor,
            ),
          );
        },
      );
    }
  }
}
