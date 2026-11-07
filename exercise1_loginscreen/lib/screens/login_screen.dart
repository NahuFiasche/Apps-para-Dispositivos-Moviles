import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:exercise1_loginscreen/screens/game_library_screen.dart';
import 'package:exercise1_loginscreen/screens/user_add_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _googleLoading = false;

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

            _MainAppIcon(colorScheme: colorScheme),

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
              controller: emailController,
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
            _ForgottPasswordButton(),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
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

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: _GoogleSignInButton(
                loading: _googleLoading,
                onPressed: _googleLoading ? null : _signInWithGoogle,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'o',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            _CreateAccountButton(
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    final theme = Theme.of(context);

    setState(() => _googleLoading = true);

    final String? errorMessage = await UsersProvider.instance.signInWithGoogle();

    if (!mounted) return;

    setState(() => _googleLoading = false);

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          width: 320,
          content: Text(
            errorMessage,
            style: TextStyle(color: theme.colorScheme.onError),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
      return;
    }

    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    if (!mounted) return;

    context.goNamed(GamesLibraryScreen.name, extra: email);
  }

  Future<void> _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final theme = Theme.of(context);

    final String? errorMessage = await UsersProvider.instance.signIn(
      email,
      password,
    );

    if (!context.mounted) return;

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          width: 320,
          content: Text(
            errorMessage,
            style: TextStyle(color: theme.colorScheme.onError),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
      return;
    }

    context.goNamed(GamesLibraryScreen.name, extra: emailController.text);
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // Colores según las guías de marca de Google para botones
    // "Sign in with Google" en tema claro y oscuro:
    final Color backgroundColor = isDark ? const Color(0xFF131314) : Colors.white;
    final Color textColor = isDark ? const Color(0xFFE3E3E3) : const Color(0xFF1F1F1F);
    final Color borderColor = isDark ? const Color(0xFF8E918F) : const Color(0xFF747775);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/google_logo.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Continuar con Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const new({
    required this.textTheme,
    required this.colorScheme,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _ForgottPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _ForgotPasswordDialog(),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          visualDensity: VisualDensity.compact,
        ),
        child: const Text(
          '¿Olvidaste tu contraseña?',
        ),
      ),
    );
  }
}

class _MainAppIcon extends StatelessWidget {
  const new({
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ForgotPasswordDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<_ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _emailError;
  bool _sending = false;

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
              'Ingresá tu correo electrónico para recuperar tu cuenta.',
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
                errorText: _emailError,
              ),
              validator: _mailValidator,
              onChanged: (_) {
                if (_emailError != null) {
                  setState(() => _emailError = null);
                }
              },
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
          onPressed: _sending ? null : _submit,
          child: _sending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enviar mail'),
        ),
      ],
    );
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final String emailToFind = _emailController.text.trim();

    setState(() => _sending = true);

    final String? errorMessage = await UsersProvider.instance
        .sendPasswordResetEmail(emailToFind);

    if (!mounted) return;

    setState(() => _sending = false);

    if (errorMessage != null) {
      setState(() => _emailError = errorMessage);
      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
          'Te enviamos un mail para restablecer tu contraseña a $emailToFind',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  String? _mailValidator(String? mail) {
    if (mail == null || mail.trim().isEmpty) {
      return 'Ingresá tu correo';
    }

    if (mail.contains('@') == false) {
      return 'Ingresá un correo válido';
    }

    return null;
  }
}
