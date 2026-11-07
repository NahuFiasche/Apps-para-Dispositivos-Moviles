import 'package:exercise1_loginscreen/screens/game_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exercise1_loginscreen/providers/games_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

class GameDetailScreen extends ConsumerWidget {
  static const String name = 'gameDetail_screen';
  final String gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Game>> gamesListAsync = ref.watch(gamesProvider);

    return gamesListAsync.when(
      data: (gamesList) {
        final game = gamesList.firstWhereOrNull(
          (game) => game.id == gameId,
        );

        if (game == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('No encontrado')),
            body: const Center(child: Text('El juego no existe.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              game.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: _GameDetailBody(game: game),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Text('Error al cargar el Juego: $error'),
          ),
        );
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cargando...'),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _GameDetailBody extends StatelessWidget {
  final Game game;

  const _GameDetailBody({required this.game});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            // La caratula de Steam (library_600x900) es vertical 2:3.
            aspectRatio: 2 / 3,
            child: _GameImage(url: game.gameCover),
          ),
        ),

        const SizedBox(height: 16),

        Chip(
          avatar: Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: colorScheme.primary,
          ),
          label: Text(game.releaseYear, style: textTheme.bodyMedium),
          backgroundColor: colorScheme.surfaceContainerHigh,
          side: BorderSide.none,
        ),

        const SizedBox(height: 8),

        if (game.developer.isNotEmpty)
          Chip(
            avatar: Icon(
              Icons.engineering_rounded,
              size: 18,
              color: colorScheme.primary,
            ),
            label: Text(game.developer, style: textTheme.bodyMedium),
            backgroundColor: colorScheme.surfaceContainerHigh,
            side: BorderSide.none,
          ),

        const SizedBox(height: 16),

        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              game.description,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                label: const Text('Editar'),
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  context.pushNamed(GameEditScreen.name, extra: game);
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _DeleteButton(colorScheme: colorScheme, game: game),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeleteButton extends ConsumerWidget {
  final ColorScheme colorScheme;
  final Game game;

  const _DeleteButton({required this.colorScheme, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      label: const Text('Borrar'),
      icon: const Icon(Icons.delete_outlined),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.error,
        side: BorderSide(color: colorScheme.error),
      ),
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: Icon(
                Icons.delete_forever_rounded,
                color: colorScheme.error,
                size: 32,
              ),
              title: const Text(
                '¿Eliminar Juego?',
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'La acción de eliminar un Juego no se puede deshacer.',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  onPressed: () {
                    ref.read(gamesProvider.notifier).deleteGame(game.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Borrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _GameImage extends StatelessWidget {
  final String url;

  const _GameImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const Icon(
        Icons.broken_image_rounded,
        size: 32,
        color: Colors.grey,
      );
    }

    return Image.network(
      url,
      // contain: la caratula vertical llena el AspectRatio 2:3 completa y
      // una imagen apaisada se ve con espacio arriba y abajo.
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.broken_image_rounded,
          size: 32,
          color: Colors.grey,
        );
      },
    );
  }
}
