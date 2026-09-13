import 'package:exercise1_loginscreen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:exercise1_loginscreen/widgets/section_label.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralSettingsScreen extends StatelessWidget {
  static const String name = 'generalSettings_screen';

  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: _GeneralSettingsBody(),
    );
  }
}

class _GeneralSettingsBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ThemeMode themeMode = ref.watch(themeProvider).themeMode;
    final Color currentSeedColor = ref.watch(themeProvider).seedColor;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        SectionLabel(text: 'General', colorScheme: colorScheme),

        Card(
          margin: const EdgeInsets.only(bottom: 24),
          clipBehavior: Clip.antiAlias,
          child: SwitchListTile(
            secondary: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: colorScheme.primary,
            ),
            title: const Text('Tema Oscuro'),
            subtitle: Text(
              'Ajusta la apariencia de la aplicación',
              style: textTheme.bodySmall,
            ),
            value: themeMode == ThemeMode.dark,
            onChanged: (bool? newValue) {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ),

        SectionLabel(text: 'Color principal', colorScheme: colorScheme),

        Card(
          margin: const EdgeInsets.only(bottom: 24),
          clipBehavior: Clip.antiAlias,
          child: RadioGroup<Color>(
            groupValue: currentSeedColor,
            onChanged: (Color? newColor) {
              ref.read(themeProvider.notifier).changeSeedColor(newColor!);
            },
            child: Column(
              children: [
                RadioListTile<Color>(
                  secondary: const Icon(
                    Icons.circle,
                    color: Colors.blue,
                  ),
                  title: const Text('Azul'),
                  value: Colors.blue,
                ),

                RadioListTile<Color>(
                  secondary: const Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                  title: const Text('Verde'),
                  value: Colors.green,
                ),

                RadioListTile<Color>(
                  secondary: const Icon(
                    Icons.circle,
                    color: Colors.deepPurple,
                  ),
                  title: const Text('Violeta'),
                  value: Colors.deepPurple,
                ),

                RadioListTile<Color>(
                  secondary: const Icon(
                    Icons.circle,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Naranja'),
                  value: Colors.deepOrange,
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
}
