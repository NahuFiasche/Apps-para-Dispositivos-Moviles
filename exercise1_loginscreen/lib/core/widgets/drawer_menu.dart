import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:exercise1_loginscreen/core/config/menu_items.dart';

class DrawerMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  final String username;

  const DrawerMenu({
    super.key,
    required this.scaffoldkey,
    required this.username,
  });

  @override
  State<DrawerMenu> createState() => DrawerMenuState();
}

class DrawerMenuState extends State<DrawerMenu> {
  int? selectedScreen;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationDrawer(
      selectedIndex: selectedScreen,
      onDestinationSelected: (value) {
        setState(() {
          selectedScreen = value;
        });

        widget.scaffoldkey.currentState?.closeDrawer();

        context.push(menuItems[value].link, extra: widget.username);
      },
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primary,
                child: Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.username,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Sesión activa',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Text(
            'Opciones',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        for (final item in menuItems)
          NavigationDrawerDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.icon, fill: 1.0),
            label: Text(item.title),
          ),
      ],
    );
  }
}
