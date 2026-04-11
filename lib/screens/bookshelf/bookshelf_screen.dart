import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../models/novel_book.dart';
import '../../theme/game_console_theme.dart';
import '../import/import_screen.dart';

class BookshelfScreen extends StatefulWidget {
  const BookshelfScreen({super.key});

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  String? _loadingBookId;

  Future<void> _selectBook(NovelBook book) async {
    if (_loadingBookId != null) return;

    final provider = context.read<NovelProvider>();
    setState(() => _loadingBookId = book.id);

    try {
      final ok = await provider.selectBook(book.id);
      if (!ok && mounted) {
        showCuteSnackBar(
          context,
          '《${book.title}》无数据，可能解析失败',
          isError: true,
        );
        return;
      }
    } catch (e) {
      if (mounted) {
        showCuteSnackBar(context, '加载失败: $e', isError: true);
      }
      return;
    } finally {
      if (mounted) setState(() => _loadingBookId = null);
    }

    if (mounted) {
      try {
        DefaultTabController.of(context).animateTo(1);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CutePixelColors.bg,
      appBar: AppBar(
        backgroundColor: CutePixelColors.bg2,
        foregroundColor: CutePixelColors.text,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📚', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              '我的书架',
              style: TextStyle(
                fontFamily: 'monospace',
                fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: CutePixelColors.text),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Consumer<NovelProvider>(
        builder: (context, provider, _) {
          final books = provider.bookshelf;

          if (books.isEmpty) {
            return _CuteEmptyState(
              emoji: '📚',
              title: '书架空空如也~',
              subtitle: '快来导入第一本小说吧！',
              action: CutePixelButton(
                label: '导入小说',
                emoji: '📥',
                color: CutePixelColors.pink,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ImportScreen()),
                  );
                },
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final isLoading = _loadingBookId == book.id;
              return _CuteBookCard(
                book: book,
                isLoading: isLoading,
                onTap: () => _selectBook(book),
                onDelete: () => _confirmDelete(context, book),
              );
            },
          );
        },
      ),
      floatingActionButton: _CuteFAB(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImportScreen()),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, NovelBook book) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: CutePixelColors.dialogDecoration(),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💔', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              const Text(
                '确定删除本书？',
                style: TextStyle(
                  color: CutePixelColors.text,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '《${book.title}》\n所有章节和图谱数据将一并删除',
                style: const TextStyle(
                  color: CutePixelColors.textMuted,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CutePixelButton(
                    label: '取消',
                    color: CutePixelColors.bg3,
                    onPressed: () => Navigator.pop(ctx, false),
                  ),
                  CutePixelButton(
                    label: '删除',
                    color: CutePixelColors.coral,
                    onPressed: () => Navigator.pop(ctx, true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirm == true && context.mounted) {
      await context.read<NovelProvider>().deleteBook(book.id);
    }
  }
}

class _CuteBookCard extends StatelessWidget {
  final NovelBook book;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CuteBookCard({
    required this.book,
    required this.isLoading,
    required this.onTap,
    required this.onDelete,
  });

  String _formatTime(DateTime? dt) {
    if (dt == null) return '从未阅读';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}月前';
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    return '刚刚';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: CutePixelColors.cardDecoration(),
        child: Row(
          children: [
            // 封面
            Container(
              width: 56,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CutePixelColors.pink.withOpacity(0.3),
                    CutePixelColors.lavender.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CutePixelColors.borderDark, width: 2),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: CutePixelColors.pink,
                        ),
                      )
                    : Text(
                        book.title.isNotEmpty ? book.title[0] : '无',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CutePixelColors.lavender,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CutePixelColors.text,
                      fontFamily: 'monospace',
                      fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${book.chapterCount} 章',
                        style: const TextStyle(
                          fontSize: 12,
                          color: CutePixelColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('🕐', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(book.lastReadAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: CutePixelColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (book.readProgress > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CutePixelProgressBar(
                          progress: book.readProgress,
                          blocks: 6,
                          filledColor: CutePixelColors.mint,
                          emptyColor: CutePixelColors.bg3,
                          blockWidth: 12,
                          blockHeight: 10,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(book.readProgress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            color: CutePixelColors.mint,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CutePixelColors.bg3,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CutePixelColors.borderDark, width: 2),
                ),
                child: const Text('🗑️', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CuteEmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget action;

  const _CuteEmptyState({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: CutePixelColors.text,
                fontFamily: 'monospace',
                fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                color: CutePixelColors.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 28),
            action,
          ],
        ),
      ),
    );
  }
}

class _CuteFAB extends StatelessWidget {
  final VoidCallback onTap;

  const _CuteFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [CutePixelColors.pink, CutePixelColors.lavender],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: CutePixelColors.borderDark, width: 2),
          boxShadow: const [
            BoxShadow(color: CutePixelColors.borderLight, offset: Offset(-3, -3)),
            BoxShadow(color: CutePixelColors.shadowColor, offset: Offset(3, 3)),
          ],
        ),
        child: const Center(
          child: Text('➕', style: TextStyle(fontSize: 26)),
        ),
      ),
    );
  }
}
