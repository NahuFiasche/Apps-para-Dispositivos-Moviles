import 'package:flutter/material.dart';

enum Idioma {
  ingles,
  espaniol,
  frances,
  portugues,
}

class GeneralSettingsScreen extends StatelessWidget {
  static const String name = 'generalSettings_screen';

  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: const GeneralSettingsBody(),
    );
  }
}

class GeneralSettingsBody extends StatefulWidget {
  const GeneralSettingsBody({super.key});

  @override
  State<GeneralSettingsBody> createState() => _GeneralSettingsBodyState();
}

class _GeneralSettingsBodyState extends State<GeneralSettingsBody> {
  Idioma idiomaSeleccionado = Idioma.espaniol;
  bool darkTheme = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _SectionHeader(text: 'General', colorScheme: colorScheme),

        Card(
          margin: const EdgeInsets.only(bottom: 24),
          clipBehavior: Clip.antiAlias,
          child: SwitchListTile(
            secondary: Icon(
              darkTheme ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: colorScheme.primary,
            ),
            title: const Text('Tema oscuro'),
            subtitle: Text(
              'Ajusta la apariencia de la aplicación',
              style: textTheme.bodySmall,
            ),
            value: darkTheme,
            onChanged: (bool? newValue) {
              if (newValue != null) {
                setState(() => darkTheme = newValue);
              }
            },
          ),
        ),

        _SectionHeader(text: 'Idioma', colorScheme: colorScheme),

        Card(
          margin: const EdgeInsets.only(bottom: 24),
          clipBehavior: Clip.antiAlias,
          child: RadioGroup<Idioma>(
            groupValue: idiomaSeleccionado,
            onChanged: (Idioma? nuevoValor) {
              if (nuevoValor != null) {
                setState(() => idiomaSeleccionado = nuevoValor);
              }
            },
            child: Column(
              children: [
                for (final idioma in Idioma.values)
                  RadioListTile<Idioma>(
                    secondary: Icon(
                      _iconoIdioma(idioma),
                      color: colorScheme.onSurfaceVariant,
                    ),
                    title: Text(_nombreIdioma(idioma)),
                    subtitle: Text(
                      _nombreNativoIdioma(idioma),
                      style: textTheme.bodySmall,
                    ),
                    value: idioma,
                  ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Los cambios se aplican de inmediato',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _nombreIdioma(Idioma idioma) {
    switch (idioma) {
      case Idioma.espaniol:
        return 'Español';
      case Idioma.ingles:
        return 'Inglés';
      case Idioma.frances:
        return 'Francés';
      case Idioma.portugues:
        return 'Portugués';
    }
  }

  String _nombreNativoIdioma(Idioma idioma) {
    switch (idioma) {
      case Idioma.espaniol:
        return 'Español (España)';
      case Idioma.ingles:
        return 'English (US)';
      case Idioma.frances:
        return 'Français (France)';
      case Idioma.portugues:
        return 'Português (Brasil)';
    }
  }

  IconData _iconoIdioma(Idioma idioma) {
    switch (idioma) {
      case Idioma.espaniol:
        return Icons.language;
      case Idioma.ingles:
        return Icons.language;
      case Idioma.frances:
        return Icons.language;
      case Idioma.portugues:
        return Icons.language;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  final ColorScheme colorScheme;

  const _SectionHeader({
    required this.text,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
