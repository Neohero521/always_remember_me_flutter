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

class _AppWithLoadingGuardState extends State<_AppWithLoadingGuard>
    with SingleTickerProviderStateMixin {
  bool _initialized = false;
  late AnimationController _animController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: 14).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<NovelProvider>();
      await provider.waitForInitialization();
      if (mounted) {
        setState(() => _initialized = true);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: CutePixelColors.bg,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _bounceAnim,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, -_bounceAnim.value),
                    child: const Text('🐋', style: TextStyle(fontSize: 64)),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '✨ Always Remember Me ✨',
                  style: TextStyle(
                    color: CutePixelColors.lavender,
                    fontFamily: 'monospace',
                    fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 120, height: 8,
                  child: _CuteLoadingBar(),
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
          colorScheme: ColorScheme.fromSeed(seedColor: CutePixelColors.pink),
          scaffoldBackgroundColor: CutePixelColors.bg,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: CutePixelColors.bg2,
            foregroundColor: CutePixelColors.text,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: CutePixelColors.bg2,
            selectedItemColor: CutePixelColors.lavender,
            unselectedItemColor: CutePixelColors.textMuted,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
          cardTheme: const CardTheme(
            color: CutePixelColors.bgCard,
            elevation: 0,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: CutePixelColors.bg2,
            contentTextStyle: const TextStyle(color: CutePixelColors.text),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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

class _CuteLoadingBar extends StatefulWidget {
  const _CuteLoadingBar();

  @override
  State<_CuteLoadingBar> createState() => _CuteLoadingBarState();
}

class _CuteLoadingBarState extends State<_CuteLoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CutePixelColors.bg3,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CutePixelColors.borderDark, width: 2),
      ),
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          return FractionallySizedBox(
            alignment: Alignment.lerp(
              Alignment.centerLeft,
              Alignment.centerRight,
              _anim.value,
            )!,
            widthFactor: 0.4,
            child: Container(
              decoration: BoxDecoration(
                color: CutePixelColors.pink,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
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
      backgroundColor: CutePixelColors.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: CutePixelColors.bg2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: CutePixelColors.borderDark,
              offset: Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _CuteNavItem(
                  emoji: '📚',
                  label: '书架',
                  selected: _currentIndex == 0,
                  onTap: () => _onTap(0),
                  activeColor: CutePixelColors.pink,
                ),
                _CuteNavItem(
                  emoji: '✍️',
                  label: '续写',
                  selected: _currentIndex == 1,
                  onTap: () => _onTap(1),
                  activeColor: CutePixelColors.lavender,
                ),
                _CuteNavItem(
                  emoji: '⚙️',
                  label: '设置',
                  selected: _currentIndex == 2,
                  onTap: () => _onTap(2),
                  activeColor: CutePixelColors.mint,
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

class _CuteNavItem extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;

  const _CuteNavItem({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? activeColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: selected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? activeColor : CutePixelColors.textMuted,
                  fontFamily: 'monospace',
                  fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (selected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 20, height: 3,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
