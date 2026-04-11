import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../theme/game_console_theme.dart';
import '../../app/router.dart';

/// 图谱状态 Tab
class GraphStatusTab extends StatelessWidget {
  const GraphStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();
    final hasNovel = provider.chapters.isNotEmpty;
    final totalChapters = provider.chapters.length;
    final generatedCount = provider.chapterGraphMap.length;
    final hasMergedGraph = provider.mergedGraph != null;

    if (!hasNovel) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_tree, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('还没有书籍', style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.file_upload),
              label: const Text('去导入小说'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.import),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 图谱生成进度
        _GraphProgressCard(
          generatedCount: generatedCount,
          totalCount: totalChapters,
          onGenerateTap: () => _showBatchGraphDialog(context, provider),
          onMergeTap: () => _showMergeDialog(context, provider),
          onViewTap: () => Navigator.pushNamed(context, AppRoutes.graph),
        ),
        const SizedBox(height: 12),

        // 全局图谱状态
        _MergedGraphCard(
          hasMergedGraph: hasMergedGraph,
          chapterCount: generatedCount,
          onViewTap: () => Navigator.pushNamed(context, AppRoutes.graph),
          onMergeTap: () => _showMergeDialog(context, provider),
        ),
        const SizedBox(height: 12),

        // 章节图谱列表
        _ChapterGraphList(
          chapters: provider.chapters,
          graphMap: provider.chapterGraphMap,
          onGenerateChapterGraph: (chapterId) => _generateChapterGraph(context, provider, chapterId),
        ),
      ],
    );
  }

  void _showBatchGraphDialog(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('批量生成图谱'),
        content: Text('将为 ${provider.chapters.length} 个章节生成知识图谱，是否继续？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _runBatchGraphGeneration(context, provider);
            },
            child: const Text('开始生成'),
          ),
        ],
      ),
    );
  }

  Future<void> _runBatchGraphGeneration(BuildContext context, NovelProvider provider) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('开始批量生成图谱...')),
    );
    // 逐章生成
    for (final chapter in provider.chapters) {
      if (!provider.chapterGraphMap.containsKey(chapter.id)) {
        await provider.generateGraphForChapter(chapter.id);
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('批量图谱生成完成！共 ${provider.chapterGraphMap.length} 个章节')),
      );
    }
  }

  void _showMergeDialog(BuildContext context, NovelProvider provider) {
    if (provider.chapterGraphMap.length < provider.chapters.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请先生成全部 ${provider.chapters.length} 章的图谱（当前 ${provider.chapterGraphMap.length} 章）')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('合并全局图谱'),
        content: const Text('将所有章节图谱合并为全局图谱？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.mergeAllGraphs();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('全局图谱合并完成！')),
                );
              }
            },
            child: const Text('确认合并'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateChapterGraph(BuildContext context, NovelProvider provider, int chapterId) async {
    await provider.generateGraphForChapter(chapterId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('图谱生成完成！')),
      );
    }
  }
}

class _GraphProgressCard extends StatelessWidget {
  final int generatedCount;
  final int totalCount;
  final VoidCallback onGenerateTap;
  final VoidCallback onMergeTap;
  final VoidCallback onViewTap;

  const _GraphProgressCard({
    required this.generatedCount,
    required this.totalCount,
    required this.onGenerateTap,
    required this.onMergeTap,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? generatedCount / totalCount : 0.0;
    final canMerge = generatedCount >= totalCount && totalCount > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🌲 图谱生成进度', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Text(
                  '$generatedCount / $totalCount',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: generatedCount >= totalCount ? Colors.green : CutePixelColors.lavender,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: generatedCount < totalCount ? onGenerateTap : null,
                    icon: const Icon(Icons.auto_graph, size: 16),
                    label: const Text('批量生成'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: canMerge ? onMergeTap : null,
                    icon: const Icon(Icons.merge_type, size: 16),
                    label: const Text('合并图谱'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      foregroundColor: Colors.purple,
                    ),
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

class _MergedGraphCard extends StatelessWidget {
  final bool hasMergedGraph;
  final int chapterCount;
  final VoidCallback onViewTap;
  final VoidCallback onMergeTap;

  const _MergedGraphCard({
    required this.hasMergedGraph,
    required this.chapterCount,
    required this.onViewTap,
    required this.onMergeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: hasMergedGraph ? Colors.purple.shade50 : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasMergedGraph ? Icons.check_circle : Icons.info_outline,
                  color: hasMergedGraph ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text('全局图谱', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                if (hasMergedGraph)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '✅ 已合并',
                      style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasMergedGraph
                  ? '已合并 $chapterCount 个章节图谱'
                  : '需要先生成全部章节图谱后再合并',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: hasMergedGraph ? onViewTap : null,
                    icon: const Icon(Icons.account_tree, size: 16),
                    label: const Text('查看图谱'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      foregroundColor: Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: hasMergedGraph ? onMergeTap : null,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('重新合并'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      foregroundColor: Colors.orange,
                    ),
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

class _ChapterGraphList extends StatelessWidget {
  final List<dynamic> chapters;
  final Map<int, dynamic> graphMap;
  final Future<void> Function(int chapterId) onGenerateChapterGraph;

  const _ChapterGraphList({
    required this.chapters,
    required this.graphMap,
    required this.onGenerateChapterGraph,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text('📖 章节图谱详情', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 8),
        ...chapters.map((chapter) {
          final hasGraph = graphMap.containsKey(chapter.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              dense: true,
              leading: Icon(
                hasGraph ? Icons.check_circle : Icons.circle_outlined,
                color: hasGraph ? Colors.green : Colors.grey,
                size: 18,
              ),
              title: Text(
                chapter.title,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                hasGraph ? '✅ 已生成图谱' : '⚠️ 暂无图谱',
                style: TextStyle(
                  fontSize: 12,
                  color: hasGraph ? Colors.green : Colors.orange,
                ),
              ),
              trailing: hasGraph
                  ? const Icon(Icons.account_tree, color: Colors.green, size: 18)
                  : IconButton(
                      icon: const Icon(Icons.auto_graph, size: 18),
                      color: Colors.green,
                      onPressed: () => onGenerateChapterGraph(chapter.id),
                    ),
            ),
          );
        }),
      ],
    );
  }
}
