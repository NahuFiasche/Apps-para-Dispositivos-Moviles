import 'dart:io';
import 'package:exercise1_loginscreen/entities/user.dart';
import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:exercise1_loginscreen/screens/login_screen.dart';
import 'package:exercise1_loginscreen/screens/user_edit_screen.dart';
import 'package:exercise1_loginscreen/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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

class UserSettingsBody extends ConsumerStatefulWidget {
  final String username;

  const UserSettingsBody({super.key, required this.username});

  @override
  ConsumerState<UserSettingsBody> createState() => UserSettingsBodyState();
}

class UserSettingsBodyState extends ConsumerState<UserSettingsBody> {
  @override
  Widget build(BuildContext context) {
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
                      widget.username,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),
                    _ChangePasswordButton(widget: widget),

                    const SizedBox(height: 16),
                    _DeleteUserButton(widget: widget, ref: ref),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 0,
              child: _ProfilePicture(
                username: widget.username,
                onTap: () => _showImageSourceSheet(context),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        _SectionLabel(text: 'Cuenta', colorScheme: colorScheme),

        _AccountDetails(colorScheme: colorScheme, widget: widget, users: users),

        const SizedBox(height: 32),

        _CloseSessionButton(colorScheme: colorScheme, widget: widget),
      ],
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Elegir de la galería'),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUpdatePicture(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: const Text('Tomar una foto'),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUpdatePicture(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUpdatePicture(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return;

    final String? errorMessage = await ref
        .read(usersProvider.notifier)
        .updateProfilePicture(
          username: widget.username,
          newProfilePicture: image.path,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: errorMessage != null
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        content: Text(
          errorMessage ?? 'Foto de perfil actualizada',
          style: TextStyle(
            color: errorMessage != null
                ? Theme.of(context).colorScheme.onError
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordButton extends StatelessWidget {
  const new({
    required this.widget,
  });

  final UserSettingsBody widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: FilledButton.tonalIcon(
        onPressed: () => context.pushNamed(
          UserEditScreen.name,
          extra: widget.username,
        ),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Cambiar Contraseña'),
      ),
    );
  }
}

class _AccountDetails extends ConsumerWidget {
  const new({
    required this.colorScheme,
    required this.widget,
    required this.users,
  });

  final ColorScheme colorScheme;
  final UserSettingsBody widget;
  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? userMail = ref
        .read(usersProvider.notifier)
        .getMail(widget.username);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.person_rounded,
              color: colorScheme.primary,
            ),
            title: const Text('Nombre de usuario'),
            subtitle: Text(widget.username),
          ),

          ListTile(
            leading: Icon(
              Icons.mail_rounded,
              color: colorScheme.primary,
            ),
            title: const Text('Mail'),
            subtitle: Text(
              userMail ?? 'Sin mail',
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseSessionButton extends StatelessWidget {
  const new({
    required this.colorScheme,
    required this.widget,
  });

  final ColorScheme colorScheme;
  final UserSettingsBody widget;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
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
              message: 'Se cerrará la sesión de ${widget.username}',
              actionButtonText: 'Cerrar',
              onDelete: () {
                context.goNamed(LoginScreen.name);
              },
            );
          },
        );
      },
    );
  }
}

class _DeleteUserButton extends StatelessWidget {
  const new({
    required this.widget,
    required this.ref,
  });

  final UserSettingsBody widget;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: FilledButton.tonalIcon(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return ConfirmationDialog(
                title: '¿Eliminar Perfil?',
                message:
                    'Esta acción no se puede deshacer. Se borrarán todos los datos asociados a ${widget.username}.',
                onDelete: () {
                  ref.read(usersProvider.notifier).deleteUser(widget.username);
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

class _ProfilePicture extends ConsumerWidget {
  final String username;
  final VoidCallback onTap;

  const _ProfilePicture({required this.username, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final usersAsync = ref.watch(usersProvider);

    return IconButton(
      iconSize: 90,
      onPressed: onTap,
      icon: usersAsync.when(
        data: (users) {
          final String? profilePath = ref
              .read(usersProvider.notifier)
              .getProfilePicture(username);

          final hasImage =
              profilePath != null &&
              profilePath.isNotEmpty &&
              File(profilePath).existsSync();

          return CircleAvatar(
            radius: 45,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: hasImage ? FileImage(File(profilePath)) : null,
            child: !hasImage
                ? Icon(
                    Icons.person_rounded,
                    size: 45,
                    color: colorScheme.primary,
                  )
                : null,
          );
        },
        loading: () => CircleAvatar(
          radius: 45,
          backgroundColor: colorScheme.primaryContainer,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (error, stack) => CircleAvatar(
          radius: 45,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.person_rounded,
            size: 45,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
