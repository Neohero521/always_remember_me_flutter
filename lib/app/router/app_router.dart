import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/writing/presentation/screens/write_screen.dart';
import '../../features/bookshelf/presentation/screens/bookshelf_screen.dart';
import '../../features/reader/presentation/screens/reader_screen.dart';
import '../../screens/chapters/chapters_screen.dart';
import '../../screens/graph/graph_viewer_screen.dart';
import '../../screens/graph/graph_import_export_screen.dart';
import '../../screens/write/write_settings_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/import/import_screen.dart';
import '../app_shell.dart';
import '../drawer_menu.dart';

/// v5.0 GoRouter configuration
/// Replaces Navigator 1.0 with GoRouter for declarative routing
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Main shell with BottomNavigationBar
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WriteScreen(),
            ),
          ),
          GoRoute(
            path: '/reader',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReaderScreen(),
            ),
          ),
          GoRoute(
            path: '/bookshelf',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookshelfScreen(),
            ),
          ),
        ],
      ),

      // Standalone routes (full screen)
      GoRoute(
        path: '/chapters',
        builder: (context, state) => const _StandaloneScreen(
          title: '📖 章节管理',
          body: ChaptersScreen(),
        ),
      ),
      GoRoute(
        path: '/graph',
        builder: (context, state) => const _StandaloneScreen(
          title: '🌲 全局图谱',
          body: GraphViewerScreen(),
        ),
      ),
      GoRoute(
        path: '/graph-import-export',
        builder: (context, state) => const GraphImportExportScreen(),
      ),
      GoRoute(
        path: '/write-settings',
        builder: (context, state) => const WriteSettingsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const _StandaloneScreen(
          title: '📱 设置',
          body: SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/import',
        builder: (context, state) => const _StandaloneScreen(
          title: '📥 导入小说',
          body: ImportScreen(),
        ),
      ),
      GoRoute(
        path: '/reader/:chapterId',
        builder: (context, state) {
          final chapterId = int.tryParse(state.pathParameters['chapterId'] ?? '');
          return ReaderScreen(initialChapterId: chapterId);
        },
      ),
    ],
  );
}

/// Standalone screen wrapper with AppBar and Drawer for v5.0
class _StandaloneScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const _StandaloneScreen({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: const Drawer(
        child: AppDrawer(),
      ),
      body: body,
    );
  }
}
