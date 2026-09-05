import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserSettingsScreen extends StatelessWidget {
  static const String name = 'userSettings_screen';
  final String username;

  const UserSettingsScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes de Perfil'),
      ),
      body: UserSettingsBody(username: username),
    );
  }
}

class UserSettingsBody extends StatelessWidget {
  final String username;

  const UserSettingsBody({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Card(
              margin: const EdgeInsets.only(top: 60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 72, 16, 24),
                child: Column(
                  children: [
                    Text(
                      username,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Miembro desde hoy',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('Editar perfil'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.person_rounded,
                  size: 90,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        _SectionLabel(text: 'Cuenta', colorScheme: colorScheme),

        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.alternate_email_rounded,
                  color: colorScheme.primary,
                ),
                title: const Text('Nombre de usuario'),
                subtitle: Text(username),
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user_rounded,
                  color: colorScheme.primary,
                ),
                title: const Text('Estado'),
                subtitle: const Text('Sesión activa'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.logout_rounded),
          label: const Text(
            'Cerrar sesión',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: () => context.goNamed(LoginScreen.name),
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
