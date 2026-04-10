import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/novel_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/bookshelf/bookshelf_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/import/import_screen.dart';
import 'screens/chapters/chapters_screen.dart';
import 'screens/write/write_screen.dart';
import 'screens/reader/reader_screen.dart';
import 'screens/graph/graph_viewer_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive 初始化（必须在 runApp 之前）
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

/// 加载守卫：确保 NovelProvider 初始化完成后才渲染主 UI
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
    // 等待下一帧，让 NovelProvider 的 _loadSettings() 有机会完成
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
      // 初始化未完成时显示加载画面
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF5F0E8),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Color(0xFF8B6914),
                ),
                SizedBox(height: 16),
                Text(
                  '正在加载...',
                  style: TextStyle(color: Color(0xFF2C2416)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 5,
      child: MaterialApp(
        title: '小说续写器',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
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

/// 主外壳：底部导航
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
    HomeScreen(),
    ChaptersScreen(),
    WriteScreen(),
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
    if (idx != _currentIndex && idx >= 0 && idx < 4) {
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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
          _tabController?.animateTo(idx);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: '书架',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: '章节',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: '续写',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
