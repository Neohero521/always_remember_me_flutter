import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/novel_provider.dart';
import 'screens/bookshelf/bookshelf_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/import/import_screen.dart';
import 'screens/reader/reader_screen.dart';
import 'screens/graph/graph_viewer_screen.dart';
import 'screens/write/write_studio_screen.dart';
import 'services/storage_service.dart';
import 'theme/game_console_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();
  runApp(const AlwaysRememberMeApp());
}

class AlwaysRememberMeApp extends StatelessWidget {
  const AlwaysRememberMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NovelProvider(),
      child: const _AppWithLoadingGuard(),
    );
  }
}

class _AppWithLoadingGuard extends StatefulWidget {
  const _AppWithLoadingGuard();

  @override
  State<_AppWithLoadingGuard> createState() => _AppWithLoadingGuardState();
}

class _AppWithLoadingGuardState extends State<_AppWithLoadingGuard> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<NovelProvider>();
      await provider.waitForInitialization();
      if (mounted) {
        setState(() => _initialized = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: GameColors.bg,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('🐋', style: TextStyle(fontSize: 48)),
                SizedBox(height: 16),
                Text(
                  'Always Remember Me',
                  style: TextStyle(
                    color: GameColors.textLight,
                    fontFamily: 'monospace',
                    fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: GameColors.blueBright,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: MaterialApp(
        title: '小说续写器',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: GameColors.blue),
          scaffoldBackgroundColor: GameColors.bg,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: GameColors.bg2,
            foregroundColor: GameColors.textLight,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: GameColors.bg2,
            selectedItemColor: GameColors.blueBright,
            unselectedItemColor: GameColors.textMuted,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
          cardTheme: const CardTheme(
            color: GameColors.bg2,
            elevation: 0,
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: GameColors.bg2,
            contentTextStyle: TextStyle(color: GameColors.textLight),
            behavior: SnackBarBehavior.floating,
          ),
        ),
        home: const MainShell(),
        routes: {
          '/import': (_) => const ImportScreen(),
          '/reader': (_) => const ReaderScreen(),
          '/graph': (_) => const GraphViewerScreen(),
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  TabController? _tabController;

  final _screens = const [
    BookshelfScreen(),
    WriteStudioScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController?.removeListener(_onTabChanged);
    _tabController = DefaultTabController.of(context);
    _tabController!.addListener(_onTabChanged);
    if (_tabController!.index != _currentIndex) {
      setState(() => _currentIndex = _tabController!.index);
    }
  }

  void _onTabChanged() {
    if (_tabController == null) return;
    if (_tabController!.indexIsChanging) return;
    final idx = _tabController!.index;
    if (idx != _currentIndex && idx >= 0 && idx < 3) {
      setState(() => _currentIndex = idx);
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: GameColors.bg2,
          border: Border(
            top: BorderSide(color: GameColors.borderLight, width: 2),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  icon: '📚',
                  label: '书架',
                  selected: _currentIndex == 0,
                  onTap: () => _onTap(0),
                ),
                _NavItem(
                  icon: '✍️',
                  label: '续写',
                  selected: _currentIndex == 1,
                  onTap: () => _onTap(1),
                ),
                _NavItem(
                  icon: '⚙️',
                  label: '设置',
                  selected: _currentIndex == 2,
                  onTap: () => _onTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int idx) {
    setState(() => _currentIndex = idx);
    _tabController?.animateTo(idx);
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? GameColors.blue.withOpacity(0.15) : Colors.transparent,
            border: Border(
              top: BorderSide(
                color: selected ? GameColors.blueBright : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? GameColors.textLight : GameColors.textMuted,
                  fontFamily: 'monospace',
                  fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
