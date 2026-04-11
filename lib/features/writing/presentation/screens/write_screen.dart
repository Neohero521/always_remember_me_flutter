import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:always_remember_me/providers/novel_provider.dart';
import 'package:always_remember_me/app/theme/colors.dart';
import 'package:always_remember_me/app/drawer_menu.dart';
import 'package:always_remember_me/screens/import/import_screen.dart';
import 'package:always_remember_me/screens/reader/reader_screen.dart';

/// WriteScreen v5.0 - BottomNav Tab1: 续写核心页面
/// Based on UI_DESIGN_v5.md - Clean Architecture + Feature-based module
///
/// Key redesign:
/// - WriteResultCard with circular quality score + dimension scores
/// - ContinueChainView with linear chain visualization
/// - Real-time progress bar during generation
/// - Adopt actions: ✅ 加入链条 / ➡️ 继续续写
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
    final hasNovel = provider.chapters.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Text('☰', style: TextStyle(fontSize: 22)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: GestureDetector(
          onTap: () => context.go('/bookshelf'),
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
              if (hasNovel)
                const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textSecondary),
            ],
          ),
        ),
        actions: [
          if (hasNovel)
            IconButton(
              icon: const Text('📖', style: TextStyle(fontSize: 18)),
              tooltip: '阅读小说',
              onPressed: () => context.go('/reader'),
            ),
          IconButton(
            icon: const Text('⚙️', style: TextStyle(fontSize: 18)),
            tooltip: '续写参数',
            onPressed: () => context.push('/write-settings'),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: !hasNovel
          ? _EmptyWriteState(
              onGoBookshelf: () => context.go('/bookshelf'),
              onImport: () => context.push('/import'),
            )
          : _WriteBody(
              provider: provider,
              selectedChapterId: _selectedChapterId,
              isEditing: _isEditing,
              statusExpanded: _statusExpanded,
              resultExpanded: _resultExpanded,
              chainExpanded: _chainExpanded,
              contentController: _contentController,
              editedContent: _editedContent,
              onChapterChanged: (id) {
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
              onEditToggle: () => setState(() => _isEditing = !_isEditing),
              onContentChanged: (v) => _editedContent = v,
              onStatusToggle: () => setState(() => _statusExpanded = !_statusExpanded),
              onResultToggle: () => setState(() => _resultExpanded = !_resultExpanded),
              onChainToggle: () => setState(() => _chainExpanded = !_chainExpanded),
              onUpdateGraph: () => _updateModifiedChapterGraph(context, provider),
              onStartWrite: () => _startWrite(context, provider),
              onStopWrite: () => provider.stopWrite(),
              onImportNovel: () => context.push('/import'),
              onAddToChain: () {
                provider.addToContinueChain(provider.writePreview);
                setState(() {});
              },
              onContinueFrom: provider.continueChain.isNotEmpty
                  ? () => _continueFromLast(context, provider)
                  : null,
              onClear: () => provider.clearWritePreview(),
              onClearChain: () => _showClearChainDialog(context, provider),
              onContinueChain: (chainId) => _continueFromChain(context, provider, chainId),
              onCopyChain: (content) {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已复制到剪贴板')),
                );
              },
              onDeleteChain: (chainId) => _deleteChainChapter(context, provider, chainId),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Empty Write State (no book selected)
// ============================================================
class _EmptyWriteState extends StatelessWidget {
  final VoidCallback onGoBookshelf;
  final VoidCallback onImport;

  const _EmptyWriteState({required this.onGoBookshelf, required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🐋', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            const Text(
              '还没有选中小说呢~',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '请先从书架选择一本小说，\n或者导入一本新小说开始创作！',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onGoBookshelf,
                  icon: const Icon(Icons.book, size: 18),
                  label: const Text('📚 前往书架'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.file_upload, size: 18),
                  label: const Text('📥 导入小说'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

// ============================================================
// Write Body (with book selected)
// ============================================================
class _WriteBody extends StatelessWidget {
  final NovelProvider provider;
  final String? selectedChapterId;
  final bool isEditing;
  final bool statusExpanded;
  final bool resultExpanded;
  final bool chainExpanded;
  final TextEditingController contentController;
  final String editedContent;
  final ValueChanged<String?> onChapterChanged;
  final VoidCallback onEditToggle;
  final ValueChanged<String> onContentChanged;
  final VoidCallback onStatusToggle;
  final VoidCallback onResultToggle;
  final VoidCallback onChainToggle;
  final VoidCallback onUpdateGraph;
  final VoidCallback onStartWrite;
  final VoidCallback onStopWrite;
  final VoidCallback onImportNovel;
  final VoidCallback onAddToChain;
  final VoidCallback? onContinueFrom;
  final VoidCallback onClear;
  final VoidCallback onClearChain;
  final void Function(int) onContinueChain;
  final void Function(String) onCopyChain;
  final void Function(int) onDeleteChain;

  const _WriteBody({
    required this.provider,
    required this.selectedChapterId,
    required this.isEditing,
    required this.statusExpanded,
    required this.resultExpanded,
    required this.chainExpanded,
    required this.contentController,
    required this.editedContent,
    required this.onChapterChanged,
    required this.onEditToggle,
    required this.onContentChanged,
    required this.onStatusToggle,
    required this.onResultToggle,
    required this.onChainToggle,
    required this.onUpdateGraph,
    required this.onStartWrite,
    required this.onStopWrite,
    required this.onImportNovel,
    required this.onAddToChain,
    required this.onContinueFrom,
    required this.onClear,
    required this.onClearChain,
    required this.onContinueChain,
    required this.onCopyChain,
    required this.onDeleteChain,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status Overview Card
        _StatusCard(
          expanded: statusExpanded,
          onToggle: onStatusToggle,
          chapterCount: provider.chapters.length,
          graphCount: provider.chapterGraphMap.length,
          chainCount: provider.continueChain.length,
          isMerged: provider.mergedGraph != null,
        ),
        const SizedBox(height: 16),

        // Chapter Selector
        _ChapterSelector(
          chapters: provider.chapters,
          selectedChapterId: selectedChapterId,
          chapterGraphMap: provider.chapterGraphMap,
          onChanged: onChapterChanged,
        ),
        const SizedBox(height: 16),

        // Editable Content
        if (selectedChapterId != null) ...[
          _EditableContent(
            isEditing: isEditing,
            contentController: contentController,
            editedContent: editedContent,
            onEditToggle: onEditToggle,
            onContentChanged: onContentChanged,
            onUpdateGraph: onUpdateGraph,
          ),
          const SizedBox(height: 16),
        ],

        // Generation Progress
        if (provider.isGeneratingWrite) ...[
          _GenerationProgressCard(
            progressText: provider.writeProgressText,
            onStop: onStopWrite,
          ),
          const SizedBox(height: 16),
        ],

        // Action Buttons
        _ActionButtons(
          canWrite: selectedChapterId != null && !provider.isGeneratingWrite,
          isGenerating: provider.isGeneratingWrite,
          hasChapters: provider.chapters.isNotEmpty,
          onStartWrite: onStartWrite,
          onStopWrite: onStopWrite,
          onBatchWrite: () => _showBatchWriteSheet(context),
          onImportNovel: onImportNovel,
        ),
        const SizedBox(height: 16),

        // Write Result (v5.0 new design)
        if (provider.writePreview.isNotEmpty || provider.qualityResult != null)
          _WriteResultCard(
            expanded: resultExpanded,
            onToggle: onResultToggle,
            preview: provider.writePreview,
            qualityResult: provider.qualityResult,
            precheckResult: provider.precheckResult,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: provider.writePreview));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已复制到剪贴板')),
              );
            },
            onAddToChain: onAddToChain,
            onContinueFrom: onContinueFrom,
            onClear: onClear,
          ),
        const SizedBox(height: 16),

        // Continue Chain (v5.0 new design)
        _ContinueChainSection(
          expanded: chainExpanded,
          chain: provider.continueChain,
          isGenerating: provider.isGeneratingWrite,
          onToggle: onChainToggle,
          onClearAll: onClearChain,
          onContinue: onContinueChain,
          onCopy: onCopyChain,
          onDelete: onDeleteChain,
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  void _showBatchWriteSheet(BuildContext context) {
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
}

// ============================================================
// Status Card (v5.0 - collapsible)
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
                  const Text('📊', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  const Text('状态概览', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
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
                  _StatChip(emoji: '📖', label: '$chapterCount章节', color: AppColors.primary),
                  _StatChip(emoji: '🌲', label: '$graphCount图谱', color: AppColors.primary),
                  _StatChip(emoji: '✍️', label: '$chainCount续写', color: AppColors.secondary),
                  _StatChip(
                    emoji: isMerged ? '✅' : '⏳',
                    label: isMerged ? '已合并' : '未合并',
                    color: isMerged ? AppColors.success : AppColors.warning,
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
// Chapter Selector (v5.0)
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
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('续写基准', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                      Flexible(child: Text(c.title, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                      Icon(
                        hasGraph ? Icons.check_circle : Icons.circle_outlined,
                        size: 14,
                        color: hasGraph ? AppColors.success : AppColors.textHint,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
            if (selectedChapterId != null) ...[
              const SizedBox(height: 8),
              Builder(builder: (ctx) {
                final chapterId = int.tryParse(selectedChapterId ?? '') ?? -1;
                final hasGraph = chapterGraphMap.containsKey(chapterId);
                return Row(
                  children: [
                    Icon(
                      hasGraph ? Icons.check_circle : Icons.warning,
                      size: 14,
                      color: hasGraph ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      hasGraph ? '有图谱 · 约 ${chapters.firstWhere((c) => c.id.toString() == selectedChapterId, orElse: () => chapters.first).content.length} 字'
                          : '暂无图谱，建议先生成',
                      style: TextStyle(fontSize: 12, color: hasGraph ? AppColors.success : AppColors.warning),
                    ),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Editable Content (v5.0)
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
                        style: TextButton.styleFrom(foregroundColor: AppColors.success),
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
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider),
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
// Generation Progress Card (v5.0 NEW)
// ============================================================
class _GenerationProgressCard extends StatelessWidget {
  final String progressText;
  final VoidCallback onStop;

  const _GenerationProgressCard({required this.progressText, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                const Text(
                  '⏳ 正在生成续写内容...',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onStop,
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('取消'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              backgroundColor: AppColors.divider,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              progressText.isNotEmpty ? progressText : 'AI 正在根据图谱上下文进行创作~',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Action Buttons (v5.0)
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
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: canWrite ? onStartWrite : (isGenerating ? onStopWrite : null),
            icon: Icon(isGenerating ? Icons.stop : Icons.auto_stories),
            label: Text(isGenerating ? '停止续写' : '🚀 开始续写'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isGenerating ? AppColors.error : AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 10),
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
// Write Result Card (v5.0 NEW - Quality Score Ring + Chain View)
// ============================================================
class _WriteResultCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final String preview;
  final dynamic qualityResult;
  final dynamic precheckResult;
  final VoidCallback onCopy;
  final VoidCallback onAddToChain;
  final VoidCallback? onContinueFrom;
  final VoidCallback onClear;

  const _WriteResultCard({
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
      color: AppColors.accent.withOpacity(0.05),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    preview.isNotEmpty ? '续写完成 · 约 $preview.length 字' : '续写结果',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Spacer(),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),

                  // Preview Content
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
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

                  // Quality Report Card (v5.0 ring design)
                  if (qualityResult != null) ...[
                    const SizedBox(height: 8),
                    _QualityReportCard(result: qualityResult),
                  ],

                  // Precheck Panel
                  if (precheckResult != null) ...[
                    const SizedBox(height: 8),
                    _PrecheckPanel(result: precheckResult),
                  ],

                  const SizedBox(height: 12),

                  // Action Buttons: Adopt / Continue
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('✅ 加入续写链条'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: onAddToChain,
                        ),
                      ),
                      if (onContinueFrom != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.arrow_forward, size: 18),
                            label: const Text('➡️ 基于此继续'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                      child: const Text(
                        '清除结果',
                        style: TextStyle(color: AppColors.error, fontSize: 13),
                      ),
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

// ============================================================
// Quality Report Card (v5.0 NEW - Ring Progress + Dimension Bars)
// ============================================================
class _QualityReportCard extends StatelessWidget {
  final dynamic result;

  const _QualityReportCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final score = result.totalScore as int;
    final isPassed = result.isPassed as bool;

    Color scoreColor;
    if (score >= 90) {
      scoreColor = AppColors.success;
    } else if (score >= 70) {
      scoreColor = AppColors.primary;
    } else if (score >= 50) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scoreColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '─── 质量评估 ───',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          // Ring + Overall Score
          Row(
            children: [
              // Circular Progress Indicator
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 6,
                      backgroundColor: scoreColor.withOpacity(0.2),
                      color: scoreColor,
                    ),
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '总体评分：$score / 100',
                          style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPassed
                                ? AppColors.success.withOpacity(0.2)
                                : AppColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isPassed ? '✅ 良好' : '❌ 不合格',
                            style: TextStyle(
                              fontSize: 11,
                              color: isPassed ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.report as String? ?? '',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dimension Scores
          _DimensionScoreBar(
            label: '人设一致',
            score: result.characterConsistencyScore as int? ?? 0,
            maxScore: 100,
            color: scoreColor,
          ),
          const SizedBox(height: 6),
          _DimensionScoreBar(
            label: '设定合规',
            score: result.settingComplianceScore as int? ?? 0,
            maxScore: 100,
            color: scoreColor,
          ),
          const SizedBox(height: 6),
          _DimensionScoreBar(
            label: '文风一致',
            score: result.styleMatchScore as int? ?? 0,
            maxScore: 100,
            color: scoreColor,
          ),
          const SizedBox(height: 6),
          _DimensionScoreBar(
            label: '内容质量',
            score: result.contentQualityScore as int? ?? 0,
            maxScore: 100,
            color: scoreColor,
          ),
        ],
      ),
    );
  }
}

class _DimensionScoreBar extends StatelessWidget {
  final String label;
  final int score;
  final int maxScore;
  final Color color;

  const _DimensionScoreBar({
    required this.label,
    required this.score,
    required this.maxScore,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / maxScore,
              backgroundColor: color.withOpacity(0.15),
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '${score}分',
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Precheck Panel (v5.0 NEW - Color coded)
// ============================================================
class _PrecheckPanel extends StatelessWidget {
  final dynamic result;

  const _PrecheckPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final isPass = result.isPass as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPass
            ? AppColors.success.withOpacity(0.08)
            : AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isPass ? AppColors.success : AppColors.warning).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '─── 前置校验 ───',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPass ? Icons.check_circle : Icons.warning,
                size: 16,
                color: isPass ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.complianceReport as String? ?? (isPass ? '校验通过' : '存在警告'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isPass ? AppColors.success : AppColors.warning,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
// Continue Chain Section (v5.0 NEW - Linear Chain Visualization)
// ============================================================
class _ContinueChainSection extends StatelessWidget {
  final bool expanded;
  final List<dynamic> chain;
  final bool isGenerating;
  final VoidCallback onToggle;
  final VoidCallback onClearAll;
  final void Function(int) onContinue;
  final void Function(String) onCopy;
  final void Function(int) onDelete;

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
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('✍️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '续写链条（${chain.length}条）',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Spacer(),
                  if (chain.isNotEmpty)
                    TextButton(
                      onPressed: onClearAll,
                      child: const Text(
                        '清空',
                        style: TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                    ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
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
                          Icon(Icons.link_off, size: 36, color: AppColors.textHint),
                          const SizedBox(height: 8),
                          Text(
                            '暂无续写记录，快去开始你的第一次续写吧~ 🐋',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        // Linear Chain Visualization (v5.0 NEW)
                        _ChainLinearView(chain: chain),
                        const SizedBox(height: 12),
                        // Chain list
                        ...chain.map((chapter) => _ChainCard(
                          index: chain.indexOf(chapter),
                          chapter: chapter,
                          onContinue: () => onContinue(chapter.id),
                          onCopy: () => onCopy(chapter.content),
                          onDelete: () => onDelete(chapter.id),
                        )),
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

// ============================================================
// Chain Linear View (v5.0 NEW - Visual chain)
// ============================================================
class _ChainLinearView extends StatelessWidget {
  final List<dynamic> chain;

  const _ChainLinearView({required this.chain});

  @override
  Widget build(BuildContext context) {
    if (chain.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.chainBadge.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.chainBadge.withOpacity(0.15)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < chain.length; i++) ...[
              _ChainNode(
                label: '续写#${i + 1}',
                wordCount: chain[i].content.length,
                isLast: i == chain.length - 1,
              ),
              if (i < chain.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.chainBadge,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChainNode extends StatelessWidget {
  final String label;
  final int wordCount;
  final bool isLast;

  const _ChainNode({
    required this.label,
    required this.wordCount,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isLast ? AppColors.chainBadge : AppColors.chainBadge.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.chainBadge.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isLast ? Colors.white : AppColors.chainBadge,
            ),
          ),
          Text(
            '约${(wordCount / 1000).toStringAsFixed(1)}k字',
            style: TextStyle(
              fontSize: 9,
              color: isLast ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Chain Card (v5.0)
// ============================================================
class _ChainCard extends StatelessWidget {
  final int index;
  final dynamic chapter;
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
        color: AppColors.chainBadge.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.chainBadge.withOpacity(0.15)),
      ),
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
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(minHeight: 50),
            child: Text(
              chapter.content.isEmpty ? '(空)' : chapter.content,
              style: TextStyle(
                fontSize: 13,
                color: chapter.content.isEmpty ? AppColors.textHint : AppColors.textPrimary,
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
                  foregroundColor: AppColors.error,
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
// Batch Write Sheet (same as v4)
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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('⚡ 批量续写设置', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('起始章节', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
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
                    backgroundColor: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.background,
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
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedStartIdx != null ? () => widget.onStart(_selectedStartIdx!) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
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
// Batch Progress Dialog
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
  void _startPolling() async {
    while (mounted && Navigator.of(context).canPop()) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.state.total > 0 ? widget.state.current / widget.state.total : 0.0;
    return AlertDialog(
      title: const Row(children: [
        Icon(Icons.fast_forward, color: AppColors.accent),
        SizedBox(width: 8),
        Text('批量续写中')
      ]),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.divider,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              '第 ${widget.state.current} / ${widget.state.total} 章',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.state.stateText,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '✅ 成功: ${widget.state.success}',
                  style: const TextStyle(fontSize: 13, color: AppColors.success),
                ),
                const SizedBox(width: 16),
                Text(
                  '❌ 失败: ${widget.state.failed}',
                  style: const TextStyle(fontSize: 13, color: AppColors.error),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onStop,
          child: const Text('停止', style: TextStyle(color: AppColors.error)),
        ),
      ],
    );
  }
}
