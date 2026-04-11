import 'package:flutter/material.dart';
import '../theme/game_console_theme.dart';
import 'drawer_menu.dart';

/// 通用页面外壳 — Scaffold + Drawer
/// 用于 BookshelfScreen / ChaptersScreen / GlobalGraphScreen / SettingsScreen 等
class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Color? appBarColor;
  final Widget? floatingActionButton;
  final bool showDrawer;

  const AppShell({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.appBarColor,
    this.floatingActionButton,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CutePixelColors.bg,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor ?? CutePixelColors.bg2,
        foregroundColor: CutePixelColors.text,
        elevation: 0,
        leading: showDrawer
            ? Builder(
                builder: (ctx) => IconButton(
                  icon: const Text('☰', style: TextStyle(fontSize: 22)),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              )
            : null,
        actions: actions,
      ),
      drawer: showDrawer ? const AppDrawer() : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
