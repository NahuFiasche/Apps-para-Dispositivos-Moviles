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
        titleTextStyle: textTheme.headlineSmall,
      ),
      body: GameDetailBodyBuilder(game: game),
    );
  }
}

class GameDetailBodyBuilder extends StatelessWidget {
  final Game game;

  const GameDetailBodyBuilder({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,

        children: [
          Text(
            'Imágenes',
            style: textTheme.titleMedium,
          ),

          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: game.gameImages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final String gameImage = game.gameImages[index];
                return GameScreenshots(gameScreenshot: gameImage);
              },
            ),
          ),

          Text(
            'Información',
            style: textTheme.titleMedium,
          ),

          Chip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            avatar: const Icon(Icons.business_rounded, size: 18),
            label: Text(game.developer, style: textTheme.bodyMedium),
            backgroundColor: colorScheme.surfaceContainerHigh,
          ),

          Chip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            avatar: const Icon(Icons.calendar_today_rounded, size: 18),
            label: Text(game.releaseYear, style: textTheme.bodyMedium),
            backgroundColor: colorScheme.surfaceContainerHigh,
          ),

          Chip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            avatar: const Icon(Icons.sports_esports_rounded, size: 18),
            label: Text(game.plattform, style: textTheme.bodyMedium),
            backgroundColor: colorScheme.surfaceContainerHigh,
          ),

          Text(
            'Descripción',
            style: textTheme.titleMedium,
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    game.description,
                    style: textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameScreenshots extends StatelessWidget {
  const GameScreenshots({
    super.key,
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
