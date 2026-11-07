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
      appBar: AppBar(title: Text('Agregar Nuevo Juego')),
      body: _AddScreenBody(),
    );
}
}
class _AddScreenBody extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddScreenBody> createState() {
    return _AddScreenBodyState();
  }
}

class _AddScreenBodyState extends ConsumerState<_AddScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await SteamGamesService.instance.searchGames(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudieron buscar juegos: $error')),
      );
    }
  }

  Future<void> _onAddGame(Map<String, dynamic> game) async {
    // Los resultados de storesearch traen pocos datos: pedimos los detalles
    // completos (descripción, developers, año, screenshots) antes de guardar.
    final details = await SteamGamesService.instance.getGameDetails(game);

    final releaseYear = (details['released'] as String?) ?? '';
    final yearOnly = releaseYear.length >= 4
        ? releaseYear.substring(0, 4)
        : releaseYear;
    final images = List<String>.from(details['images'] ?? const []);

    final newGame = Game(
      id: '', // Firestore genera el id en insertGame.
      title: details['name'] ?? 'Sin nombre',
      developer: details['developers'] ?? '',
      releaseYear: yearOnly,
      plattform: details['platform'] ?? '',
      description: details['overview'] ?? '',
      gameCover: images.isNotEmpty ? images.first : '',
      gameImages: images,
    );

    try {
      await ref.read(gamesProvider.notifier).addGame(newGame);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Juego agregado: ${newGame.title}')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo agregar el juego: $error')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nombre del juego (ej. Witcher 3)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
            const SizedBox(height: 16),

            if (_isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final game = _searchResults[index];
                    return ListTile(
                      leading: game['background_image'] != ''
                          ? Image.network(
                              game['background_image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.videogame_asset),
                      title: Text(game['name']),
                      subtitle: Text(
                        'Lanzamiento: ${game['released']}  |  '
                        'Plataforma: ${game['platform']}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => _onAddGame(game),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
  }
