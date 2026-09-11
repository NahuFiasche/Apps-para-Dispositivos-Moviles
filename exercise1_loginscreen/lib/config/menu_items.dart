import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String link;

  const MenuItem({required this.title, required this.icon, required this.link});
}

const List<MenuItem> menuItems = [
  MenuItem(
    title: 'Perfil',
    icon: Icons.person_2_rounded,
    link: '/userSettings_screen',
  ),

  MenuItem(
    title: 'Configuración',
    icon: Icons.settings,
    link: '/generalSettings_screen',
  ),
];
