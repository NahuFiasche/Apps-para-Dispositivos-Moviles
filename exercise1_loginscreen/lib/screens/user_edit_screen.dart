import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exercise1_loginscreen/widgets/section_label.dart';

class UserEditScreen extends StatelessWidget {
  static const String name = 'editUser_screen';
  final String username;

  const UserEditScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: _EditUserBody(username: username),
    );
  }
}

class _EditUserBody extends ConsumerStatefulWidget {
  final String username;

  const _EditUserBody({required this.username});

  @override
  ConsumerState<_EditUserBody> createState() => _EditUserBodyState();
}

class _EditUserBodyState extends ConsumerState<_EditUserBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          SectionLabel(text: 'Seguridad', colorScheme: colorScheme),

          _EditUserField(
            labelText: 'Contraseña actual',
            icon: Icons.lock_rounded,
            textTheme: textTheme,
            colorScheme: colorScheme,
            controller: _currentPasswordController,
            validator: _currentPasswordValidator,
            obscureText: _obscureCurrentPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureCurrentPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () => setState(
                () => _obscureCurrentPassword = !_obscureCurrentPassword,
              ),
            ),
          ),

          _EditUserField(
            labelText: 'Nueva contraseña',
            icon: Icons.lock_reset_rounded,
            textTheme: textTheme,
            colorScheme: colorScheme,
            controller: _newPasswordController,
            validator: _updatedPasswordValidator,
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

  String? _updatedPasswordValidator(String? updatedPassword) {
    if (updatedPassword == null || updatedPassword.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (updatedPassword ==
        ref
            .read(usersProvider.notifier)
            .getUserPassword(username: widget.username)) {
      return 'La nueva contraseña es igual a la contraseña actual';
    } else {
      return null;
    }
  }

  String? _currentPasswordValidator(String? currentPassword) {
    if (currentPassword !=
        ref
            .read(usersProvider.notifier)
            .getUserPassword(username: widget.username)) {
      return 'La contraseña actual no es correcta';
    } else {
      return null;
    }
  }

  void _saveChanges(BuildContext context) async {
    if (_formKey.currentState?.validate() == false) {
      return;
    }

    final String currentPassword = _currentPasswordController.text.trim();
    final String updatedPassword = _newPasswordController.text.trim();

    final String? errorMessage = await ref
        .read(usersProvider.notifier)
        .updatePassword(
          username: widget.username,
          currentPassword: currentPassword,
          newPassword: updatedPassword,
        );

    if (!context.mounted) return;

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            errorMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Contraseña de ${widget.username} actualizada',
        ),
      ),
    );
    context.pop();
  }
}

class _EditUserField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _EditUserField({
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
