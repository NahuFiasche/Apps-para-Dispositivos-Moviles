import 'package:exercise1_loginscreen/providers/games_provider.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:exercise1_loginscreen/screens/game_detail_screen.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:exercise1_loginscreen/widgets/confirmation_dialog.dart';
import 'package:exercise1_loginscreen/widgets/drawer_menu.dart';
import 'package:exercise1_loginscreen/widgets/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GamesLibraryScreen extends ConsumerWidget {
  static const String name = 'gamesLibrary_screen';
  final String username;

  const GamesLibraryScreen({super.key, this.username = 'Undefined username'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final AsyncValue<List<Game>> gamesList = ref.watch(gamesProvider);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Catálogo de Juegos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return ConfirmationDialog(
                    title: '¿Cerrar Sesión?',
                    message: 'Se cerrará la sesión de $username',
                    actionButtonText: 'Cerrar',
                    onDelete: () {
                      context.goNamed(LoginScreen.name);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),

      drawer: DrawerMenu(
        scaffoldkey: scaffoldKey,
        username: username,
      ),

      body: gamesList.when(
        data: (gamesList) {
          return _GameLibrary(
            username: username,
            gamesList: gamesList,
          );
        },

        error: (error, stackTrace) {
          return Center(child: Text('Error al cargar Juegos: $error'));
        },

        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      floatingActionButton: FloatingButton(),
    );
  }
}

class _GameLibrary extends ConsumerWidget {
  final String username;
  final List<Game> gamesList;

  const _GameLibrary({required this.username, required this.gamesList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: gamesList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        return _GameItem(game: gamesList[index]);
      },
    );
  }
}

class _GameItem extends StatelessWidget {
  final Game game;

  const _GameItem({
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
          context.pushNamed(GameDetailScreen.name, extra: game.id);
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
