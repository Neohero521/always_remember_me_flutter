import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../models/novel_book.dart';
import '../../theme/game_console_theme.dart';
import '../import/import_screen.dart';
import '../reader/reader_screen.dart';

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
  }

  /// Open reader directly from book
  void _openReader(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReaderScreen()),
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
        actions: [
          PopupMenuButton<String>(
            icon: const Text('⋮', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            onSelected: (v) {
              if (v == 'settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (v == 'import') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportScreen()));
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'import', child: Row(children: [Icon(Icons.file_upload, size: 18), SizedBox(width: 8), Text('导入小说')])),
              const PopupMenuItem(value: 'settings', child: Row(children: [Icon(Icons.settings, size: 18), SizedBox(width: 8), Text('设置')])),
            ],
          ),
        ],
      ),
      body: Consumer<NovelProvider>(
        builder: (context, provider, _) {
          final books = provider.bookshelf;
          final hasNovel = provider.chapters.isNotEmpty;

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

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // === 快捷操作区（选中书籍后显示）===
              if (hasNovel) ...[
                _QuickActionsSection(provider: provider),
                const SizedBox(height: 16),
              ],

              // === 书架列表 ===
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '📖 书架 (${0})',  // placeholder; updated below
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: CutePixelColors.textMuted,
                  ),
                ),
              ),
              ...books.map((book) => _CuteBookCard(
                book: book,
                isLoading: _loadingBookId == book.id,
                isCurrentBook: provider.currentBookId == book.id,
                onTap: () => _selectBook(book),
                onRead: hasNovel && provider.currentBookId == book.id
                    ? () => _openReader(context)
                    : null,
                onDelete: () => _confirmDelete(context, book),
              )),
            ],
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
}

/// 快捷操作区：选中书籍后显示的快速操作入口
class _QuickActionsSection extends StatelessWidget {
  final NovelProvider provider;

  const _QuickActionsSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    final hasNovel = provider.chapters.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 状态概览
        _StatusCard(provider: provider),
        const SizedBox(height: 12),

