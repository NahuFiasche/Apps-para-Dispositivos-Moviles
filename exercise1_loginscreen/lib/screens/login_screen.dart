import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:exercise1_loginscreen/screens/game_library_screen.dart';
import 'package:exercise1_loginscreen/screens/user_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoginBodyBuilder(),
      ),
    );
  }
}

class LoginBodyBuilder extends ConsumerStatefulWidget {
  const LoginBodyBuilder({super.key});

  @override
  ConsumerState<LoginBodyBuilder> createState() => _LoginBodyBuilderState();
}

class _LoginBodyBuilderState extends ConsumerState<LoginBodyBuilder> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 48),

            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_esports_rounded,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Catálogo de Juegos',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Inicia sesión para continuar',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            TextField(
              controller: usernameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Usuario',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              obscuringCharacter: '*',
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.key_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ForgotPasswordDialog(),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                //TODO: Agregar circularindicator mientras espera la rta del logeo
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _login(context),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No tienes una cuenta?',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed(UserAddScreen.name);
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final theme = Theme.of(context);

    // Esperamos a que la lista de usuarios termine de cargar de la DB
    await ref.read(usersProvider.future);

    if (!context.mounted) return;

    if (await ref
            .read(usersProvider.notifier)
            .validateLogin(
              username,
              password,
            ) ==
        true) {
      if (!context.mounted) return;

      context.goNamed(
        GamesLibraryScreen.name,
        extra: usernameController.text,
      );
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          width: 320,
          content: Text(
            'Usuario y/o contraseña incorrectos',
            style: TextStyle(color: theme.colorScheme.onError),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }
}

class ForgotPasswordDialog extends ConsumerStatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  ConsumerState<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      title: const Text('Recuperar contraseña'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresá tu correo electrónico para verificar tu cuenta.',
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _mailValidator,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Buscar'),
        ),
      ],
    );
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final String emailToFind = _emailController.text.trim();

    final String? userPassword = ref
        .read(usersProvider.notifier)
        .getUserPassword(userMail: emailToFind);
    final String? username = await ref
        .read(usersProvider.notifier)
        .getUsername(emailToFind);

    if (!mounted) return;
    Navigator.pop(context);

    if (userPassword != null && username != null) {
      showUserInfo(userPassword: userPassword, username: username);
    }
  }

  void showUserInfo({required String userPassword, required String username}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),

              Text(
                'Tu usuario es',
                style: theme.textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              SelectableText(
                username,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Tu contraseña es',
                style: theme.textTheme.titleMedium,
              ),

              const SizedBox(height: 8),

              SelectableText(
                userPassword,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _mailValidator(String? mail) {
    if (mail == null || mail.trim().isEmpty) {
      return 'Ingresá tu correo';
    }

    if (ref.read(usersProvider.notifier).existsMail(mail.trim()) == false) {
      return 'No existe un usuario con el correo ${mail.trim()}';
    }

    return null;
  }
}
