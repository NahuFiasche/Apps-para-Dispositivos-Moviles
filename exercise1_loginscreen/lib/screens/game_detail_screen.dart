import 'package:flutter/material.dart';
import 'package:exercise1_loginscreen/entities/games.dart';

class GameDetailScreen extends StatelessWidget {
  static const String name = 'gameDetail_screen';
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title, maxLines: 1, overflow: TextOverflow.ellipsis),
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

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _SectionLabel(text: 'Imágenes', colorScheme: colorScheme),

        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: game.gameImages.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final String gameImage = game.gameImages[index];
              return GameScreenshots(gameScreenshot: gameImage);
            },
          ),
        ),

        _SectionLabel(text: 'Información', colorScheme: colorScheme),

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

        _SectionLabel(text: 'Descripción', colorScheme: colorScheme),

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

        
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final ColorScheme colorScheme;

  const _SectionLabel({required this.text, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
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
