import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../theme/v4_colors.dart';
import '../../app/drawer_menu.dart';
import '../../models/chapter.dart';

/// WriteScreen v4.0 - BottomNav Tab1: 续写核心页面
/// 单页分区设计，续写结果默认折叠
class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  String? _selectedChapterId;
  String _editedContent = '';
  bool _isEditing = false;
  bool _statusExpanded = true;
  bool _resultExpanded = false;
  bool _chainExpanded = true;
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
    final currentBook = provider.currentBookId != null
        ? provider.bookshelf.cast<dynamic>().firstWhere(
            (b) => b.id == provider.currentBookId,
            orElse: () => null,
          )
        : null;
    final bookTitle = currentBook?.title ?? '未选择书籍';

    return Scaffold(
      backgroundColor: V4Colors.background,
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Text('☰', style: TextStyle(fontSize: 22)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: GestureDetector(
          onTap: () {
            // Navigate to bookshelf tab
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  '《$bookTitle》',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (provider.chapters.isNotEmpty)
                const Icon(Icons.arrow_drop_down, size: 18, color: V4Colors.textSecondary),
            ],
          ),
        ),
        actions: [
          if (provider.chapters.isNotEmpty)
            IconButton(
              icon: const Text('📖', style: TextStyle(fontSize: 18)),
              tooltip: '阅读小说',
              onPressed: () {
                // Switch to Reader tab
              },
            ),
          if (provider.isGeneratingWrite)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: V4Colors.primary),
                ),
              ),
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === 状态概览卡片（可折叠）===
          _StatusCard(
            expanded: _statusExpanded,
            onToggle: () => setState(() => _statusExpanded = !_statusExpanded),
            chapterCount: provider.chapters.length,
            graphCount: provider.chapterGraphMap.length,
            chainCount: provider.continueChain.length,
            isMerged: provider.mergedGraph != null,
          ),
          const SizedBox(height: 16),

          // === 续写基准章节选择 ===
          _ChapterSelector(
            chapters: provider.chapters,
            selectedChapterId: _selectedChapterId,
            chapterGraphMap: provider.chapterGraphMap,
            onChanged: (id) {
              setState(() {
                _selectedChapterId = id;
                _isEditing = false;
              });
              if (id != null) {
                provider.selectBaseChapter(id);
                final chapter = provider.getChapterById(int.tryParse(id) ?? 0);
                _editedContent = chapter?.content ?? '';
                _contentController.text = _editedContent;
              }
            },
          ),
          const SizedBox(height: 16),

          // === 基准内容（可编辑）===
          if (_selectedChapterId != null) ...[
            _EditableContent(
              isEditing: _isEditing,
              contentController: _contentController,
              editedContent: _editedContent,
              onEditToggle: () => setState(() => _isEditing = !_isEditing),
              onContentChanged: (v) => _editedContent = v,
              onUpdateGraph: () => _updateModifiedChapterGraph(context, provider),
            ),
            const SizedBox(height: 16),
          ],

          // === 操作按钮区 ===
          _ActionButtons(
            canWrite: _selectedChapterId != null && !provider.isGeneratingWrite,
            isGenerating: provider.isGeneratingWrite,
            hasChapters: provider.chapters.isNotEmpty,
            onStartWrite: () => _startWrite(context, provider),
            onStopWrite: () => provider.stopWrite(),
            onBatchWrite: () => _showBatchWriteSheet(context, provider),
            onImportNovel: () {
              // Navigate to import
            },
          ),
          const SizedBox(height: 16),

          // === 续写结果（折叠面板）===
          if (provider.writePreview.isNotEmpty || provider.qualityResult != null)
            _WriteResultPanel(
              expanded: _resultExpanded,
              onToggle: () => setState(() => _resultExpanded = !_resultExpanded),
              preview: provider.writePreview,
              qualityResult: provider.qualityResult,
              precheckResult: provider.precheckResult,
              onCopy: () {
                Clipboard.setData(ClipboardData(text: provider.writePreview));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已复制到剪贴板')),
                );
              },
              onAddToChain: () {
                provider.addToContinueChain(provider.writePreview);
                setState(() {});
              },
              onContinueFrom: provider.continueChain.isNotEmpty
                  ? () => _continueFromLast(context, provider)
                  : null,
              onClear: () => provider.clearWritePreview(),
            ),
          const SizedBox(height: 16),

          // === 续写链条列表 ===
          _ContinueChainSection(
            expanded: _chainExpanded,
            chain: provider.continueChain,
            isGenerating: provider.isGeneratingWrite,
            onToggle: () => setState(() => _chainExpanded = !_chainExpanded),
            onClearAll: () => _showClearChainDialog(context, provider),
            onContinue: (chainId) => _continueFromChain(context, provider, chainId),
            onCopy: (content) {
              Clipboard.setData(ClipboardData(text: content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已复制到剪贴板')),
              );
            },
            onDelete: (chainId) => _deleteChainChapter(context, provider, chainId),
          ),

          // === 进度文字 ===
          if (provider.writeProgressText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                provider.writeProgressText,
                style: TextStyle(color: V4Colors.textSecondary, fontSize: 12),
              ),
            ),
          ],

          const SizedBox(height: 100),
        ],
      ),
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

  Future<void> _startWrite(BuildContext context, NovelProvider provider) async {
    final result = await provider.generateWrite(
      modifiedContent: _isEditing ? _editedContent : null,
    );
    if (result != null && context.mounted) {
      setState(() => _resultExpanded = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('续写完成！字数：${result.length}')),
      );
    }
  }

  Future<void> _continueFromLast(BuildContext context, NovelProvider provider) async {
    if (provider.continueChain.isEmpty) return;
    final last = provider.continueChain.last;
    final result = await provider.continueFromChain(last.id);
    if (result != null && context.mounted) {
      setState(() => _resultExpanded = true);
    }
  }

  void _showBatchWriteSheet(BuildContext context, NovelProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _BatchWriteSheet(
        chapters: provider.chapters,
        onStart: (startIdx) {
          Navigator.pop(ctx);
          _startBatchContinue(context, provider, startIdx);
        },
      ),
    );
  }

  void _startBatchContinue(BuildContext context, NovelProvider provider, int startIdx) {
    final chapters = provider.chapters.toList();
    if (startIdx >= chapters.length) return;
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

  Future<void> _runBatchContinueWrite(
    BuildContext context,
    NovelProvider provider,
    List<dynamic> targetChapters,
    _BatchWriteState state,
  ) async {
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

  void _continueFromChain(BuildContext context, NovelProvider provider, int chainId) async {
    if (provider.isGeneratingWrite) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在生成中，请稍候')),
      );
      return;
    }
    final result = await provider.continueFromChain(chainId);
    if (result != null && context.mounted) {
      setState(() => _resultExpanded = true);
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
            style: ElevatedButton.styleFrom(backgroundColor: V4Colors.error),
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
            style: ElevatedButton.styleFrom(backgroundColor: V4Colors.error),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 状态概览卡片
// ============================================================
class _StatusCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final int chapterCount;
  final int graphCount;
  final int chainCount;
  final bool isMerged;

  const _StatusCard({
    required this.expanded,
    required this.onToggle,
    required this.chapterCount,
    required this.graphCount,
    required this.chainCount,
    required this.isMerged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon('📊', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  const Text('状态概览', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: V4Colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatChip(emoji: '📖', label: '$chapterCount章节', color: V4Colors.primary),
                  _StatChip(emoji: '🌲', label: '$graphCount图谱', color: V4Colors.primary),
                  _StatChip(emoji: '✍️', label: '$chainCount续写', color: V4Colors.secondary),
                  _StatChip(
                    emoji: isMerged ? '✅' : '⏳',
                    label: isMerged ? '已合并' : '未合并',
                    color: isMerged ? V4Colors.success : V4Colors.warning,
                  ),
                ],
              ),
            ),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _StatChip({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ============================================================
// 续写基准章节选择
// ============================================================
class _ChapterSelector extends StatelessWidget {
  final List<dynamic> chapters;
  final String? selectedChapterId;
  final Map<int, dynamic> chapterGraphMap;
  final ValueChanged<String?> onChanged;

  const _ChapterSelector({
    required this.chapters,
    required this.selectedChapterId,
    required this.chapterGraphMap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('续写基准章节', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: V4Colors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: V4Colors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: V4Colors.warning, size: 18),
                    const SizedBox(width: 8),
                    const Text('请先导入小说', style: TextStyle(color: V4Colors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('续写基准章节', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedChapterId,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              hint: const Text('请选择章节'),
              items: chapters.map((c) {
                final hasGraph = chapterGraphMap.containsKey(c.id);
                return DropdownMenuItem(
                  value: c.id.toString(),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(c.title, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        hasGraph ? Icons.check_circle : Icons.circle_outlined,
                        size: 14,
                        color: hasGraph ? V4Colors.success : V4Colors.textHint,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
            const SizedBox(height: 8),
            if (selectedChapterId != null)
              Builder(builder: (ctx) {
                final chapterId = int.tryParse(selectedChapterId ?? '') ?? -1;
                final hasGraph = chapterGraphMap.containsKey(chapterId);
                return Row(
                  children: [
                    Icon(
                      hasGraph ? Icons.check_circle : Icons.warning,
                      size: 14,
                      color: hasGraph ? V4Colors.success : V4Colors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      hasGraph ? '有图谱 · 约 ${chapters.firstWhere((c) => c.id.toString() == selectedChapterId, orElse: () => chapters.first).content.length} 字'
                          : '暂无图谱，建议先生成',
                      style: TextStyle(
                        fontSize: 12,
                        color: hasGraph ? V4Colors.success : V4Colors.warning,
                      ),
                    ),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 基准内容（可编辑）
// ============================================================
class _EditableContent extends StatelessWidget {
  final bool isEditing;
  final TextEditingController contentController;
  final String editedContent;
  final VoidCallback onEditToggle;
  final ValueChanged<String> onContentChanged;
  final VoidCallback onUpdateGraph;

  const _EditableContent({
    required this.isEditing,
    required this.contentController,
    required this.editedContent,
    required this.onEditToggle,
    required this.onContentChanged,
    required this.onUpdateGraph,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('基准内容', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Row(
                  children: [
                    if (isEditing)
                      TextButton.icon(
                        icon: const Icon(Icons.auto_graph, size: 16),
                        label: const Text('更新图谱'),
                        style: TextButton.styleFrom(foregroundColor: V4Colors.success),
                        onPressed: onUpdateGraph,
                      ),
                    TextButton.icon(
                      icon: Icon(isEditing ? Icons.visibility : Icons.edit, size: 16),
                      label: Text(isEditing ? '预览' : '编辑'),
                      onPressed: onEditToggle,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: V4Colors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: V4Colors.divider),
              ),
              constraints: const BoxConstraints(minHeight: 100),
              child: isEditing
                  ? TextField(
                      controller: contentController,
                      maxLines: null,
                      onChanged: onContentChanged,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
                    )
                  : SingleChildScrollView(
                      child: Text(editedContent, style: const TextStyle(fontSize: 14)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 操作按钮区
// ============================================================
class _ActionButtons extends StatelessWidget {
  final bool canWrite;
  final bool isGenerating;
  final bool hasChapters;
  final VoidCallback onStartWrite;
  final VoidCallback onStopWrite;
  final VoidCallback onBatchWrite;
  final VoidCallback onImportNovel;

  const _ActionButtons({
    required this.canWrite,
    required this.isGenerating,
    required this.hasChapters,
    required this.onStartWrite,
    required this.onStopWrite,
    required this.onBatchWrite,
    required this.onImportNovel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 主按钮
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: canWrite ? onStartWrite : (isGenerating ? onStopWrite : null),
            icon: Icon(isGenerating ? Icons.stop : Icons.auto_stories),
            label: Text(isGenerating ? '停止续写' : '🚀 开始续写'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isGenerating ? V4Colors.error : V4Colors.primary,
              foregroundColor: V4Colors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // 次要操作
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: hasChapters && !isGenerating ? onBatchWrite : null,
                icon: const Icon(Icons.fast_forward, size: 18),
                label: const Text('⚡ 批量续写'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onImportNovel,
                icon: const Icon(Icons.file_upload, size: 18),
                label: const Text('📥 导入小说'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// 续写结果面板
// ============================================================
class _WriteResultPanel extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final String preview;
  final dynamic qualityResult;
  final dynamic precheckResult;
  final VoidCallback onCopy;
  final VoidCallback onAddToChain;
  final VoidCallback? onContinueFrom;
  final VoidCallback onClear;

  const _WriteResultPanel({
    required this.expanded,
    required this.onToggle,
    required this.preview,
    required this.qualityResult,
    required this.precheckResult,
    required this.onCopy,
    required this.onAddToChain,
    required this.onContinueFrom,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: V4Colors.accent.withOpacity(0.05),
      child: Column(
        children: [
          // 折叠头部
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon('✨', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    preview.isNotEmpty
                        ? '续写完成 · 约 ${preview.length} 字'
                        : '续写结果',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Spacer(),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: V4Colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          // 展开内容
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  // 续写内容
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: V4Colors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(minHeight: 80),
                    child: SingleChildScrollView(
                      child: Text(preview, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('📋 复制'),
                      onPressed: onCopy,
                    ),
                  ),

                  // 质量评估
                  if (qualityResult != null) ...[
                    const SizedBox(height: 8),
                    _QualityResultCard(result: qualityResult),
                  ],

                  // 前置校验
                  if (precheckResult != null) ...[
                    const SizedBox(height: 8),
                    _PrecheckResultCard(result: precheckResult),
                  ],

                  const SizedBox(height: 12),
                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('✅ 加入续写链条'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: onAddToChain,
                        ),
                      ),
                      if (onContinueFrom != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.arrow_forward, size: 16),
                            label: const Text('➡️ 基于此继续'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: onContinueFrom,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: onClear,
                      child: const Text('清除结果', style: TextStyle(color: V4Colors.error, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _QualityResultCard extends StatelessWidget {
  final dynamic result;

  const _QualityResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final score = result.totalScore as int;
    final isPassed = result.isPassed as bool;
    final report = result.report as String;

    Color scoreColor;
    if (score >= 90) {
      scoreColor = V4Colors.success;
    } else if (score >= 70) {
      scoreColor = V4Colors.primary;
    } else if (score >= 50) {
      scoreColor = V4Colors.warning;
    } else {
      scoreColor = V4Colors.error;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scoreColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('质量评估：$score分', style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPassed ? V4Colors.success.withOpacity(0.2) : V4Colors.error.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isPassed ? '✅ 合格' : '❌ 不合格',
                  style: TextStyle(fontSize: 12, color: isPassed ? V4Colors.success : V4Colors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(report, style: TextStyle(fontSize: 12, color: V4Colors.textSecondary)),
        ],
      ),
    );
  }
}

class _PrecheckResultCard extends StatelessWidget {
  final dynamic result;

  const _PrecheckResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final isPass = result.isPass as bool;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPass ? V4Colors.success.withOpacity(0.1) : V4Colors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (isPass ? V4Colors.success : V4Colors.error).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isPass ? Icons.check_circle : Icons.warning,
            size: 16,
            color: isPass ? V4Colors.success : V4Colors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              result.complianceReport as String,
              style: TextStyle(fontSize: 12, color: isPass ? V4Colors.success : V4Colors.error),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 续写链条列表
// ============================================================
class _ContinueChainSection extends StatelessWidget {
  final bool expanded;
  final List<ContinueChapter> chain;
  final bool isGenerating;
  final VoidCallback onToggle;
  final VoidCallback onClearAll;
  final void Function(int chainId) onContinue;
  final void Function(String content) onCopy;
  final void Function(int chainId) onDelete;

  const _ContinueChainSection({
    required this.expanded,
    required this.chain,
    required this.isGenerating,
    required this.onToggle,
    required this.onClearAll,
    required this.onContinue,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // 标题栏
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon('✍️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '续写链条（${chain.length}条）',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Spacer(),
                  if (chain.isNotEmpty)
                    TextButton(
                      onPressed: onClearAll,
                      child: const Text('全部清空', style: TextStyle(color: V4Colors.error, fontSize: 12)),
                    ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: V4Colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          // 链条列表
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: chain.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.link_off, size: 36, color: V4Colors.textHint),
                          const SizedBox(height: 8),
                          Text(
                            '暂无续写记录，快去开始你的第一次续写吧~ 🐋',
                            style: TextStyle(color: V4Colors.textSecondary, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: chain.map((chapter) => _ChainCard(
                        index: chain.indexOf(chapter),
                        chapter: chapter,
                        onContinue: () => onContinue(chapter.id),
                        onCopy: () => onCopy(chapter.content),
                        onDelete: () => onDelete(chapter.id),
                      )).toList(),
                    ),
                  ),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _ChainCard extends StatelessWidget {
  final int index;
  final ContinueChapter chapter;
  final VoidCallback onContinue;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  const _ChainCard({
    required this.index,
    required this.chapter,
    required this.onContinue,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: V4Colors.chainBadge.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: V4Colors.chainBadge.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon('🔗', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                '续写#${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Text(
                '约 ${chapter.content.length} 字',
                style: TextStyle(fontSize: 12, color: V4Colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: V4Colors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(minHeight: 50),
            child: Text(
              chapter.content.isEmpty ? '(空)' : chapter.content,
              style: TextStyle(
                fontSize: 13,
                color: chapter.content.isEmpty ? V4Colors.textHint : V4Colors.textPrimary,
              ),
              maxLines: 4,
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
                icon: const Icon(Icons.add, size: 14),
                label: const Text('→继续'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onCopy,
                icon: const Icon(Icons.copy, size: 14),
                label: const Text('📋复制'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 14),
                label: const Text('🗑删除'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: V4Colors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 批量续写 BottomSheet
// ============================================================
class _BatchWriteSheet extends StatefulWidget {
  final List<dynamic> chapters;
  final void Function(int startIdx) onStart;

  const _BatchWriteSheet({required this.chapters, required this.onStart});

  @override
  State<_BatchWriteSheet> createState() => _BatchWriteSheetState();
}

class _BatchWriteSheetState extends State<_BatchWriteSheet> {
  int? _selectedStartIdx;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 拖动手柄
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: V4Colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '⚡ 批量续写设置',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('起始章节', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: V4Colors.divider),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.chapters.length,
              itemBuilder: (_, idx) {
                final chapter = widget.chapters[idx];
                final isSelected = _selectedStartIdx == idx;
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: isSelected ? V4Colors.primary.withOpacity(0.2) : V4Colors.background,
                    child: Text('${idx + 1}', style: const TextStyle(fontSize: 11)),
                  ),
                  title: Text(chapter.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                  selected: isSelected,
                  onTap: () => setState(() => _selectedStartIdx = idx),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedStartIdx != null ? () => widget.onStart(_selectedStartIdx!) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: V4Colors.primary,
                    foregroundColor: V4Colors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('🚀 开始批量续写'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 批量进度对话框
// ============================================================
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
      title: const Row(children: [Icon(Icons.fast_forward, color: V4Colors.accent), SizedBox(width: 8), Text('批量续写中')]),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progress, backgroundColor: V4Colors.divider, color: V4Colors.primary),
            const SizedBox(height: 12),
            Text('第 ${widget.state.current} / ${widget.state.total} 章', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(widget.state.stateText, style: TextStyle(fontSize: 13, color: V4Colors.textSecondary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('✅ 成功: ${widget.state.success}', style: const TextStyle(fontSize: 13, color: V4Colors.success)),
                const SizedBox(width: 16),
                Text('❌ 失败: ${widget.state.failed}', style: const TextStyle(fontSize: 13, color: V4Colors.error)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onStop,
          child: const Text('停止', style: TextStyle(color: V4Colors.error)),
        ),
      ],
    );
  }
}
