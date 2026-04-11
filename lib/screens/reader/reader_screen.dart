import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../models/chapter.dart';

/// 小说阅读界面 - 舒适阅读 + 章节导航 + 字号控制
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
  int? _lastChapterId;  // 缓存退出时要保存的章节 ID
  int? _lastFontSize;  // 缓存退出时要保存的字号

  @override
  void initState() {
    super.initState();
    final provider = context.read<NovelProvider>();

    // 恢复阅读进度
    if (widget.initialChapterId != null) {
      _currentIndex = provider.chapters.indexWhere(
          (c) => c.id == widget.initialChapterId);
    } else if (provider.currentChapterId != null) {
      _currentIndex = provider.chapters.indexWhere(
          (c) => c.id == provider.currentChapterId);
    }
    if (_currentIndex < 0) _currentIndex = 0;

    _pageController = PageController(initialPage: _currentIndex);

    // 缓存退出时保存用的信息（避免 dispose 中访问 context）
    final chapters = provider.chapters;
    if (_currentIndex < chapters.length) {
      _lastChapterId = chapters[_currentIndex].id;
    } else if (chapters.isNotEmpty) {
      _lastChapterId = chapters.first.id;
    }
    _lastFontSize = provider.readerFontSize;
  }

  @override
  void dispose() {
    // 使用缓存的值保存阅读进度，完全不依赖 dispose 时的 context
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

  void _onPageChanged(int idx, NovelProvider provider) {
    setState(() => _currentIndex = idx);
    // 同步更新缓存
    if (idx < provider.chapters.length) {
      _lastChapterId = provider.chapters[idx].id;
    }
    // 保存阅读进度
    final chapter = provider.chapters[idx];
    provider.updateReaderState(chapterId: chapter.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final chapters = provider.chapters;
    final fontSize = provider.readerFontSize;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            // 页面视图
            PageView.builder(
              controller: _pageController,
              itemCount: chapters.length,
              onPageChanged: (idx) => _onPageChanged(idx, provider),
              itemBuilder: (context, index) {
                return _ChapterPage(
                  chapter: chapters[index],
                  fontSize: fontSize,
                );
              },
            ),

            // 顶部导航栏
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _showControls ? 0 : -100,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          chapters.isEmpty
                              ? ''
                              : chapters[_currentIndex].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.list, color: Colors.white),
                        onPressed: () => _showChapterList(context, provider),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 底部控制栏
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: _showControls ? 0 : -160,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 进度信息
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '第 ${_currentIndex + 1} / ${chapters.length} 章',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              chapters.isEmpty
                                  ? ''
                                  : '${chapters[_currentIndex].content.length} 字',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 进度滑块
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.deepPurple.shade300,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.deepPurple.shade200,
                            trackHeight: 3,
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

                      // 字号控制
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.text_decrease,
                                  color: Colors.white70),
                              onPressed: fontSize > 12
                                  ? () => provider.updateReaderState(
                                      fontSize: fontSize - 1)
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
                                'Aa $fontSize',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.text_increase,
                                  color: Colors.white70),
                              onPressed: fontSize < 28
                                  ? () => provider.updateReaderState(
                                      fontSize: fontSize + 1)
                                  : null,
                              tooltip: '增大字号',
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

  void _showChapterList(BuildContext context, NovelProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '目录 (${provider.chapters.length} 章)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.chapters.length,
                  itemBuilder: (_, idx) {
                    final chapter = provider.chapters[idx];
                    final isCurrent = idx == _currentIndex;
                    return ListTile(
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent
                              ? Colors.deepPurple
                              : Colors.grey.shade300,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      title: Text(
                        chapter.title,
                        style: TextStyle(
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isCurrent ? Colors.deepPurple : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: chapter.hasGraph
                          ? const Icon(Icons.auto_graph,
                              size: 18, color: Colors.green)
                          : null,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pageController.animateToPage(
                          idx,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 单个章节页面（支持字号）
class _ChapterPage extends StatelessWidget {
  final Chapter chapter;
  final int fontSize;

  const _ChapterPage({required this.chapter, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 60,
        bottom: MediaQuery.of(context).padding.bottom + 180,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 章节标题
          Text(
            chapter.title,
            style: TextStyle(
              fontSize: fontSize + 5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2C2C),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // 章节内容（分段）
          ...chapter.content
              .split('\n')
              .where((p) => p.trim().isNotEmpty)
              .map((paragraph) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      paragraph.trim(),
                      style: TextStyle(
                        fontSize: fontSize.toDouble(),
                        color: const Color(0xFF3C3C3C),
                        height: 1.8,
                        letterSpacing: 0.3,
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
