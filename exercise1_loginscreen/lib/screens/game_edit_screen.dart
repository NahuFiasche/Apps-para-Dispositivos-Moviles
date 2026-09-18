import 'package:exercise1_loginscreen/providers/games_provider.dart';
import 'package:exercise1_loginscreen/entities/games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exercise1_loginscreen/widgets/section_label.dart';


class GameEditScreen extends StatelessWidget {
  static const String name = 'editGame_screen';
  final Game game;

  const GameEditScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Juego')),
      body: _EditScreenBody(game: game),
    );
  }
}

class _EditScreenBody extends ConsumerStatefulWidget {
  final Game game;

  const _EditScreenBody({required this.game});

  @override
  ConsumerState<_EditScreenBody> createState() {
    return _EditScreenBodyState();
  }
}

class _EditScreenBodyState extends ConsumerState<_EditScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //TODO: Implementar con TextFormController
  String _title = '';
  String _developer = '';
  String _releaseYear = '';
  String _plattform = '';
  String _description = '';
  String _gameCover = '';
  List<String> _gameImages = [];

  Game get game => widget.game;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          SectionLabel(text: 'Información', colorScheme: colorScheme),

          _EditField(
            labelText: 'Título',
            icon: Icons.sports_esports_rounded,
            initialValue: game.title,
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _requiredValidator,
            onSaved: (value) => _title = value!.trim(),
          ),

          _EditField(
            labelText: 'Desarrollador',
            icon: Icons.business_rounded,
            initialValue: game.developer,
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _requiredValidator,
            onSaved: (value) => _developer = value!.trim(),
          ),

          _EditField(
            labelText: 'Año de lanzamiento',
            icon: Icons.calendar_today_rounded,
            initialValue: game.releaseYear,
            textTheme: textTheme,
            colorScheme: colorScheme,
            keyboardType: TextInputType.number,
            validator: _requiredValidator,
            onSaved: (value) => _releaseYear = value!.trim(),
          ),

          _EditField(
            labelText: 'Plataforma',
            icon: Icons.videogame_asset_rounded,
            initialValue: game.plattform,
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _requiredValidator,
            onSaved: (value) => _plattform = value!.trim(),
          ),

          SectionLabel(text: 'Descripción', colorScheme: colorScheme),

          _EditField(
            labelText: 'Descripción del juego',
            icon: Icons.description_rounded,
            initialValue: game.description,
            textTheme: textTheme,
            colorScheme: colorScheme,
            maxLines: 5,
            validator: _requiredValidator,
            onSaved: (value) => _description = value!.trim(),
          ),

          SectionLabel(text: 'Imágenes', colorScheme: colorScheme),

          _EditField(
            labelText: 'URL de la portada',
            icon: Icons.image_rounded,
            initialValue: game.gameCover ?? '',
            textTheme: textTheme,
            colorScheme: colorScheme,
            onSaved: (value) => _gameCover = value!.trim(),
          ),

          _EditField(
            labelText: 'URLs de capturas (separadas por coma)',
            icon: Icons.collections_rounded,
            initialValue: game.gameImages.join(', '),
            textTheme: textTheme,
            colorScheme: colorScheme,
            maxLines: 3,
            onSaved: (value) {
              _gameImages = value!
                  .split(',')
                  .map((String url) => url.trim())
                  .where((String url) => url.isNotEmpty)
                  .toList();
            },
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            label: const Text('Guardar Cambios'),
            icon: const Icon(Icons.save_rounded),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _saveChanges(context),
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  void _saveChanges(BuildContext context) {
    if (_formKey.currentState?.validate() == false) {
      return;
    }

    _formKey.currentState?.save();

    final Game updatedGame = Game(
      id: game.id,
      title: _title,
      developer: _developer,
      releaseYear: _releaseYear,
      plattform: _plattform,
      description: _description,
      gameCover: _gameCover.isEmpty ? null : _gameCover,
      gameImages: _gameImages,
    );

    ref.read(gamesProvider.notifier).updateGame(updatedGame);
    context.pop();
  }
}


class _EditField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String initialValue;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  const _EditField({
    required this.labelText,
    required this.icon,
    required this.initialValue,
    required this.textTheme,
    required this.colorScheme,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        style: textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, size: 20, color: colorScheme.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
