import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exercise1_loginscreen/widgets/section_label.dart';

class UserAddScreen extends StatelessWidget {
  static const String name = 'addUser_screen';

  const UserAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Usuario')),
      body: _AddUserBody(),
    );
  }
}

class _AddUserBody extends ConsumerStatefulWidget {
  const _AddUserBody();

  @override
  ConsumerState<_AddUserBody> createState() => _AddUserBodyState();
}

class _AddUserBodyState extends ConsumerState<_AddUserBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newMailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          SectionLabel(
            text: 'Información del perfil',
            colorScheme: colorScheme,
          ),

          _AddUserField(
            labelText: 'Nombre de usuario',
            icon: Icons.alternate_email_rounded,
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _requiredValidator,
            controller: _newUsernameController,
          ),

          _AddUserField(
            labelText: 'Mail',
            icon: Icons.mail_rounded,
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _requiredValidator,
            controller: _newMailController,
          ),

          SectionLabel(text: 'Seguridad', colorScheme: colorScheme),

          _AddUserField(
            labelText: 'Contraseña',
            icon: Icons.lock_rounded,
            textTheme: textTheme,
            colorScheme: colorScheme,
            controller: _newPasswordController,
            validator: _requiredValidator,
            obscureText: _obscureNewPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNewPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () => setState(
                () => _obscureNewPassword = !_obscureNewPassword,
              ),
            ),
          ),

          _AddUserField(
            labelText: 'Confirmar contraseña',
            icon: Icons.lock_reset_rounded,
            textTheme: textTheme,
            colorScheme: colorScheme,
            controller: _confirmPasswordController,
            validator: _confirmPasswordValidator,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
            ),
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            label: const Text('Crear Usuario'),
            icon: const Icon(Icons.person_add_rounded),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _saveUser(context),
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    } else {
      return null;
    }
  }

  String? _confirmPasswordValidator(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (confirmPassword != _newPasswordController.text.trim()) {
      return 'Las contraseñas no coinciden';
    } else {
      return null;
    }
  }

  void _saveUser(BuildContext context) async {
    if (_formKey.currentState?.validate() == false) {
      return;
    }

    final String newUsername = _newUsernameController.text.trim();
    final String newMail = _newMailController.text.trim();
    final String newPassword = _newPasswordController.text.trim();

    final String? returnString = await ref
        .read(usersProvider.notifier)
        .addUser(
          newMail: newMail,
          newUsername: newUsername,
          newPassword: newPassword,
        );

    if (!context.mounted) return;
    
    if (returnString != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          shape: Theme.of(context).snackBarTheme.shape,
          content: Text(
            returnString,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
      );
    } else {
      context.pop();

      _showUserInfo(userPassword: newPassword, username: newUsername);
    }
  }

  void _showUserInfo({required String userPassword, required String username}) {
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
                Icons.verified_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),

              Text(
                'Cuenta creada exitosamente',
                style: theme.textTheme.titleMedium,
              ),

              const SizedBox(height: 12),
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
}

class _AddUserField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _AddUserField({
    required this.labelText,
    required this.icon,
    required this.textTheme,
    required this.colorScheme,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, size: 20, color: colorScheme.primary),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
