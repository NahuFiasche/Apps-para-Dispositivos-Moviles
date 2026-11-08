import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:exercise1_loginscreen/helpers/games_api_service_helper.dart';
import 'package:exercise1_loginscreen/providers/games_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameAddScreen extends StatelessWidget {
  static const String name = 'addGame_screen';

  const GameAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Nuevo Juego')),
      body: const _AddScreenBody(),
    );
  }
}

class _AddScreenBody extends ConsumerStatefulWidget {
  const _AddScreenBody();

  @override
  ConsumerState<_AddScreenBody> createState() {
    return _AddScreenBodyState();
  }
}

class _AddScreenBodyState extends ConsumerState<_AddScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  final Set<String> _addingIds = {};
  bool _isLoading = false;

  Future<void> _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final results = await SteamGamesService.instance.searchGames(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('No se pudieron buscar juegos: $error'),
        ),
      );
    }
  }

  Future<void> _onAddGame(Map<String, dynamic> game) async {
    final String gameId = game['id']?.toString() ?? '';
    if (_addingIds.contains(gameId)) return;
    setState(() => _addingIds.add(gameId));

    // Los resultados de storesearch traen pocos datos: pedimos los detalles
    // (portada, descripción y año) antes de guardar.
    final details = await SteamGamesService.instance.getGameDetails(game);

    final newGame = Game(
      id: '', // Firestore genera el id en insertGame.
      title: details['name'] ?? 'Sin nombre',
      releaseYear: details['releaseYear'] ?? '',
      releaseDate: details['releaseDate'] ?? '',
      developer: details['developer'] ?? '',
      description: details['description'] ?? '',
      gameCover: details['gameCover'] ?? '',
    );

    try {
      await ref.read(gamesProvider.notifier).addGame(newGame);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Juego agregado: ${newGame.title}'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('No se pudo agregar el juego: $error'),
        ),
      );
    } finally {
      if (mounted) setState(() => _addingIds.remove(gameId));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Nombre del juego (ej. Witcher 3)',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchResults = []);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) => _onSearch(),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 16),

          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_searchResults.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videogame_asset_off_rounded,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Buscá un juego en la tienda de Steam',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _searchResults.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _SearchResultItem(
                    game: _searchResults[index],
                    isAdding: _addingIds.contains(
                      _searchResults[index]['id']?.toString() ?? '',
                    ),
                    onAdd: () => _onAddGame(_searchResults[index]),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Resultado de búsqueda presentado igual que los juegos de la biblioteca:
/// Card con la portada a la izquierda, título y botón para agregar.
class _SearchResultItem extends StatelessWidget {
  final Map<String, dynamic> game;
  final bool isAdding;
  final VoidCallback onAdd;

  const _SearchResultItem({
    required this.game,
    required this.isAdding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final String appId = game['id']?.toString() ?? '';

    // Carátula vertical estilo DVD de la biblioteca de Steam, construida
    // a partir del appid (misma que usa la pantalla de detalle).
    final String coverUrl = appId.isNotEmpty
        ? 'https://cdn.cloudflare.steamstatic.com/steam/apps/$appId/library_600x900_2x.jpg'
        : '';

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
            // Mismo radio que la Card (Material 3: 12).
            borderRadius: BorderRadius.circular(12),
            child: _SearchGameCover(
              url: coverUrl,
              errorColor: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        title: Text(
          game['name']?.toString() ?? 'Sin nombre',
          style: textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Juego de Steam',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: isAdding
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: colorScheme.primary,
                  size: 28,
                ),
                tooltip: 'Agregar a mi biblioteca',
                onPressed: onAdd,
              ),
        onTap: isAdding ? null : onAdd,
      ),
    );
  }
}

class _SearchGameCover extends StatelessWidget {
  final String url;
  final Color errorColor;

  const _SearchGameCover({required this.url, required this.errorColor});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Center(
        child: Icon(Icons.videogame_asset_rounded, size: 32, color: errorColor),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // La carátula vertical no existe para todos los juegos: caemos a
        // la miniatura horizontal del storesearch como reserva.
        final String fallback = (context as Element)
            .findAncestorWidgetOfExactType<_SearchResultItem>()
            ?.game['tiny_image'] as String? ?? '';

        if (fallback.isNotEmpty) {
          return Image.network(
            fallback,
            fit: BoxFit.contain,
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

        return Center(
          child: Icon(Icons.broken_image_rounded, size: 32, color: errorColor),
        );
      },
    );
  }
}
