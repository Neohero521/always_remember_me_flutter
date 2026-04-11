import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../models/chapter.dart';

/// 续写链条 Tab
class ChainTab extends StatelessWidget {
  const ChainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();

    return Column(
      children: [
        // 续写链条标题行
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Text('✍️ 续写链条', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${provider.continueChain.length} 条',
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
                ),
              ),
              const Spacer(),
              if (provider.continueChain.isNotEmpty)
                TextButton(
                  onPressed: () => _showClearChainDialog(context, provider),
                  child: const Text('清空全部', style: TextStyle(color: Colors.red, fontSize: 13)),
                ),
            ],
          ),
        ),

        // 续写链条列表
        Expanded(
          child: provider.continueChain.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.link_off, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        '暂无续写章节',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '生成续写内容后自动添加到此处',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.continueChain.length,
                  itemBuilder: (context, idx) {
                    final chapter = provider.continueChain[idx];
                    return _ChainChapterCard(
                      index: idx,
                      chapter: chapter,
                      onContinue: () => _continueFromChain(context, provider, chapter.id),
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: chapter.content));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已复制到剪贴板')),
                        );
                      },
                      onDelete: () => _deleteChainChapter(context, provider, chapter.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _continueFromChain(BuildContext context, NovelProvider provider, int chainId) async {
    if (provider.isGeneratingWrite) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在生成中，请稍候')),
      );
      return;
    }
    final result = await provider.continueFromChain(chainId);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('续写完成！字数：${result.length}')),
      );
    }
  }

  void _deleteChainChapter(BuildContext context, NovelProvider provider, int chainId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除续写章节'),
        content: const Text('确定要删除该续写章节吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.removeContinueChapter(chainId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showClearChainDialog(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空续写链条'),
        content: Text('确定要清空全部 ${provider.continueChain.length} 个续写章节吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.clearContinueChain();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }
}

/// 续写链条中的单章卡片
class _ChainChapterCard extends StatelessWidget {
  final int index;
  final ContinueChapter chapter;
  final VoidCallback onContinue;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  const _ChainChapterCard({
    required this.index,
    required this.chapter,
    required this.onContinue,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🔗', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  '续写#${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  '约 ${chapter.content.length} 字',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(minHeight: 60),
              child: Text(
                chapter.content.isEmpty ? '(空)' : chapter.content,
                style: TextStyle(
                  fontSize: 13,
                  color: chapter.content.isEmpty ? Colors.grey : Colors.black87,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                OutlinedButton.icon(
                  onPressed: onContinue,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('基于此继续'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('复制内容'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('删除'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
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
