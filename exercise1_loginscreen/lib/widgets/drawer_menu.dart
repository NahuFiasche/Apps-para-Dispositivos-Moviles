import 'package:exercise1_loginscreen/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exercise1_loginscreen/config/menu_items.dart';

class DrawerMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  final String usermail;

  const DrawerMenu({
    super.key,
    required this.scaffoldkey,
    required this.usermail,
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

        context.push(menuItems[value].link, extra: widget.usermail);
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
                colorScheme: colorScheme,
              ),

              const SizedBox(height: 12),
              Text(
                widget.usermail,
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

class _ProfilePicture extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ProfilePicture({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final String? profileUrl = UsersProvider.instance.getProfilePicture();

    final hasImage = profileUrl != null && profileUrl.isNotEmpty;

    return SizedBox(
      width: 56, 
      height: 56,
      child: ClipOval(
        child: ColoredBox(
          color: colorScheme.primary,
          child: hasImage
              ? Image.network(
                  profileUrl,
                  fit: BoxFit.cover,

                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child; // Ya cargó, muestra la imagen
                    return Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    );
                  },

                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person_rounded,
                      size: 36,
                      color: colorScheme.onPrimary,
                    );
                  },
                )
              : Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: colorScheme.onPrimary,
                ),
        ),
      ),
    );
  }
}
