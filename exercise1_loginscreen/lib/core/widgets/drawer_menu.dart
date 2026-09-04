import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:exercise1_loginscreen/core/config/menu_items.dart';

class DrawerMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;

  const DrawerMenu({super.key, required this.scaffoldkey});

  @override
  State<StatefulWidget> createState() {
    return DrawerMenuState();
  }

}

class DrawerMenuState extends State<DrawerMenu> {

  @override
  Widget build(BuildContext context)
  {
    return Placeholder();
  }
}
