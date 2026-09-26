import 'dart:io';

import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exercise1_loginscreen/config/menu_items.dart';

class DrawerMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  final String username;

  const DrawerMenu({
    super.key,
    required this.scaffoldkey,
    required this.username,
  });

  @override
  ConsumerState<DrawerMenu> createState() => DrawerMenuState();
}

class DrawerMenuState extends ConsumerState<DrawerMenu> {
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

              _ProfilePicture(
                username: widget.username,
                colorScheme: colorScheme,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

class _ProfilePicture extends ConsumerWidget {
  final String username;
  final ColorScheme colorScheme;

  const _ProfilePicture({required this.username, required this.colorScheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    return usersAsync.when(
      data: (users) {
        final String? profilePath = ref
            .read(usersProvider.notifier)
            .getProfilePicture(username);

        final hasImage =
            profilePath != null &&
            profilePath.isNotEmpty &&
            File(profilePath).existsSync();

        return CircleAvatar(
          radius: 28,
          backgroundColor: colorScheme.primary,
          backgroundImage: hasImage ? FileImage(File(profilePath)) : null,
          child: !hasImage
              ? Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: colorScheme.onPrimary,
                )
              : null,
        );
      },
      loading: () => CircleAvatar(
        radius: 28,
        backgroundColor: colorScheme.primary,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stack) => CircleAvatar(
        radius: 28,
        backgroundColor: colorScheme.primary,
        child: Icon(
          Icons.person_rounded,
          size: 36,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
