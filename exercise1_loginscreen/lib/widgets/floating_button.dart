import 'package:exercise1_loginscreen/screens/game_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.pushNamed(GameAddScreen.name);
      },
      child: Icon(Icons.add),
    );
  }
}
