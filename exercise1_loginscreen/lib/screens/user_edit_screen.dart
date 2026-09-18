import 'package:exercise1_loginscreen/entities/user.dart';
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
      appBar: AppBar(title: const Text('Editar Usuario')),
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
  late User currentUser;
  late final String updatedUsername;
  late final String updatedMail;
  late final String currentPassword;
  late final String updatedPassword;

  @override
  void initState() {
    super.initState();
    currentUser = ref
        .read(usersProvider)
        .firstWhere(
          (User user) => user.username == widget.username,
        );
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
          SectionLabel(
            text: 'Información del perfil',
            colorScheme: colorScheme,
          ),

          _EditUserField(
            labelText: 'Nombre de usuario',
            icon: Icons.alternate_email_rounded,
            initialValue: currentUser.username,
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _requiredValidator,
            onSaved: (value) => updatedUsername = value!.trim(),
          ),

          _EditUserField(
            labelText: 'Mail',
            icon: Icons.alternate_email_rounded,
            initialValue: currentUser.mail,
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _requiredValidator,
            onSaved: (value) => updatedMail = value!.trim(),
          ),

          SectionLabel(text: 'Seguridad', colorScheme: colorScheme),

          _EditUserField(
            labelText: 'Contraseña actual',
            icon: Icons.lock_rounded,
            initialValue: '',
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _currentPasswordValidator,
            obscureText: true,
            onSaved: (value) => currentPassword = value!.trim(),
          ),

          _EditUserField(
            labelText: 'Nueva contraseña',
            icon: Icons.lock_reset_rounded,
            initialValue: '',
            textTheme: textTheme,
            colorScheme: colorScheme,
            validator: _updatedPasswordValidator,
            obscureText: true,
            onSaved: (value) => updatedPassword = value!.trim(),
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
    } else {
      return null;
    }
  }

  String? _updatedPasswordValidator(String? updatedPassword) {
    if (updatedPassword == null || updatedPassword.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (updatedPassword == currentUser.password) {
      return 'La nueva contraseña es igual a la contraseña actual';
    } else {
      return null;
    }
  }

  String? _currentPasswordValidator(String? currentPassword) {
    if (currentPassword != currentUser.password) {
      return 'La contraseña actual no es correcta';
    } else {
      return null;
    }
  }

  void _saveChanges(BuildContext context) {
    if (_formKey.currentState?.validate() == false) {
      return;
    }

    _formKey.currentState?.save();

    User updatedUser = currentUser.copyWith(
      username: updatedUsername,
      mail: updatedMail,
      password: updatedPassword,
    );
    
    ref.read(usersProvider.notifier).updateUser(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Perfil de $currentUser.username actualizado',
        ),
      ),
    );
    context.pop();
  }
}

class _EditUserField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String initialValue;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  const _EditUserField({
    required this.labelText,
    required this.icon,
    required this.initialValue,
    required this.textTheme,
    required this.colorScheme,
    this.obscureText = false,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
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
