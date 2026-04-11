import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/novel_provider.dart';
import 'services/storage_service.dart';
import 'screens/write/write_screen.dart';
import 'screens/bookshelf/bookshelf_screen.dart';
import 'screens/reader/reader_screen.dart';
import 'screens/chapters/chapters_screen.dart';
import 'screens/graph/graph_viewer_screen.dart';
import 'screens/graph/graph_import_export_screen.dart';
import 'screens/write/write_settings_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/import/import_screen.dart';
import 'app/drawer_menu.dart';
import 'app/router.dart';
import 'theme/game_console_theme.dart';
import 'theme/v4_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();
  
  final provider = NovelProvider();
  await provider.waitForInitialization();
  
  runApp(MyApp(provider: provider));
}

class MyApp extends StatelessWidget {
  final NovelProvider provider;
  const MyApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        title: 'Always Remember Me',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: V4Colors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: V4Colors.background,
          appBarTheme: AppBarTheme(
            backgroundColor: V4Colors.surface,
            foregroundColor: V4Colors.onBackground,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: V4Colors.onBackground,
            ),
          ),
          cardTheme: CardTheme(
            color: V4Colors.surface,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: V4Colors.surface,
            selectedItemColor: V4Colors.primary,
            unselectedItemColor: V4Colors.textSecondary,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: V4Colors.surface,
            contentTextStyle: TextStyle(color: V4Colors.onBackground),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const MainNavigator(),
          AppRoutes.chapters: (_) => const _StandaloneScreen(
            title: '📖 章节管理',
            body: ChaptersScreen(),
          ),
          AppRoutes.graph: (_) => const _StandaloneScreen(
            title: '🌲 全局图谱',
            body: GraphViewerScreen(),
          ),
          AppRoutes.graphImportExport: (_) => const GraphImportExportScreen(),
          AppRoutes.writeSettings: (_) => const WriteSettingsScreen(),
          AppRoutes.settings: (_) => const _StandaloneScreen(
            title: '📱 设置',
            body: SettingsScreen(),
          ),
          AppRoutes.import: (_) => const _StandaloneScreen(
            title: '📥 导入小说',
            body: ImportScreen(),
          ),
          AppRoutes.reader: (_) => const ReaderScreen(),
        },
      ),
    );
  }
}

/// Standalone screen wrapper with AppBar and Drawer
class _StandaloneScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const _StandaloneScreen({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: V4Colors.background,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}

/// Main Navigator with BottomNavigationBar (3 Tabs)
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    WriteScreen(),
    ReaderScreen(),
    BookshelfScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
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
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (idx) => setState(() => _currentIndex = idx),
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
            ),
          ),
        ),
      ),
    );
  }
}
