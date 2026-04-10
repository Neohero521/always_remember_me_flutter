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
        showPixelSnackBar(
          context,
          '《${book.title}》无数据，可能解析失败',
          isError: true,
        );
        return;
      }
    } catch (e) {
      if (mounted) {
        showPixelSnackBar(context, '加载失败: $e', isError: true);
      }
      return;
    } finally {
      if (mounted) {
        setState(() => _loadingBookId = null);
      }
    }

    if (mounted) {
      try {
        DefaultTabController.of(context).animateTo(1); // 切换到续写工作台
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.bg,
      appBar: AppBar(
        backgroundColor: GameColors.bg2,
        foregroundColor: GameColors.textLight,
        title: const Text(
          '📚 小说书架',
          style: TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: GameColors.textLight),
      ),
      body: Consumer<NovelProvider>(
        builder: (context, provider, _) {
          final books = provider.bookshelf;

          if (books.isEmpty) {
            return _PixelEmptyState(
              icon: '📚',
              title: '书架空空如也',
              subtitle: '点击下方 + 导入第一本小说',
              action: PixelButton(
                label: '📥 导入小说',
                color: GameColors.blue,
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
            padding: const EdgeInsets.all(12),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final isLoading = _loadingBookId == book.id;
              return _BookCardPixel(
                book: book,
                isLoading: isLoading,
                onTap: () => _selectBook(book),
                onDelete: () => _confirmDelete(context, book),
              );
            },
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImportScreen()),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: GameColors.buttonDecoration(color: GameColors.orange),
          child: const Center(
            child: Text('+', style: TextStyle(
              color: GameColors.textLight,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            )),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, NovelBook book) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: GameColors.dialogDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🗑️ 删除书籍', style: TextStyle(
                color: GameColors.red,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 12,
              )),
              const SizedBox(height: 12),
              Text(
                '确定要删除《${book.title}》吗？\n所有章节和图谱数据将一并删除。',
                style: const TextStyle(color: GameColors.textLight, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    label: '取消',
                    color: GameColors.bg3,
                    onPressed: () => Navigator.pop(ctx, false),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    label: '删除',
                    color: GameColors.red,
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

class _BookCardPixel extends StatelessWidget {
  final NovelBook book;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BookCardPixel({
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
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: GameColors.cardDecoration(),
        child: Row(
          children: [
            // 封面占位
            Container(
              width: 52,
              height: 68,
              decoration: BoxDecoration(
                color: GameColors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: GameColors.orange, width: 2),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: GameColors.orange,
                        ),
                      )
                    : Text(
                        book.title.isNotEmpty ? book.title[0] : '无',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: GameColors.orange,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: GameColors.textLight,
                      fontFamily: 'monospace',
                      fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${book.chapterCount} 章',
                    style: const TextStyle(
                      fontSize: 12,
                      color: GameColors.textMuted,
                    ),
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
                          color: GameColors.textMuted,
                        ),
                      ),
                      if (book.readProgress > 0) ...[
                        const SizedBox(width: 12),
                        // 像素进度条
                        SizedBox(
                          width: 50,
                          child: Row(
                            children: List.generate(5, (i) {
                              final filled = i < (book.readProgress * 5).ceil();
                              return Container(
                                width: 8,
                                height: 12,
                                margin: const EdgeInsets.only(right: 2),
                                decoration: BoxDecoration(
                                  color: filled ? GameColors.green : GameColors.bg3,
                                  border: Border.all(
                                    color: filled ? GameColors.green : GameColors.borderDark,
                                    width: 1,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(book.readProgress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            color: GameColors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: GameColors.borderLight, width: 2),
                  borderRadius: BorderRadius.circular(4),
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

class _PixelEmptyState extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Widget action;

  const _PixelEmptyState({
    required this.icon,
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
            Text(icon, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: GameColors.textLight,
                fontFamily: 'monospace',
                fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: GameColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            action,
          ],
        ),
      ),
    );
  }
}
