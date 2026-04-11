import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../import/import_screen.dart';
import '../reader/reader_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final hasNovel = provider.chapters.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.currentBookId != null && provider.chapters.isNotEmpty
              ? provider.bookshelf.firstWhere((b) => b.id == provider.currentBookId, orElse: () => provider.bookshelf.first).title
              : '小说续写器',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.deepPurple.shade50,
        actions: [
          if (hasNovel)
            IconButton(
              icon: const Icon(Icons.menu_book),
              tooltip: '阅读小说',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReaderScreen()),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 状态概览
          if (hasNovel) ...[
            _StatusCard(provider: provider),
            const SizedBox(height: 16),
          ],

          // 空状态提示
          if (!hasNovel && provider.currentBookId == null) ...[
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.library_books, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    '还没有选中的小说',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '请到「书架」导入或选择一本小说',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.library_books),
                    label: const Text('去书架'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B6914),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      try {
                        DefaultTabController.of(context).animateTo(0);
                      } catch (_) {}
                    },
                  ),
                ],
              ),
            ),
          ],

          // 小说导入（始终显示）
          _QuickActionCard(
            icon: Icons.file_upload,
            title: '导入小说',
            subtitle: hasNovel
                ? '已导入 ${provider.chapters.length} 章 · 点击重新导入'
                : '从 TXT 文件导入小说',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImportScreen()),
              );
            },
          ),
          const SizedBox(height: 10),

          // 一键续写
          _QuickActionCard(
            icon: Icons.play_arrow_rounded,
            title: '一键续写',
            subtitle: hasNovel
                ? '从基准章节开始 AI 续写'
                : '请先导入小说',
            color: Colors.orange,
            enabled: hasNovel,
            onTap: hasNovel
                ? () => _scrollToWriteTab(context)
                : null,
          ),
          const SizedBox(height: 10),

          // 批量生成图谱
          _QuickActionCard(
            icon: Icons.account_tree,
            title: '生成知识图谱',
            subtitle: hasNovel
                ? '${provider.chapterGraphMap.length}/${provider.chapters.length} 章已生成'
                : '请先导入小说',
            color: Colors.green,
            enabled: hasNovel && !provider.isGeneratingGraph,
            onTap: hasNovel
                ? () => _showBatchGraphDialog(context, provider)
                : null,
          ),
          const SizedBox(height: 10),

          // 合并图谱
          _QuickActionCard(
            icon: Icons.merge_type,
            title: '合并图谱',
            subtitle: hasNovel
                ? provider.chapterGraphMap.length < provider.chapters.length
                    ? '需先生成全部章节图谱'
                    : '将所有章节图谱合并为全局图谱'
                : '请先导入小说',
            color: Colors.purple,
            enabled: hasNovel &&
                provider.chapterGraphMap.length >= provider.chapters.length &&
                provider.chapterGraphMap.isNotEmpty,
            onTap: hasNovel &&
                    provider.chapterGraphMap.length >= provider.chapters.length
                ? () => _showMergeDialog(context, provider)
                : null,
          ),
          const SizedBox(height: 10),

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
          const SizedBox(height: 10),

          // 导出图谱
          if (hasNovel && provider.chapterGraphMap.isNotEmpty) ...[
            _QuickActionCard(
              icon: Icons.download,
              title: '导出图谱',
              subtitle: '导出 JSON 格式知识图谱',
              color: Colors.grey,
              onTap: () => _exportGraphs(context, provider),
            ),
            const SizedBox(height: 10),

            // 查看全局图谱
            _QuickActionCard(
              icon: Icons.account_tree,
              title: '查看全局图谱',
              subtitle: provider.mergedGraph != null
                  ? '已合并 ${provider.chapterGraphMap.length} 章图谱'
                  : '请先合并图谱',
              color: Colors.purple,
              enabled: provider.mergedGraph != null,
              onTap: provider.mergedGraph != null
                  ? () => Navigator.pushNamed(context, '/graph')
                  : null,
            ),
            const SizedBox(height: 10),

            // 导入图谱
            _QuickActionCard(
              icon: Icons.upload_file,
              title: '导入图谱',
              subtitle: '粘贴 JSON 导入章节图谱',
              color: Colors.blueGrey,
              enabled: hasNovel,
              onTap: hasNovel ? () => _importGraphs(context, provider) : null,
            ),
          ],
        ],
      ),
    );
  }

  /// 切换到续写 Tab（tab index=2）
  void _scrollToWriteTab(BuildContext context) {
    try {
      final tabController = DefaultTabController.of(context);
      tabController.animateTo(3);
    } catch (_) {
      // 没有 DefaultTabController 时降级提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请手动切换到底部导航「续写」Tab'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                Text(
                  '当前小说',
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
