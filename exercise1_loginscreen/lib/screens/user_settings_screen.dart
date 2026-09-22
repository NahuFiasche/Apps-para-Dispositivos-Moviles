import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:exercise1_loginscreen/screens/user_edit_screen.dart';
import 'package:exercise1_loginscreen/widgets/confirmation_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class UserSettingsBody extends ConsumerWidget {
  final String username;

  const UserSettingsBody({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final users = ref.watch(usersProvider).value ?? const [];

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

                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed(
                          UserEditScreen.name,
                          extra: username,
                        ),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Cambiar Contraseña'),
                      ),
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .errorContainer,
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onErrorContainer,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return ConfirmationDialog(
                                title: '¿Eliminar Perfil?',
                                message:
                                    'Esta acción no se puede deshacer. Se borrarán todos los datos asociados a $username.',
                                onDelete: () {
                                  ref
                                      .read(usersProvider.notifier)
                                      .deleteUser(username);
                                  context.goNamed(LoginScreen.name);
                                },
                                actionButtonText: 'Eliminar',
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Eliminar perfil'),
                      ),
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
                  Icons.person_rounded,
                  color: colorScheme.primary,
                ),
                title: const Text('Nombre de usuario'),
                subtitle: Text(username),
              ),

              ListTile(
                leading: Icon(
                  Icons.mail_rounded,
                  color: colorScheme.primary,
                ),
                title: const Text('Mail'),
                subtitle: Text(
                  users.firstWhereOrNull((u) => u.username == username)?.mail ??
                      'Sin mail',
                ),
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogContext) {
                return ConfirmationDialog(
                  title: '¿Cerrar Sesión?',
                  message: 'Se cerrará la sesión de $username',
                  actionButtonText: 'Cerrar',
                  onDelete: () {
                    context.goNamed(LoginScreen.name);
                  },
                );
              },
            );
          },
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
