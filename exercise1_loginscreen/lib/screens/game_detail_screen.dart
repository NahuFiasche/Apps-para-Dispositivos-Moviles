import 'package:exercise1_loginscreen/screens/game_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exercise1_loginscreen/providers/games_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:exercise1_loginscreen/widgets/section_label.dart';

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

        return Scaffold(
          appBar: AppBar(
            title: Text(
              game!.title,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        SectionLabel(text: 'Imágenes', colorScheme: colorScheme),

        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: game.gameImages.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final String gameImage = game.gameImages[index];
              return _GameScreenshots(gameScreenshot: gameImage);
            },
          ),
        ),

        SectionLabel(text: 'Información', colorScheme: colorScheme),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
              icon: Icons.business_rounded,
              label: game.developer,
            ),
            _InfoChip(
              icon: Icons.calendar_today_rounded,
              label: game.releaseYear,
            ),
            _InfoChip(
              icon: Icons.sports_esports_rounded,
              label: game.plattform,
            ),
          ],
        ),

        SectionLabel(text: 'Descripción', colorScheme: colorScheme),

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

        SectionLabel(text: 'Configuración', colorScheme: colorScheme),

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
              child: _DeleteButton(
                colorScheme: colorScheme,
                textTheme: textTheme,
                game: game,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeleteButton extends ConsumerWidget {
  const _DeleteButton({
    required this.colorScheme,
    required this.textTheme,
    required this.game,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      label: Text('Borrar'),
      icon: Icon(Icons.delete_outlined),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.error,
        side: BorderSide(color: colorScheme.error),
      ),
      onPressed: (() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return PopScope(
              canPop: false,

              child: AlertDialog(
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: colorScheme.error,
                  size: 32,
                ),

                title: Text(
                  '¿Eliminar Juego?',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall,
                ),

                content: Text(
                  'La acción de eliminar un Juego no se puede deshacer.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    child: const Text('Cancelar'),
                  ),

                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                    ),
                    onPressed: (() {
                      ref.read(gamesProvider.notifier).deleteGame(game.id);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
                    child: const Text('Borrar'),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(icon, size: 18, color: colorScheme.primary),
      label: Text(label, style: textTheme.bodyMedium),
      backgroundColor: colorScheme.surfaceContainerHigh,
      side: BorderSide.none,
    );
  }
}

class _GameScreenshots extends StatelessWidget {
  const _GameScreenshots({
    required this.gameScreenshot,
  });

  final String gameScreenshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: getGameImage(),
      ),
    );
  }

  Widget getGameImage() {
    return Image.network(
      gameScreenshot,
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
