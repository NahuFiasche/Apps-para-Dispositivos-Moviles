import 'package:exercise1_loginscreen/providers/games_provider.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameEditScreen extends ConsumerStatefulWidget {
  static const String name = 'editGame_screen';
  final Game game;

  const GameEditScreen({super.key, required this.game});

  @override
  ConsumerState<GameEditScreen> createState() => _GameEditScreenState();
}

class _GameEditScreenState extends ConsumerState<GameEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController = TextEditingController(
    text: widget.game.title,
  );
  late final TextEditingController _releaseYearController =
      TextEditingController(text: widget.game.releaseYear);
  late final TextEditingController _developerController =
      TextEditingController(text: widget.game.developer);
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.game.description);
  late final TextEditingController _gameCoverController = TextEditingController(
    text: widget.game.gameCover,
  );

  void _saveChanges() {
    if (_formKey.currentState?.validate() != true) return;

    final updatedGame = Game(
      id: widget.game.id,
      title: _titleController.text.trim(),
      releaseYear: _releaseYearController.text.trim(),
      developer: _developerController.text.trim(),
      description: _descriptionController.text.trim(),
      gameCover: _gameCoverController.text.trim(),
    );

    ref.read(gamesProvider.notifier).updateGame(updatedGame);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Juego')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.sports_esports_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Campo obligatorio'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _releaseYearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Año de lanzamiento',
                prefixIcon: Icon(Icons.calendar_today_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Campo obligatorio'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _developerController,
              decoration: const InputDecoration(
                labelText: 'Desarrollador',
                prefixIcon: Icon(Icons.engineering_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _gameCoverController,
              decoration: const InputDecoration(
                labelText: 'URL de la portada',
                prefixIcon: Icon(Icons.image_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                prefixIcon: Icon(Icons.description_rounded),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              label: const Text('Guardar Cambios'),
              icon: const Icon(Icons.save_rounded),
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}
