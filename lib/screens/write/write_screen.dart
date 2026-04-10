import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../models/chapter.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  String? _selectedChapterId;
  String _editedContent = '';
  bool _isEditing = false;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NovelProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 续写'),
        backgroundColor: Colors.orange.shade50,
        actions: [
          if (provider.isGeneratingWrite)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )),
            ),
          // 前置校验抽屉开关
          if (_selectedChapterId != null)
            IconButton(
              icon: const Icon(Icons.rule),
              tooltip: '前置校验详情',
              onPressed: () => _showPrecheckDrawer(context, provider),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 基准章节选择
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('选择续写基准章节', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedChapterId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请选择章节',
                    ),
                    items: provider.chapters.map((c) {
                      return DropdownMenuItem(
                        value: c.id.toString(),
                        child: Text(c.title, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedChapterId = value;
                        _isEditing = false;
                      });
                      if (value != null) {
                        provider.selectBaseChapter(value);
                        final chapter = provider.getChapterById(int.tryParse(value) ?? 0);
                        _editedContent = chapter?.content ?? '';
                        _contentController.text = _editedContent;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  // 快速查看图谱状态
                  if (_selectedChapterId != null)
                    Builder(builder: (ctx) {
                      final chapterId = int.tryParse(_selectedChapterId ?? '') ?? -1;
                      final hasGraph = provider.chapterGraphMap.containsKey(chapterId);
                      return Row(
                        children: [
                          Icon(
                            hasGraph ? Icons.check_circle : Icons.warning,
                            size: 16,
                            color: hasGraph ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hasGraph ? '该章节已有知识图谱' : '该章节尚未生成图谱',
                            style: TextStyle(
                              fontSize: 12,
                              color: hasGraph ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 基准章节内容（可编辑）
          if (_selectedChapterId != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('基准章节内容', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            if (_isEditing)
                              TextButton.icon(
                                icon: const Icon(Icons.auto_graph, size: 16),
                                label: const Text('更新图谱'),
                                style: TextButton.styleFrom(foregroundColor: Colors.green),
                                onPressed: () => _updateModifiedChapterGraph(context, provider),
                              ),
                            TextButton.icon(
                              icon: Icon(_isEditing ? Icons.visibility : Icons.edit, size: 16),
                              label: Text(_isEditing ? '预览' : '编辑'),
                              onPressed: () => setState(() => _isEditing = !_isEditing),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(minHeight: 80),
                      child: _isEditing
                          ? TextField(
                              controller: _contentController,
                              maxLines: null,
                              onChanged: (v) => _editedContent = v,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Text(_editedContent, style: const TextStyle(fontSize: 14)),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 前置校验结果（简要显示）
          if (provider.precheckResult != null) ...[
            Card(
              color: provider.precheckResult!.isPass ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          provider.precheckResult!.isPass ? Icons.check_circle : Icons.warning,
                          color: provider.precheckResult!.isPass ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '前置校验：${provider.precheckResult!.isPass ? "通过" : "未通过"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: provider.precheckResult!.isPass ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _showPrecheckDrawer(context, provider),
                          child: const Text('查看详情'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.precheckResult!.complianceReport,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 续写预览
          if (provider.writePreview.isNotEmpty) ...[
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('续写内容预览', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: provider.writePreview));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('已复制到剪贴板')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () => provider.clearWritePreview(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(minHeight: 100),
                      child: SingleChildScrollView(
                        child: Text(provider.writePreview, style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 质量评估结果
          if (provider.qualityResult != null && provider.qualityResultShow) ...[
            Card(
              color: provider.qualityResult!.isPassed ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '质量评估：${provider.qualityResult!.totalScore}分',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          provider.qualityResult!.isPassed ? '✅ 合格' : '❌ 不合格',
                          style: TextStyle(
                            color: provider.qualityResult!.isPassed ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.qualityResult!.report,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 操作按钮
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: provider.isGeneratingWrite || _selectedChapterId == null
                      ? null
                      : () async {
                          final result = await provider.generateWrite(
                            modifiedContent: _isEditing ? _editedContent : null,
                          );
                          if (result != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('续写完成！字数：${result.length}，请下滑查看预览'),
                              ),
                            );
                          }
                        },
                  icon: const Icon(Icons.auto_stories),
                  label: const Text('开始续写'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              if (provider.isGeneratingWrite) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => provider.stopWrite(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  child: const Text('停止'),
                ),
              ],
            ],
          ),

          // 生成进度
          if (provider.writeProgressText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              provider.writeProgressText,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],

          // 续写链条管理
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('续写链条', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${provider.continueChain.length} 章',
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
                ),
              ),
              const Spacer(),
              if (provider.continueChain.isNotEmpty)
                TextButton(
                  onPressed: () => _showClearChainDialog(context, provider),
                  child: const Text('清空链条'),
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (provider.continueChain.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '暂无续写章节，生成续写内容后自动添加到此处',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...provider.continueChain.asMap().entries.map((entry) {
              final idx = entry.key;
              final chapter = entry.value;
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
            }),
        ],
      ),
    );
  }

  /// 更新魔改章节图谱（用户编辑基准章节后重新生成图谱）
  Future<void> _updateModifiedChapterGraph(BuildContext context, NovelProvider provider) async {
    if (_selectedChapterId == null) return;
    final chapterId = int.tryParse(_selectedChapterId ?? '') ?? 0;
    final result = await provider.updateModifiedChapterGraph(chapterId, _editedContent);
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('魔改章节图谱更新完成！')),
      );
    }
  }

  /// 基于链条章节继续续写
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

  /// 删除链条中的章节
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

  /// 清空续写链条
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

  /// 前置校验详情抽屉
  void _showPrecheckDrawer(BuildContext context, NovelProvider provider) {
    final precheck = provider.precheckResult;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('前置校验详情', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      if (precheck != null)
                        Chip(
                          label: Text(precheck.isPass ? '通过' : '未通过'),
                          backgroundColor: precheck.isPass ? Colors.green.shade100 : Colors.red.shade100,
                          labelStyle: TextStyle(
                            color: precheck.isPass ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        if (precheck == null) ...[
                          const Center(child: Text('请点击「开始续写」触发前置校验')),
                        ] else ...[
                          _PrecheckSection('人设红线', precheck.redLines, Colors.red),
                          _PrecheckSection('设定禁区', precheck.forbiddenRules, Colors.orange),
                          _PrecheckSection('可呼应伏笔', precheck.foreshadowList, Colors.purple),
                          _PrecheckSection('潜在矛盾预警', precheck.conflictWarning, Colors.amber.shade700),
                          _PrecheckSection('可推进剧情方向', precheck.possiblePlotDirections, Colors.blue),
                          _PrecheckSection('合规性报告', precheck.complianceReport, Colors.green),
                        ],
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
}

class _PrecheckSection extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const _PrecheckSection(this.title, this.content, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2),
              )),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Text(content.isEmpty ? '无' : content, style: const TextStyle(fontSize: 14)),
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
            Text(
              '续写章节 ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                style: TextStyle(fontSize: 13, color: chapter.content.isEmpty ? Colors.grey : Colors.black87),
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
                  label: const Text('基于此章继续'),
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