        // 操作入口
        if (hasNovel) ...[
          // 阅读入口
          _QuickActionCard(
            icon: Icons.menu_book,
            title: '阅读小说',
            subtitle: '${provider.chapters.length} 章 · 点击继续阅读',
            color: Colors.deepPurple,
            enabled: hasNovel,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReaderScreen()),
              );
            },
          ),
          const SizedBox(height: 8),

          // 一键续写
          _QuickActionCard(
            icon: Icons.play_arrow_rounded,
            title: '一键续写',
            subtitle: '从基准章节开始 AI 续写 ${provider.writeWordCount} 字',
            color: Colors.orange,
            enabled: hasNovel,
            onTap: () {
              try {
                DefaultTabController.of(context).animateTo(1);
              } catch (_) {}
            },
          ),
          const SizedBox(height: 8),

          // 批量生成图谱
          _QuickActionCard(
            icon: Icons.account_tree,
            title: '生成知识图谱',
            subtitle: '${provider.chapterGraphMap.length}/${provider.chapters.length} 章已生成',
            color: Colors.green,
            enabled: hasNovel && !provider.isGeneratingGraph,
            onTap: () => _showBatchGraphDialog(context, provider),
          ),
          const SizedBox(height: 8),

          // 合并图谱
          _QuickActionCard(
            icon: Icons.merge_type,
            title: '合并图谱',
            subtitle: provider.chapterGraphMap.length < provider.chapters.length
                ? '需先生成全部章节图谱'
                : '将所有章节图谱合并为全局图谱',
            color: Colors.purple,
            enabled: hasNovel &&
                provider.chapterGraphMap.length >= provider.chapters.length &&
                provider.chapterGraphMap.isNotEmpty,
            onTap: hasNovel &&
                    provider.chapterGraphMap.length >= provider.chapters.length
                ? () => _showMergeDialog(context, provider)
                : null,
          ),
          const SizedBox(height: 8),

          // 续写链条
          _QuickActionCard(
            icon: Icons.link,
            title: '续写链条',
            subtitle: provider.continueChain.isEmpty
                ? '暂无续写章节'
                : '${provider.continueChain.length} 个续写章节',
            color: Colors.teal,
            enabled: provider.continueChain.isNotEmpty,
            onTap: provider.continueChain.isNotEmpty
                ? () => _showContinueChainSheet(context, provider)
                : null,
          ),

          // 图谱操作（展开/收起）
          if (provider.chapterGraphMap.isNotEmpty) ...[
            const SizedBox(height: 8),
            _QuickActionCard(
              icon: Icons.download,
              title: '导出/导入图谱',
              subtitle: 'JSON 格式知识图谱管理',
              color: Colors.blueGrey,
              enabled: hasNovel,
              onTap: () => _showGraphManagementSheet(context, provider),
            ),
          ],
        ],
      ],
    );
  }

  void _showBatchGraphDialog(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('批量生成图谱'),
        content: Text(
          '将为全部 ${provider.chapters.length} 个章节生成知识图谱，'
          '预计需要 ${provider.chapters.length * 2 ~/ 1} 秒。\n\n'
          '是否继续？',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.generateGraphsForAllChapters();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已开始批量生成图谱...')),
              );
            },
            child: const Text('开始'),
          ),
        ],
      ),
    );
  }

  void _showMergeDialog(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('合并图谱'),
        content: const Text(
          '将所有章节图谱合并为全局知识图谱，用于续写时的上下文参考。\n\n'
          '先分批合并（每批50章），再合并为全量图谱。',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('开始分批合并图谱...')),
              );
              await provider.batchMergeGraphs();
              if (context.mounted && provider.batchMergedGraphs.isNotEmpty) {
                await provider.mergeAllGraphs();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('图谱合并完成！')),
                  );
                }
              }
            },
            child: const Text('开始合并'),
          ),
        ],
      ),
    );
  }

  void _showContinueChainSheet(BuildContext context, NovelProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('续写链条 (${provider.continueChain.length})',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                            label: const Text('清空', style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              provider.clearContinueChain();
                              Navigator.pop(ctx);
                            },
                          ),
                          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: provider.continueChain.length,
                      itemBuilder: (_, i) {
                        final c = provider.continueChain[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              c.content.length > 80
                                  ? '${c.content.substring(0, 80)}...'
                                  : c.content,
                              maxLines: 2,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showGraphManagementSheet(BuildContext context, NovelProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('图谱管理',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // 查看全局图谱
                        if (provider.mergedGraph != null)
                          ListTile(
                            leading: const Icon(Icons.account_tree, color: Colors.purple),
                            title: const Text('查看全局图谱'),
                            subtitle: Text('已合并 ${provider.chapterGraphMap.length} 章图谱'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.pushNamed(context, '/graph');
                            },
                          ),
                        ListTile(
                          leading: const Icon(Icons.download, color: Colors.blueGrey),
                          title: const Text('导出图谱'),
                          subtitle: const Text('复制 JSON 格式知识图谱'),
                          onTap: () {
                            Navigator.pop(ctx);
                            _exportGraphs(context, provider);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.upload_file, color: Colors.teal),
                          title: const Text('导入图谱'),
                          subtitle: const Text('粘贴 JSON 导入章节图谱'),
                          onTap: () {
                            Navigator.pop(ctx);
                            _importGraphs(context, provider);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _exportGraphs(BuildContext context, NovelProvider provider) {
    final json = provider.exportChapterGraphsJson();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('图谱数据'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(
            child: SelectableText(
              json.length > 2000 ? '${json.substring(0, 2000)}...' : json,
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _importGraphs(BuildContext context, NovelProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('导入图谱'),
        content: SizedBox(
          width: double.maxFinite,
          height: 350,
          child: Column(
            children: [
              const Text(
                '请粘贴从「导出图谱」复制的内容（JSON格式）：',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  decoration: const InputDecoration(
                    hintText: '{"exportTime": "...", "chapterGraphMap": {...}}',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('内容不能为空')),
                );
                return;
              }
              try {
                provider.importChapterGraphsJson(text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('图谱导入成功！')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('JSON格式错误: $e')),
                );
              }
            },
            child: const Text('导入'),
          ),
        ],
      ),
    );
  }
}

/// 状态概览卡片
class _StatusCard extends StatelessWidget {
  final NovelProvider provider;

  const _StatusCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_stories, color: Colors.deepPurple.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    provider.currentBookId != null
                        ? provider.bookshelf
                            .firstWhere(
                              (b) => b.id == provider.currentBookId,
                              orElse: () => provider.bookshelf.first,
                            )
                            .title
                        : '当前小说',
                    style: TextStyle(
                      color: Colors.deepPurple.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: '章节', value: '${provider.chapters.length}'),
                _StatItem(label: '图谱', value: '${provider.chapterGraphMap.length}'),
                _StatItem(label: '续写', value: '${provider.continueChain.length}'),
                _StatItem(
                  label: '合并',
                  value: provider.mergedGraph != null ? '✅' : '❌',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}

/// 快捷操作卡片
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool enabled;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: enabled ? 1 : 0,
      color: enabled ? Colors.white : Colors.grey.shade100,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: enabled ? color.withOpacity(0.1) : Colors.grey.shade200,
          child: Icon(icon, color: enabled ? color : Colors.grey, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: enabled ? Colors.black87 : Colors.grey,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: enabled ? Colors.grey.shade600 : Colors.grey, fontSize: 13),
        ),
        trailing: enabled ? Icon(Icons.chevron_right, color: Colors.grey.shade400) : null,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}

class _CuteBookCard extends StatelessWidget {
  final NovelBook book;
  final bool isLoading;
  final bool isCurrentBook;
  final VoidCallback onTap;
  final VoidCallback? onRead;
  final VoidCallback onDelete;

  const _CuteBookCard({
    required this.book,
    required this.isLoading,
    required this.isCurrentBook,
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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: CutePixelColors.cardDecoration().copyWith(
          border: isCurrentBook
              ? Border.all(color: CutePixelColors.lavender, width: 2)
              : null,
        ),
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
                  // 书名（点击阅读）
                  GestureDetector(
                    onTap: onRead,
                    child: Row(
                      children: [
                        if (isCurrentBook)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: CutePixelColors.lavender,
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
                              color: isCurrentBook ? CutePixelColors.lavender : CutePixelColors.text,
                              fontFamily: 'monospace',
                              fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
                              decoration: onRead != null ? TextDecoration.underline : null,
                              decorationColor: CutePixelColors.lavender,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
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
            // 操作区
            Column(
              children: [
                if (onRead != null)
                  GestureDetector(
                    onTap: onRead,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CutePixelColors.lavender.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: CutePixelColors.borderDark, width: 2),
                      ),
                      child: const Text('📖', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                if (onRead != null) const SizedBox(height: 6),
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
