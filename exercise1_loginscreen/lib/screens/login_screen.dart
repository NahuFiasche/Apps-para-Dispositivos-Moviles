import 'package:exercise1_loginscreen/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  static const String name = 'login_screen';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<Map<String, String>> validUsers = [
    {'username': 'admin', 'password': 'admin'},
    {'username': 'user1', 'password': '1234'},
    {'username': 'juan', 'password': 'password'},
    {'username': 'Nahuel', 'password': '123456'},
  ];

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de Inicio'),
      ),
      body: _wrapInAestheticLayout(
        context: context,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: usernameController,
                decoration: _aestheticInputDecoration(
                  hintText: 'Usuario',
                  icon: Icons.person_outline_rounded,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                obscuringCharacter: '*',
                controller: passwordController,
                decoration: _aestheticInputDecoration(
                  hintText: 'Contraseña',
                  icon: Icons.lock_outline_rounded,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (validateLogin() == true) {
                  context.pushNamed(
                    HomeScreen.name,
                    extra: usernameController.text,
                  );
                } else {
                  _showErrorSnackBar(context);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  bool validateLogin() {
    return validUsers.any(
      (user) =>
          user['username'] == usernameController.text &&
          user['password'] == passwordController.text,
    );
  }

  Widget _wrapInAestheticLayout({
    required BuildContext context,
    required Widget child,
  }) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              _buildHeaderIcon(context),
              const SizedBox(height: 20),
              _buildHeaderTitles(context),
              const SizedBox(height: 28),
              Card(
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
                  padding: const EdgeInsets.all(20.0),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_person_rounded,
        size: 56,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildHeaderTitles(BuildContext context) {
    return Column(
      children: [
        Text(
          '¡Bienvenido de nuevo!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresa tus credenciales para acceder',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  InputDecoration _aestheticInputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Usuario y/o Contraseña incorrectos',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
