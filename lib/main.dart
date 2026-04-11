import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/novel_provider.dart';
import 'screens/bookshelf/bookshelf_screen.dart';
import 'screens/chapters/chapters_screen.dart';
import 'screens/write/write_screen.dart';
import 'screens/import/import_screen.dart';
import 'screens/reader/reader_screen.dart';
import 'screens/graph/graph_viewer_screen.dart';
import 'screens/settings_screen.dart';
import 'services/storage_service.dart';
import 'theme/game_console_theme.dart';
import 'app/app_shell.dart';
import 'app/router.dart';

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

    return MaterialApp(
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
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home:       (_) => const WriteScreen(),
        AppRoutes.bookshelf:  (_) => const AppShell(title: '📚 我的书架', body: BookshelfScreen()),
        AppRoutes.chapters:   (_) => const AppShell(title: '📖 章节管理', body: ChaptersScreen()),
        AppRoutes.reader:     (_) => const ReaderScreen(),
        AppRoutes.graph:      (_) => const AppShell(title: '🌲 全局图谱', body: GraphViewerScreen()),
        AppRoutes.import:     (_) => const AppShell(title: '📥 导入小说', body: ImportScreen()),
        AppRoutes.settings:  (_) => const AppShell(title: '⚙️ 设置', body: SettingsScreen()),
      },
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
