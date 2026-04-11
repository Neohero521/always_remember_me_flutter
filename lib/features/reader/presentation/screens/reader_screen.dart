import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:always_remember_me/app/theme/colors.dart';
import 'package:always_remember_me/providers/novel_provider.dart';
import 'package:always_remember_me/models/chapter.dart';

/// ReaderScreen v5.0 - BottomNav Tab2: 阅读器页面
/// Based on UI_DESIGN_v5.md Section 4
/// - Top: chapter selection, font size
/// - Content: novel content display
/// - Bottom: prev/next chapter navigation
/// - Right: chapter directory panel (slide out)
/// - Font/theme settings BottomSheet
class ReaderScreen extends StatefulWidget {
  final int? initialChapterId;

  const ReaderScreen({super.key, this.initialChapterId});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showControls = true;
  int? _lastChapterId;
  int? _lastFontSize;
  String? _currentBookId;
  ScrollController? _currentScrollController;

  // Reader theme state (v5.0)
  double _fontSize = 16;
  double _lineHeight = 1.8;
  int _selectedThemeIndex = 0;

  // Chapter list panel state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Theme configs (from UI_DESIGN_v5.md Section 8.1)
  static const List<_ReaderTheme> _themes = [
    _ReaderTheme(
      name: '白纸',
      bgColor: Color(0xFFFAFAFA),
      textColor: Color(0xFF1F2937),
      label: '日间阅读',
    ),
    _ReaderTheme(
      name: '羊皮',
      bgColor: Color(0xFFF5F0E1),
      textColor: Color(0xFF5C4033),
      label: '护眼阅读',
    ),
    _ReaderTheme(
      name: '夜间',
      bgColor: Color(0xFF1A1A1A),
      textColor: Color(0xFFCCCCCC),
      label: '深夜阅读',
    ),
    _ReaderTheme(
      name: '深灰',
      bgColor: Color(0xFF121212),
      textColor: Color(0xFFE0E0E0),
      label: 'OLED 友好',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<NovelProvider>();

    _currentBookId = provider.currentBookId;
    _fontSize = provider.readerFontSize.toDouble();
    _lastFontSize = provider.readerFontSize;

    // Restore reading progress
    if (widget.initialChapterId != null) {
      _currentIndex = provider.chapters.indexWhere(
          (c) => c.id == widget.initialChapterId);
    } else if (provider.currentChapterId != null) {
      _currentIndex = provider.chapters.indexWhere(
          (c) => c.id == provider.currentChapterId);
    }
    if (_currentIndex < 0) _currentIndex = 0;

    _pageController = PageController(initialPage: _currentIndex);

    final chapters = provider.chapters;
    if (_currentIndex < chapters.length) {
      _lastChapterId = chapters[_currentIndex].id;
    } else if (chapters.isNotEmpty) {
      _lastChapterId = chapters.first.id;
    }
  }

  @override
  void dispose() {
    _saveCurrentScrollPosition();
    if (_currentBookId != null && _lastChapterId != null && _currentScrollController != null) {
      _persistScrollPosition(_currentBookId!, _lastChapterId!, _currentScrollController!);
    }
    if (_lastChapterId != null) {
      final provider = context.read<NovelProvider>();
      provider.updateReaderState(
        chapterId: _lastChapterId,
        fontSize: _lastFontSize,
      );
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _persistScrollPosition(String bookId, int chapterId, ScrollController controller) async {
    try {
      final maxExtent = controller.position.maxScrollExtent;
      if (maxExtent <= 0) return;
      final fraction = (controller.offset / maxExtent).clamp(0.0, 1.0);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('reader_scroll_${bookId}_$chapterId', fraction);
    } catch (_) {}
  }

  Future<double> _loadScrollFraction(String bookId, int chapterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('reader_scroll_${bookId}_$chapterId') ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  void _saveCurrentScrollPosition() {
    if (_currentBookId != null && _lastChapterId != null && _currentScrollController != null) {
      _persistScrollPosition(_currentBookId!, _lastChapterId!, _currentScrollController!);
    }
  }

  void _onPageChanged(int idx, NovelProvider provider) {
    _saveCurrentScrollPosition();
    setState(() => _currentIndex = idx);
    if (idx < provider.chapters.length) {
      _lastChapterId = provider.chapters[idx].id;
    }
    final chapter = provider.chapters[idx];
    provider.updateReaderState(chapterId: chapter.id);
  }

  void _setCurrentScrollController(ScrollController controller) {
    _currentScrollController = controller;
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ReaderSettingsSheet(
        fontSize: _fontSize,
        lineHeight: _lineHeight,
        selectedThemeIndex: _selectedThemeIndex,
        onFontSizeChanged: (v) {
          setState(() => _fontSize = v);
          context.read<NovelProvider>().updateReaderState(fontSize: v.round());
        },
        onLineHeightChanged: (v) => setState(() => _lineHeight = v),
        onThemeChanged: (idx) => setState(() => _selectedThemeIndex = idx),
      ),
    );
  }

  void _showChapterList(BuildContext context, NovelProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ChapterListSheet(
        chapters: provider.chapters,
        currentIndex: _currentIndex,
        onSelect: (idx) {
          Navigator.pop(ctx);
          _pageController.animateToPage(
            idx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final chapters = provider.chapters;
    final bookId = provider.currentBookId ?? '';
    final theme = _themes[_selectedThemeIndex];

    if (chapters.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.go('/bookshelf'),
          ),
          title: const Text(
            '📖 阅读器',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📖', style: TextStyle(fontSize: 64)),
              SizedBox(height: 16),
              Text(
                '还没有选择小说呢~',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '请先从书架选择一本小说',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.bgColor,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            // Page view
            PageView.builder(
              controller: _pageController,
              itemCount: chapters.length,
              onPageChanged: (idx) => _onPageChanged(idx, provider),
              itemBuilder: (context, index) {
                return _ChapterPage(
                  key: ValueKey('${bookId}_${chapters[index].id}'),
                  chapter: chapters[index],
                  fontSize: _fontSize,
                  lineHeight: _lineHeight,
                  theme: theme,
                  bookId: bookId,
                  onScrollControllerReady: _setCurrentScrollController,
                );
              },
            ),

            // Top bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: _showControls ? 0 : -120,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: (theme.bgColor == const Color(0xFF1A1A1A) ||
                          theme.bgColor == const Color(0xFF121212))
                      ? Colors.black.withOpacity(0.7)
                      : Colors.black.withOpacity(0.85),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: theme.bgColor == const Color(0xFF1A1A1A) ||
                                    theme.bgColor == const Color(0xFF121212)
                                ? Colors.white
                                : Colors.white,
                          ),
                          onPressed: () => context.go('/bookshelf'),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showChapterList(context, provider),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  chapters.isEmpty
                                      ? ''
                                      : '第${_currentIndex + 1}章 · ${chapters[_currentIndex].title}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${_currentIndex + 1} / ${chapters.length}',
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Aa - font settings
                        IconButton(
                          icon: const Text(
                            'Aa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => _showSettingsSheet(context),
                          tooltip: '阅读设置',
                        ),
                        // ≡ - chapter list
                        IconButton(
                          icon: const Icon(Icons.list, color: Colors.white),
                          onPressed: () => _showChapterList(context, provider),
                          tooltip: '章节目录',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: _showControls ? 0 : -160,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: (theme.bgColor == const Color(0xFF1A1A1A) ||
                          theme.bgColor == const Color(0xFF121212))
                      ? Colors.black.withOpacity(0.85)
                      : Colors.black.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress info
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Prev button
                            GestureDetector(
                              onTap: _currentIndex > 0
                                  ? () => _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut)
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _currentIndex > 0
                                      ? Colors.white.withOpacity(0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chevron_left,
                                      color: _currentIndex > 0
                                          ? Colors.white
                                          : Colors.white30,
                                      size: 18,
                                    ),
                                    Text(
                                      '上一章',
                                      style: TextStyle(
                                        color: _currentIndex > 0
                                            ? Colors.white
                                            : Colors.white30,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Progress text
                            Text(
                              '${_currentIndex + 1} / ${chapters.length} · ${chapters.isNotEmpty ? ((_currentIndex + 1) / chapters.length * 100).toStringAsFixed(0) : 0}%',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            // Next button
                            GestureDetector(
                              onTap: _currentIndex < chapters.length - 1
                                  ? () => _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut)
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _currentIndex < chapters.length - 1
                                      ? Colors.white.withOpacity(0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '下一章',
                                      style: TextStyle(
                                        color: _currentIndex < chapters.length - 1
                                            ? Colors.white
                                            : Colors.white30,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: _currentIndex < chapters.length - 1
                                          ? Colors.white
                                          : Colors.white30,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Progress slider
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: AppColors.primaryLight,
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: chapters.isEmpty
                                ? 0
                                : _currentIndex.toDouble(),
                            min: 0,
                            max: (chapters.length - 1).toDouble().clamp(0, double.infinity),
                            divisions: chapters.length > 1 ? chapters.length - 1 : null,
                            onChanged: (v) {
                              _pageController.animateToPage(
                                v.toInt(),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),
                      // Font size controls
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.text_decrease,
                                  color: Colors.white70, size: 20),
                              onPressed: _fontSize > 12
                                  ? () {
                                      setState(() => _fontSize--);
                                      context
                                          .read<NovelProvider>()
                                          .updateReaderState(
                                              fontSize: _fontSize.round());
                                    }
                                  : null,
                              tooltip: '减小字号',
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Aa ${_fontSize.round()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.text_increase,
                                  color: Colors.white70, size: 20),
                              onPressed: _fontSize < 28
                                  ? () {
                                      setState(() => _fontSize++);
                                      context
                                          .read<NovelProvider>()
                                          .updateReaderState(
                                              fontSize: _fontSize.round());
                                    }
                                  : null,
                              tooltip: '增大字号',
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.format_list_bulleted,
                                  color: Colors.white70, size: 20),
                              onPressed: () =>
                                  _showChapterList(context, provider),
                              tooltip: '章节目录',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Chapter Page (content display)
// ============================================================
class _ChapterPage extends StatefulWidget {
  final Chapter chapter;
  final double fontSize;
  final double lineHeight;
  final _ReaderTheme theme;
  final String bookId;
  final void Function(ScrollController) onScrollControllerReady;

  const _ChapterPage({
    super.key,
    required this.chapter,
    required this.fontSize,
    required this.lineHeight,
    required this.theme,
    required this.bookId,
    required this.onScrollControllerReady,
  });

  @override
  State<_ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<_ChapterPage> {
  late ScrollController _scrollController;
  bool _scrollRestored = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    widget.onScrollControllerReady(_scrollController);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _restoreScrollPosition();
    });
  }

  Future<void> _restoreScrollPosition() async {
    if (_scrollRestored) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final fraction = prefs.getDouble(
              'reader_scroll_${widget.bookId}_${widget.chapter.id}') ??
          0.0;
      if (fraction > 0.0 && mounted) {
        _scrollRestored = true;
        final maxExtent = _scrollController.position.maxScrollExtent;
        if (maxExtent > 0) {
          _scrollController.jumpTo(
              (fraction * maxExtent).clamp(0.0, maxExtent));
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = widget.chapter.content
        .split('\n')
        .where((p) => p.trim().isNotEmpty)
        .toList();

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 72,
        bottom: MediaQuery.of(context).padding.bottom + 180,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter title
          Text(
            widget.chapter.title,
            style: TextStyle(
              fontSize: widget.fontSize + 6,
              fontWeight: FontWeight.bold,
              color: widget.theme.textColor,
              height: 1.4,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 24),

          // Paragraphs
          ...paragraphs.map((paragraph) => Padding(
                padding: EdgeInsets.only(bottom: widget.lineHeight * 8),
                child: Text(
                  paragraph.trim(),
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: widget.theme.textColor,
                    height: widget.lineHeight,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              )),
        ],
      ),
    );
  }
}

// ============================================================
// Reader Settings Sheet (v5.0)
// ============================================================
class _ReaderSettingsSheet extends StatefulWidget {
  final double fontSize;
  final double lineHeight;
  final int selectedThemeIndex;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onLineHeightChanged;
  final ValueChanged<int> onThemeChanged;

  const _ReaderSettingsSheet({
    required this.fontSize,
    required this.lineHeight,
    required this.selectedThemeIndex,
    required this.onFontSizeChanged,
    required this.onLineHeightChanged,
    required this.onThemeChanged,
  });

  @override
  State<_ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<_ReaderSettingsSheet> {
  late double _fontSize;
  late double _lineHeight;
  late int _selectedThemeIndex;

  static const List<_ReaderTheme> _themes = [
    _ReaderTheme(
      name: '白纸',
      bgColor: Color(0xFFFAFAFA),
      textColor: Color(0xFF1F2937),
      label: '日间阅读',
    ),
    _ReaderTheme(
      name: '羊皮',
      bgColor: Color(0xFFF5F0E1),
      textColor: Color(0xFF5C4033),
      label: '护眼阅读',
    ),
    _ReaderTheme(
      name: '夜间',
      bgColor: Color(0xFF1A1A1A),
      textColor: Color(0xFFCCCCCC),
      label: '深夜阅读',
    ),
    _ReaderTheme(
      name: '深灰',
      bgColor: Color(0xFF121212),
      textColor: Color(0xFFE0E0E0),
      label: 'OLED 友好',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fontSize = widget.fontSize;
    _lineHeight = widget.lineHeight;
    _selectedThemeIndex = widget.selectedThemeIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[_selectedThemeIndex];

    return Container(
      decoration: BoxDecoration(
        color: theme.bgColor == const Color(0xFF1A1A1A) ||
                theme.bgColor == const Color(0xFF121212)
            ? const Color(0xFF2A2A2A)
            : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Center(
              child: Text(
                '═══ 阅读设置 ═══',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Font size
            Row(
              children: [
                Text(
                  '字号',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '当前：${_fontSize.round()} 号',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('A', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.divider,
                      thumbColor: AppColors.primary,
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _fontSize,
                      min: 12,
                      max: 28,
                      divisions: 16,
                      onChanged: (v) {
                        setState(() => _fontSize = v);
                        widget.onFontSizeChanged(v);
                      },
                    ),
                  ),
                ),
                const Text('A', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),

            // Theme selection
            Text(
              '主题',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _themes.length; i++)
                  _ThemeCard(
                    theme: _themes[i],
                    isSelected: _selectedThemeIndex == i,
                    onTap: () {
                      setState(() => _selectedThemeIndex = i);
                      widget.onThemeChanged(i);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Theme labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _themes.length; i++)
                  Text(
                    _themes[i].name,
                    style: TextStyle(
                      fontSize: 11,
                      color: _selectedThemeIndex == i
                          ? AppColors.primary
                          : theme.textColor.withOpacity(0.5),
                      fontWeight: _selectedThemeIndex == i
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),

            // Line height
            Row(
              children: [
                Text(
                  '行间距',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '当前：${_lineHeight.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '紧凑',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textColor.withOpacity(0.5),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.secondary,
                      inactiveTrackColor: AppColors.divider,
                      thumbColor: AppColors.secondary,
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _lineHeight,
                      min: 1.2,
                      max: 2.0,
                      divisions: 8,
                      onChanged: (v) {
                        setState(() => _lineHeight = v);
                        widget.onLineHeightChanged(v);
                      },
                    ),
                  ),
                ),
                Text(
                  '舒适',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final _ReaderTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: theme.bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '文',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Chapter List Sheet (v5.0)
// ============================================================
class _ChapterListSheet extends StatelessWidget {
  final List<Chapter> chapters;
  final int currentIndex;
  final void Function(int) onSelect;

  const _ChapterListSheet({
    required this.chapters,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('📖', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      '章节目录',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${chapters.length} 章',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.divider, height: 1),

          // Quick jump
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Text(
                  '─── 快速跳转 ──────────────────',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Chapter list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: chapters.length,
              itemBuilder: (_, idx) {
                final chapter = chapters[idx];
                final isCurrent = idx == currentIndex;
                return GestureDetector(
                  onTap: () => onSelect(idx),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primary.withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isCurrent
                          ? Border.all(color: AppColors.primary.withOpacity(0.2))
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Chapter indicator
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              color: isCurrent ? Colors.white : AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter.title,
                                style: TextStyle(
                                  fontWeight:
                                      isCurrent ? FontWeight.bold : FontWeight.normal,
                                  color: isCurrent
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (chapter.hasGraph)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.auto_graph,
                                      size: 12,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '有图谱',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        // Current indicator
                        if (isCurrent)
                          const Icon(
                            Icons.play_arrow,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        // Graph indicator
                        if (!isCurrent && chapter.hasGraph)
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.success,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Reader Theme Data
// ============================================================
class _ReaderTheme {
  final String name;
  final Color bgColor;
  final Color textColor;
  final String label;

  const _ReaderTheme({
    required this.name,
    required this.bgColor,
    required this.textColor,
    required this.label,
  });
}
