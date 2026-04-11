import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'drawer_menu.dart';
import '../theme/v4_colors.dart';

/// v5.0 App Shell - Main scaffold with BottomNavigationBar
/// Replaces the old MainNavigator with GoRouter integration
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: V4Colors.surface,
          boxShadow: [
            BoxShadow(
              color: V4Colors.divider.withOpacity(0.5),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _BottomNav(),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = switch (location) {
      '/' => 0,
      '/reader' => 1,
      '/bookshelf' => 2,
      _ when location.startsWith('/reader') => 1,
      _ when location.startsWith('/bookshelf') => 2,
      _ => 0,
    };

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (idx) {
        switch (idx) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/reader');
            break;
          case 2:
            context.go('/bookshelf');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Text('✍️', style: TextStyle(fontSize: 22)),
          label: '续写',
        ),
        BottomNavigationBarItem(
          icon: Text('📖', style: TextStyle(fontSize: 22)),
          label: '阅读',
        ),
        BottomNavigationBarItem(
          icon: Text('📚', style: TextStyle(fontSize: 22)),
          label: '书架',
        ),
      ],
    );
  }
}
