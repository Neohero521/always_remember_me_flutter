import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../models/novel_book.dart';
import '../../theme/v4_colors.dart';
import '../import/import_screen.dart';
import '../reader/reader_screen.dart';

/// BookshelfScreen v4.0 - BottomNav Tab3: 书架页面
/// 简化设计：书籍列表 + 导入入口
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
        _showSnackBar('《${book.title}》无数据，可能解析失败', isError: true);
        return;
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('加载失败: $e', isError: true);
      }
      return;
    } finally {
      if (mounted) setState(() => _loadingBookId = null);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(isError ? '💔' : '💖', style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isError ? V4Colors.error : V4Colors.divider,
            width: 2,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, NovelBook book) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('🗑️ ', style: TextStyle(fontSize: 24)),
            Text('确认删除'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要删除《${book.title}》吗？'),
            const SizedBox(height: 8),
            Text(
              '删除后所有章节、图谱、续写记录都将清除。此操作不可恢复。',
              style: TextStyle(fontSize: 13, color: V4Colors.textSecondary),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: V4Colors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await context.read<NovelProvider>().deleteBook(book.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: V4Colors.background,
      appBar: AppBar(
        title: const Text('📚 我的书架', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: '导入小说',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImportScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (v) {
              if (v == 'settings') {
                Navigator.pushNamed(context, '/settings');
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(children: [
                  Icon(Icons.settings, size: 18),
                  SizedBox(width: 8),
                  Text('设置'),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<NovelProvider>(
        builder: (context, provider, _) {
          final books = provider.bookshelf;
          final hasNovel = provider.chapters.isNotEmpty;

          if (books.isEmpty) {
            return _EmptyState(
              onImport: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImportScreen()),
                );
              },
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // === 快捷操作条（选中书籍后显示）===
              if (hasNovel) ...[
                _QuickActionsBar(provider: provider),
                const SizedBox(height: 16),
              ],

              // === 书架标题 ===
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '📖 我的书架',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: V4Colors.textSecondary,
                  ),
                ),
              ),

              // === 书籍列表 ===
              ...books.map((book) => _BookCard(
                book: book,
                isLoading: _loadingBookId == book.id,
                isCurrentBook: provider.currentBookId == book.id,
                hasNovel: hasNovel,
                onTap: () => _selectBook(book),
                onRead: hasNovel && provider.currentBookId == book.id
                    ? () => _openReader(context)
                    : null,
                onDelete: () => _confirmDelete(context, book),
              )),

              const SizedBox(height: 100),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ImportScreen()),
          );
        },
        backgroundColor: V4Colors.primary,
        foregroundColor: V4Colors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openReader(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReaderScreen()),
    );
  }
}

// ============================================================
// 快捷操作条
// ============================================================
class _QuickActionsBar extends StatelessWidget {
  final NovelProvider provider;

  const _QuickActionsBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final currentBook = provider.currentBookId != null
        ? provider.bookshelf.cast<dynamic>().firstWhere(
            (b) => b.id == provider.currentBookId,
            orElse: () => null,
          )
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: V4Colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories, size: 16, color: V4Colors.primary),
              const SizedBox(width: 8),
              Text(
                '当前：${currentBook?.title ?? "未选择"}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: V4Colors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickActionBtn(
                emoji: '📖',
                label: '阅读',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReaderScreen()),
                  );
                },
              ),
              _QuickActionBtn(
                emoji: '✍️',
                label: '续写',
                onTap: () {
                  // Switch to Write tab
                },
              ),
              _QuickActionBtn(
                emoji: '🌲',
                label: '图谱',
                onTap: () {
                  Navigator.pushNamed(context, '/graph');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _QuickActionBtn({required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: V4Colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: V4Colors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 空状态
// ============================================================
class _EmptyState extends StatelessWidget {
  final VoidCallback onImport;

  const _EmptyState({required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📚', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            const Text(
              '书架空空如也~',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: V4Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '快来导入第一本小说吧！',
              style: TextStyle(fontSize: 14, color: V4Colors.textSecondary),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.file_upload),
              label: const Text('📥 导入小说'),
              style: ElevatedButton.styleFrom(
                backgroundColor: V4Colors.primary,
                foregroundColor: V4Colors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 书籍卡片
// ============================================================
class _BookCard extends StatelessWidget {
  final NovelBook book;
  final bool isLoading;
  final bool isCurrentBook;
  final bool hasNovel;
  final VoidCallback onTap;
  final VoidCallback? onRead;
  final VoidCallback onDelete;

  const _BookCard({
    required this.book,
    required this.isLoading,
    required this.isCurrentBook,
    required this.hasNovel,
    required this.onTap,
    required this.onRead,
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
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: V4Colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: isCurrentBook ? V4Colors.primary : Colors.transparent,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: V4Colors.divider.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            // 封面占位
            Container(
              width: 50,
              height: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    V4Colors.primary.withOpacity(0.2),
                    V4Colors.primaryLight.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: V4Colors.divider),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: V4Colors.primary),
                      )
                    : Text(
                        book.title.isNotEmpty ? book.title[0] : '无',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: V4Colors.primary,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // 信息区
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 书名行
                  Row(
                    children: [
                      if (isCurrentBook)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: V4Colors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '当前',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          book.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCurrentBook ? V4Colors.primary : V4Colors.textPrimary,
                            decoration: onRead != null ? TextDecoration.underline : null,
                            decorationColor: V4Colors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${book.chapterCount} 章',
                        style: TextStyle(fontSize: 12, color: V4Colors.textSecondary),
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
                        style: TextStyle(fontSize: 11, color: V4Colors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 操作区
            Column(
              children: [
                if (onRead != null)
                  GestureDetector(
                    onTap: onRead,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: V4Colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('📖', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                if (onRead != null) const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: V4Colors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: V4Colors.divider),
                    ),
                    child: const Text('🗑️', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
