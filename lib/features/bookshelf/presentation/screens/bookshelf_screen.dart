import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:always_remember_me/app/theme/colors.dart';
import 'package:always_remember_me/common_ui/widgets/confirm_dialog.dart';
import 'package:always_remember_me/common_ui/widgets/empty_state_view.dart';
import 'package:always_remember_me/common_ui/widgets/loading_indicator.dart';
import 'package:always_remember_me/providers/novel_provider.dart';
import 'package:always_remember_me/models/novel_book.dart';

/// BookshelfScreen v5.0 - BottomNav Tab3: 书架页面
/// Based on UI_DESIGN_v5.md Section 2.1
/// - Novel list with BookCard
/// - Empty state UI
/// - Quick actions bar (when book selected)
/// - Delete confirmation dialog
/// - Book switching
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
            color: isError ? AppColors.error : AppColors.divider,
            width: 2,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, NovelBook book) async {
    final confirm = await showConfirmDialog(
      context: context,
      title: '确认删除',
      message: '确定要删除《${book.title}》吗？\n\n删除后所有章节、图谱、续写记录都将清除。此操作不可恢复。',
      confirmLabel: '确认删除',
      cancelLabel: '取消',
      isDanger: true,
    );
    if (confirm == true && context.mounted) {
      await context.read<NovelProvider>().deleteBook(book.id);
      _showSnackBar('《${book.title}》已删除');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          '📚 我的书架',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined, color: AppColors.primary),
            tooltip: '导入小说',
            onPressed: () => context.push('/import'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onSelected: (v) {
              if (v == 'settings') {
                context.push('/settings');
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(children: [
                  Icon(Icons.settings, size: 18, color: AppColors.textSecondary),
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
            return EmptyStateView(
              icon: Icons.book_outlined,
              title: '书架空空如也~',
              subtitle: '快来导入第一本小说吧！',
              action: ElevatedButton.icon(
                onPressed: () => context.push('/import'),
                icon: const Icon(Icons.file_upload),
                label: const Text('📥 导入小说'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
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
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '─── 我的书架 ──────────────────',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
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
                    ? () => context.go('/reader')
                    : null,
                onDelete: () => _confirmDelete(context, book),
              )),

              const SizedBox(height: 100),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/import'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================
// 快捷操作条 (Quick Actions Bar)
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primaryLight.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_stories, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '当前：${currentBook?.title ?? "未选择"}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickActionBtn(
                emoji: '📖',
                label: '阅读',
                color: AppColors.primary,
                onTap: () => context.go('/reader'),
              ),
              _QuickActionBtn(
                emoji: '✍️',
                label: '续写',
                color: AppColors.secondary,
                onTap: () => context.go('/'),
              ),
              _QuickActionBtn(
                emoji: '🌲',
                label: '图谱',
                color: AppColors.success,
                onTap: () => context.push('/graph'),
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
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 书籍卡片 (BookCard v5.0)
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
        decoration: BoxDecoration(
          color: isCurrentBook
              ? AppColors.primary.withOpacity(0.04)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: isCurrentBook ? AppColors.primary : Colors.transparent,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.divider.withOpacity(0.3),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              splashColor: AppColors.primary.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // 封面占位
                    Container(
                      width: 50,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.15),
                            AppColors.primaryLight.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : Text(
                                book.title.isNotEmpty ? book.title[0] : '无',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '当前',
                                    style: TextStyle(
                                      fontSize: 10,
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
                                    color: isCurrentBook
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
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
                                  color: AppColors.textSecondary,
                                ),
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
                                color: AppColors.primary.withOpacity(0.1),
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
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: const Text('🗑️', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
