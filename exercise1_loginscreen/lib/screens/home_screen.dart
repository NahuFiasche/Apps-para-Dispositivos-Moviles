import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  final String username;

  const HomeScreen({super.key, this.username = 'Undefined username'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
      ),
      body: _wrapInAestheticProfileCard(
        context: context,
        child: Center(
          child: Text('Bienvenido, $username'),
        ),
      ),
    );
  }

  Widget _wrapInAestheticProfileCard({
    required BuildContext context,
    required Widget child,
  }) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar con inicial del usuario
                  _buildUserAvatar(context),
                  const SizedBox(height: 24),

                  // Contenido de tu texto original ("Welcome, $username")
                  child,

                  const SizedBox(height: 32),

                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 48,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : 'U',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back_rounded, size: 20),
        label: const Text('Cerrar Sesión'),
      ),
    );
  }
}
