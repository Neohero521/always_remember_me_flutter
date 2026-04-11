import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';

/// 续写 Tab — 续写核心面板
class WriteTab extends StatefulWidget {
  const WriteTab({super.key});

  @override
  State<WriteTab> createState() => _WriteTabState();
}

class _WriteTabState extends State<WriteTab> {
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

    return ListView(
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

        // 前置校验结果
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

        // 批量续写按钮
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: provider.isGeneratingWrite || provider.chapters.isEmpty
              ? null
              : () => _showBatchContinueDialog(context, provider),
          icon: const Icon(Icons.fast_forward, size: 18),
          label: const Text('一键批量续写'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
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
      ],
    );
  }

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

  void _showBatchContinueDialog(BuildContext context, NovelProvider provider) {
    final originalChapters = provider.chapters.toList();
    if (originalChapters.isEmpty) return;

    int? selectedChapterId;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('一键批量续写'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('选择起始章节：'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.maxFinite,
              height: 200,
              child: ListView.builder(
                itemCount: originalChapters.length,
                itemBuilder: (_, idx) {
                  final chapter = originalChapters[idx];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.orange.shade100,
                      child: Text('${idx + 1}', style: const TextStyle(fontSize: 11)),
                    ),
                    title: Text(chapter.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                    selected: selectedChapterId == chapter.id,
                    onTap: () => setState(() => selectedChapterId = chapter.id),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: selectedChapterId == null
                ? null
                : () {
                    Navigator.pop(ctx);
                    _startBatchContinue(context, provider, selectedChapterId!);
                  },
            child: const Text('开始批量续写'),
          ),
        ],
      ),
    );
  }

  void _startBatchContinue(BuildContext context, NovelProvider provider, int startChapterId) {
    final chapters = provider.chapters.toList();
    final startIdx = chapters.indexWhere((c) => c.id == startChapterId);
    if (startIdx < 0) return;

    final targetChapters = chapters.sublist(startIdx);
    _BatchWriteState state = _BatchWriteState();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BatchProgressDialog(
        state: state,
        onStop: () => state.stop = true,
      ),
    );

    _runBatchContinueWrite(context, provider, targetChapters, state);
  }

  Future<void> _runBatchContinueWrite(BuildContext context, NovelProvider provider, List<dynamic> targetChapters, _BatchWriteState state) async {
    for (int i = 0; i < targetChapters.length; i++) {
      if (state.stop) {
        if (context.mounted) Navigator.of(context).pop();
        return;
      }

      final chapter = targetChapters[i];
      state.current = i + 1;
      state.total = targetChapters.length;
      state.stateText = '续写第 ${i + 1}/${state.total} 章：${chapter.title}';

      provider.selectBaseChapter(chapter.id.toString());
      await Future.delayed(const Duration(milliseconds: 300));

      String? result;
      for (int retry = 0; retry < 3; retry++) {
        if (state.stop) break;
        state.stateText = '续写第 ${i + 1}/${state.total} 章：${chapter.title}（第${retry + 1}次尝试）';
        result = await provider.generateWrite();
        if (result != null && result.length > 50) break;
        if (state.stop) break;
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      if (state.stop) {
        if (context.mounted) Navigator.of(context).pop();
        return;
      }

      if (result != null && result.length > 50) {
        state.success++;
      } else {
        state.failed++;
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    state.stateText = '批量续写完成！';
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) Navigator.of(context).pop();
  }

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

class _BatchWriteState {
  int current = 0;
  int total = 0;
  int success = 0;
  int failed = 0;
  String stateText = '';
  bool stop = false;
}

class _BatchProgressDialog extends StatefulWidget {
  final _BatchWriteState state;
  final VoidCallback onStop;

  const _BatchProgressDialog({required this.state, required this.onStop});

  @override
  State<_BatchProgressDialog> createState() => _BatchProgressDialogState();
}

class _BatchProgressDialogState extends State<_BatchProgressDialog> {
  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() async {
    while (mounted && Navigator.of(context).canPop()) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.state.total > 0 ? widget.state.current / widget.state.total : 0.0;
    return AlertDialog(
      title: const Row(children: [Icon(Icons.fast_forward, color: Colors.orange), SizedBox(width: 8), Text('批量续写中')]),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text('第 ${widget.state.current} / ${widget.state.total} 章', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(widget.state.stateText, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('✅ 成功: ${widget.state.success}', style: const TextStyle(fontSize: 13, color: Colors.green)),
                const SizedBox(width: 16),
                Text('❌ 失败: ${widget.state.failed}', style: const TextStyle(fontSize: 13, color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () { widget.onStop(); }, child: const Text('停止', style: TextStyle(color: Colors.red))),
      ],
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
              Container(width: 4, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
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
