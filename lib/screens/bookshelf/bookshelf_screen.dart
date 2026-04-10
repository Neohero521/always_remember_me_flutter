import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../import/import_screen.dart';

class BookshelfScreen extends StatelessWidget {
  const BookshelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0E8),
        elevation: 0,
        title: const Text(
          '📚 小说书架',
          style: TextStyle(color: Color(0xFF2C2416)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2C2416)),
      ),
      body: Consumer<NovelProvider>(
        builder: (context, provider, _) {
          final books = provider.bookshelf;

          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '书架空空如也',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击下方 + 导入第一本小说',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return _BookCard(
                book: book,
                onTap: () async {
                  await provider.selectBook(book.id);
                  if (context.mounted) {
                    // 切换到首页 Tab
                    DefaultTabController.of(context).animateTo(1);
                  }
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('删除书籍'),
                      content: Text('确定要删除《${book.title}》吗？所有章节和图谱数据将一并删除。'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('删除', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await provider.deleteBook(book.id);
                  }
                },
              );
            },
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
        backgroundColor: const Color(0xFF8B6914),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final dynamic book;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BookCard({
    required this.book,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 封面占位
              Container(
                width: 56,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6914).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    book.title.isNotEmpty ? book.title[0] : '无',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B6914),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2416),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${book.chapterCount} 章',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(book.lastReadAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        if (book.readProgress > 0) ...[
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 60,
                            child: LinearProgressIndicator(
                              value: book.readProgress,
                              backgroundColor: Colors.grey.shade200,
                              color: const Color(0xFF8B6914),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(book.readProgress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // 删除按钮
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.grey.shade400),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
