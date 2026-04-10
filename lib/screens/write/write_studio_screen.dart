import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/novel_provider.dart';
import '../../models/chapter.dart';
import '../../theme/game_console_theme.dart';
import '../import/import_screen.dart';
import '../reader/reader_screen.dart';

/// 续写工作台 - 整合首页快捷操作 + 续写功能
class WriteStudioScreen extends StatefulWidget {
  const WriteStudioScreen({super.key});

  @override
  State<WriteStudioScreen> createState() => _WriteStudioScreenState();
}

class _WriteStudioScreenState extends State<WriteStudioScreen> {
  String? _selectedChapterId;
  String _editedContent = '';
  bool _isEditing = false;
  late TextEditingController _contentController;
  int _viewMode = 0; // 0=快捷操作, 1=续写

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
    final hasNovel = provider.chapters.isNotEmpty;

    return Scaffold(
      backgroundColor: GameColors.bg,
      appBar: AppBar(
        backgroundColor: GameColors.bg2,
        foregroundColor: GameColors.textLight,
        title: const Text(
          '✍️ 续写工作台',
          style: TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: ['Noto Sans SC', 'sans-serif'],
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (hasNovel)
            IconButton(
              icon: const Text('📖', style: TextStyle(fontSize: 20)),
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
      body: Column(
        children: [
          // 视图切换 Tab
          Container(
            color: GameColors.bg2,
            child: Row(
              children: [
                _TabBtn(
                  label: '⚡ 快捷操作',
                  selected: _viewMode == 0,
                  onTap: () => setState(() => _viewMode = 0),
                ),
                _TabBtn(
                  label: '✍️ 开始续写',
                  selected: _viewMode == 1,
                  onTap: () => setState(() => _viewMode = 1),
                ),
              ],
            ),
          ),

          // 状态条
          if (hasNovel)
            Container(
              color: GameColors.bg3,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatChip(label: '📄 ${provider.chapters.length}'),
                  _StatChip(label: '🗺️ ${provider.chapterGraphMap.length}'),
                  _StatChip(label: '🔗 ${provider.continueChain.length}'),
                  _StatChip(label: provider.mergedGraph != null ? '✅ 已合并' : '❌ 未合并'),
                ],
              ),
            ),

          // 内容区
          Expanded(
            child: _viewMode == 0
                ? _buildQuickActions(context, provider, hasNovel)
                : _buildWritePanel(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, NovelProvider provider, bool hasNovel) {
    if (!hasNovel && provider.currentBookId == null) {
      return _PixelEmptyState(
        icon: '📚',
        title: '还没有选中的小说',
        subtitle: '请到「书架」导入或选择一本小说',
        action: PixelButton(
          label: '去书架',
          color: GameColors.blue,
          onPressed: () {
            try {
              DefaultTabController.of(context).animateTo(0);
            } catch (_) {}
          },
        ),
      );
    }

    if (!hasNovel) {
      return _PixelEmptyState(
        icon: '📖',
        title: '暂无章节内容',
        subtitle: '请导入小说或选择已有书籍',
        action: PixelButton(
          label: '📥 导入小说',
          color: GameColors.blue,
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
      padding: const EdgeInsets.all(12),
      children: [
        // 一键续写
        _PixelActionCard(
          icon: '▶️',
          title: '一键续写',
          subtitle: '从基准章节开始 AI 续写 ${provider.writeWordCount} 字',
          color: GameColors.orange,
          enabled: !provider.isGeneratingWrite,
          onTap: () {
            if (provider.selectedBaseChapterId.isNotEmpty) {
              setState(() => _viewMode = 1);
            } else {
              showPixelSnackBar(context, '请先选择基准章节（底部续写区）');
            }
          },
        ),
        const SizedBox(height: 8),

        // 批量生成图谱
        _PixelActionCard(
          icon: '🗺️',
          title: '生成知识图谱',
          subtitle: '${provider.chapterGraphMap.length}/${provider.chapters.length} 章已生成',
          color: GameColors.green,
          enabled: !provider.isGeneratingGraph,
          onTap: () => _showBatchGraphDialog(context, provider),
        ),
        const SizedBox(height: 8),

        // 合并图谱
        _PixelActionCard(
          icon: '🔗',
          title: '合并图谱',
          subtitle: provider.chapterGraphMap.length < provider.chapters.length
              ? '需先生成全部章节图谱'
              : '将所有章节图谱合并为全局图谱',
          color: GameColors.pink,
          enabled: provider.chapterGraphMap.length >= provider.chapters.length &&
              provider.chapterGraphMap.isNotEmpty,
          onTap: () => _showMergeDialog(context, provider),
        ),
        const SizedBox(height: 8),

        // 查看/续写链条
        _PixelActionCard(
          icon: '⛓️',
          title: '续写链条',
          subtitle: provider.continueChain.isEmpty
              ? '暂无续写章节'
              : '${provider.continueChain.length} 个续写章节',
          color: GameColors.blueLight,
          enabled: provider.continueChain.isNotEmpty,
          onTap: () => _showContinueChainSheet(context, provider),
        ),
        const SizedBox(height: 8),

        // 图谱操作
        if (provider.chapterGraphMap.isNotEmpty) ...[
          _PixelActionCard(
            icon: '📤',
            title: '导出图谱',
            subtitle: '导出 JSON 格式知识图谱',
            color: GameColors.textMuted,
            onTap: () => _exportGraphs(context, provider),
          ),
          const SizedBox(height: 8),

          _PixelActionCard(
            icon: '🗺️',
            title: '查看全局图谱',
            subtitle: provider.mergedGraph != null
                ? '已合并 ${provider.chapterGraphMap.length} 章图谱'
                : '请先合并图谱',
            color: GameColors.pink,
            enabled: provider.mergedGraph != null,
            onTap: provider.mergedGraph != null
                ? () => Navigator.pushNamed(context, '/graph')
                : null,
          ),
          const SizedBox(height: 8),

          _PixelActionCard(
            icon: '📥',
            title: '导入图谱',
            subtitle: '粘贴 JSON 导入章节图谱',
            color: GameColors.blueLight,
            onTap: () => _importGraphs(context, provider),
          ),
          const SizedBox(height: 8),
        ],

        // 重新导入
        _PixelActionCard(
          icon: '📄',
          title: '导入/重新导入小说',
          subtitle: '已导入 ${provider.chapters.length} 章 · 点击重新导入',
          color: GameColors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ImportScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWritePanel(BuildContext context, NovelProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // 基准章节选择
        Container(
          decoration: GameColors.cardDecoration(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📌 选择续写基准章节',
                style: TextStyle(
                  color: GameColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: GameColors.inputDecoration(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: _selectedChapterId,
                  isExpanded: true,
                  dropdownColor: GameColors.bg2,
                  style: const TextStyle(color: GameColors.textLight, fontSize: 13),
                  hint: const Text('请选择章节', style: TextStyle(color: GameColors.textMuted)),
                  underline: const SizedBox(),
                  items: provider.chapters.map((c) {
                    return DropdownMenuItem(
                      value: c.id.toString(),
                      child: Text(
                        c.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: GameColors.textLight),
                      ),
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
              ),
              if (_selectedChapterId != null) ...[
                const SizedBox(height: 8),
                Builder(builder: (ctx) {
                  final chapterId = int.tryParse(_selectedChapterId ?? '') ?? -1;
                  final hasGraph = provider.chapterGraphMap.containsKey(chapterId);
                  return Row(
                    children: [
                      Text(hasGraph ? '🟢' : '🟡', style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 6),
                      Text(
                        hasGraph ? '该章节已有知识图谱' : '该章节尚未生成图谱',
                        style: TextStyle(
                          fontSize: 11,
                          color: hasGraph ? GameColors.green : GameColors.orange,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 基准章节内容（可编辑）
        if (_selectedChapterId != null) ...[
          Container(
            decoration: GameColors.cardDecoration(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '📜 基准章节内容',
                      style: TextStyle(
                        color: GameColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    if (_isEditing)
                      GestureDetector(
                        onTap: () => _updateModifiedChapterGraph(context, provider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: GameColors.green,
                            border: Border.all(color: GameColors.borderLight, width: 2),
                          ),
                          child: const Text(
                            '🌿 更新图谱',
                            style: TextStyle(color: GameColors.textLight, fontSize: 10),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isEditing = !_isEditing),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isEditing ? GameColors.blueBright : GameColors.bg3,
                          border: Border.all(color: GameColors.borderLight, width: 2),
                        ),
                        child: Text(
                          _isEditing ? '👁️ 预览' : '✏️ 编辑',
                          style: const TextStyle(color: GameColors.textLight, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GameColors.bg3,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: GameColors.borderLight, width: 1),
                  ),
                  constraints: const BoxConstraints(minHeight: 80),
                  child: _isEditing
                      ? TextField(
                          controller: _contentController,
                          maxLines: null,
                          onChanged: (v) => _editedContent = v,
                          style: const TextStyle(
                            color: GameColors.textLight,
                            fontSize: 13,
                            fontFamily: 'monospace',
                          ),
                          cursorColor: GameColors.blueBright,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Text(
                            _editedContent,
                            style: const TextStyle(
                              color: GameColors.textLight,
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 前置校验结果
        if (provider.precheckResult != null) ...[
          Container(
            decoration: GameColors.cardDecoration(
              color: provider.precheckResult!.isPass
                  ? GameColors.green.withOpacity(0.15)
                  : GameColors.red.withOpacity(0.15),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      provider.precheckResult!.isPass ? '✅' : '⚠️',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '前置校验：${provider.precheckResult!.isPass ? "通过" : "未通过"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: provider.precheckResult!.isPass
                            ? GameColors.green
                            : GameColors.orange,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showPrecheckDrawer(context, provider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: GameColors.borderLight, width: 2),
                        ),
                        child: const Text(
                          '详情 ›',
                          style: TextStyle(color: GameColors.textLight, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  provider.precheckResult!.complianceReport,
                  style: const TextStyle(fontSize: 11, color: GameColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 续写预览
        if (provider.writePreview.isNotEmpty) ...[
          Container(
            decoration: GameColors.cardDecoration(
              color: GameColors.orange.withOpacity(0.15),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('✨ 续写内容预览', style: TextStyle(
                      color: GameColors.orange,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    )),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: provider.writePreview));
                        showPixelSnackBar(context, '已复制到剪贴板');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: GameColors.borderLight, width: 2),
                        ),
                        child: const Text('📋 复制', style: TextStyle(color: GameColors.textLight, fontSize: 10)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => provider.clearWritePreview(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: GameColors.borderLight, width: 2),
                        ),
                        child: const Text('🗑️ 清空', style: TextStyle(color: GameColors.textLight, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GameColors.bg3,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: GameColors.borderDark, width: 1),
                  ),
                  constraints: const BoxConstraints(minHeight: 80),
                  child: SingleChildScrollView(
                    child: Text(
                      provider.writePreview,
                      style: const TextStyle(
                        color: GameColors.textLight,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 质量评估结果
        if (provider.qualityResult != null && provider.qualityResultShow) ...[
          Container(
            decoration: GameColors.cardDecoration(
              color: provider.qualityResult!.isPassed
                  ? GameColors.green.withOpacity(0.15)
                  : GameColors.red.withOpacity(0.15),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 质量评估：${provider.qualityResult!.totalScore}分 '
                  '${provider.qualityResult!.isPassed ? "✅ 合格" : "❌ 不合格"}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: provider.qualityResult!.isPassed ? GameColors.green : GameColors.red,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.qualityResult!.report,
                  style: const TextStyle(fontSize: 11, color: GameColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 续写进度
        if (provider.writeProgressText.isNotEmpty) ...[
          Container(
            decoration: GameColors.cardDecoration(color: GameColors.bg3),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('⏳ ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    provider.writeProgressText,
                    style: const TextStyle(
                      color: GameColors.textMuted,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 续写按钮
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: provider.isGeneratingWrite || _selectedChapterId == null
                    ? null
                    : () async {
                        final result = await provider.generateWrite(
                          modifiedContent: _isEditing ? _editedContent : null,
                        );
                        if (result != null && context.mounted) {
                          showPixelSnackBar(
                            context,
                            '续写完成！字数：${result.length}',
                          );
                        } else if (result == null && context.mounted) {
                          showPixelSnackBar(
                            context,
                            '续写失败，请检查 API 配置',
                            isError: true,
                          );
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: GameColors.buttonDecoration(
                    color: provider.isGeneratingWrite || _selectedChapterId == null
                        ? GameColors.bg3
                        : GameColors.orange,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (provider.isGeneratingWrite)
                        const SizedBox(
                          width: 14, height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: GameColors.textLight,
                          ),
                        )
                      else
                        const Text('▶️', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        provider.isGeneratingWrite ? '生成中...' : '开始续写',
                        style: const TextStyle(
                          color: GameColors.textLight,
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (provider.isGeneratingWrite) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => provider.stopWrite(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  decoration: GameColors.buttonDecoration(color: GameColors.red),
                  child: const Text(
                    '⏹',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // 续写链条
        Container(
          decoration: GameColors.cardDecoration(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('⛓️ 续写链条', style: TextStyle(
                    color: GameColors.textLight,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  )),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: GameColors.orange,
                      border: Border.all(color: GameColors.borderLight, width: 2),
                    ),
                    child: Text(
                      '${provider.continueChain.length} 章',
                      style: const TextStyle(
                        color: GameColors.textLight,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (provider.continueChain.isNotEmpty)
                    GestureDetector(
                      onTap: () => _showClearChainDialog(context, provider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: GameColors.red, width: 2),
                        ),
                        child: const Text(
                          '清空',
                          style: TextStyle(color: GameColors.red, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (provider.continueChain.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: GameColors.bg3,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: GameColors.borderDark, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      '暂无续写章节，生成续写内容后自动添加',
                      style: TextStyle(color: GameColors.textMuted, fontSize: 11),
                    ),
                  ),
                )
              else
                ...provider.continueChain.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final chapter = entry.value;
                  return _ChainChapterCardPixel(
                    index: idx,
                    chapter: chapter,
                    isGeneratingWrite: provider.isGeneratingWrite,
                    onContinue: () => _continueFromChain(context, provider, chapter.id),
                    onCopy: () {
                      Clipboard.setData(ClipboardData(text: chapter.content));
                      showPixelSnackBar(context, '已复制到剪贴板');
                    },
                    onDelete: () => _deleteChainChapter(context, provider, chapter.id),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  // === 辅助方法 ===
  Future<void> _updateModifiedChapterGraph(BuildContext context, NovelProvider provider) async {
    if (_selectedChapterId == null) return;
    final chapterId = int.tryParse(_selectedChapterId ?? '') ?? 0;
    try {
      final result = await provider.updateModifiedChapterGraph(chapterId, _editedContent);
      if (result != null && context.mounted) {
        showPixelSnackBar(context, '魔改章节图谱更新完成！');
      }
    } catch (e) {
      if (context.mounted) showPixelSnackBar(context, '更新失败: $e', isError: true);
    }
  }

  Future<void> _continueFromChain(BuildContext context, NovelProvider provider, int chainId) async {
    if (provider.isGeneratingWrite) {
      showPixelSnackBar(context, '正在生成中，请稍候');
      return;
    }
    try {
      final result = await provider.continueFromChain(chainId);
      if (result != null && context.mounted) {
        showPixelSnackBar(context, '续写完成！字数：${result.length}');
      }
    } catch (e) {
      if (context.mounted) showPixelSnackBar(context, '续写失败: $e', isError: true);
    }
  }

  void _deleteChainChapter(BuildContext context, NovelProvider provider, int chainId) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: GameColors.dialogDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚠️ 删除续写章节', style: TextStyle(
                color: GameColors.orange,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 12,
              )),
              const SizedBox(height: 12),
              const Text('确定要删除该续写章节吗？',
                style: TextStyle(color: GameColors.textLight, fontSize: 12)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    label: '取消',
                    color: GameColors.bg3,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    label: '删除',
                    color: GameColors.red,
                    onPressed: () {
                      Navigator.pop(ctx);
                      provider.removeContinueChapter(chainId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearChainDialog(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: GameColors.dialogDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚠️ 清空续写链条', style: TextStyle(
                color: GameColors.orange,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 12,
              )),
              const SizedBox(height: 12),
              Text(
                '确定要清空全部 ${provider.continueChain.length} 个续写章节吗？',
                style: const TextStyle(color: GameColors.textLight, fontSize: 12)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    label: '取消',
                    color: GameColors.bg3,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    label: '清空',
                    color: GameColors.red,
                    onPressed: () {
                      Navigator.pop(ctx);
                      provider.clearContinueChain();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBatchGraphDialog(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: GameColors.dialogDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🗺️ 批量生成图谱', style: TextStyle(
                color: GameColors.green,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 12,
              )),
              const SizedBox(height: 12),
              Text(
                '将为全部 ${provider.chapters.length} 个章节生成知识图谱。\n'
                '生成结果将在完成后显示（成功N个，失败M个）。',
                style: const TextStyle(color: GameColors.textLight, fontSize: 12)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    label: '取消',
                    color: GameColors.bg3,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    label: '开始',
                    color: GameColors.green,
                    onPressed: () {
                      Navigator.pop(ctx);
                      provider.generateGraphsForAllChapters();
                      showPixelSnackBar(context, '已开始批量生成图谱...');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMergeDialog(BuildContext context, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: GameColors.dialogDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🔗 合并图谱', style: TextStyle(
                color: GameColors.pink,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 12,
              )),
              const SizedBox(height: 12),
              const Text(
                '将所有章节图谱合并为全局知识图谱，用于续写时的上下文参考。\n'
                '先分批合并（每批50章），再合并为全量图谱。',
                style: TextStyle(color: GameColors.textLight, fontSize: 12)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    label: '取消',
                    color: GameColors.bg3,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    label: '开始合并',
                    color: GameColors.pink,
                    onPressed: () async {
                      Navigator.pop(ctx);
                      showPixelSnackBar(context, '开始分批合并图谱...');
                      try {
                        await provider.batchMergeGraphs();
                        if (context.mounted && provider.batchMergedGraphs.isNotEmpty) {
                          await provider.mergeAllGraphs();
                          if (context.mounted) {
                            showPixelSnackBar(context, '图谱合并完成！');
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showPixelSnackBar(context, '合并失败: $e', isError: true);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContinueChainSheet(BuildContext context, NovelProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: GameColors.dialogDecoration().copyWith(
            color: GameColors.bg2,
          ),
          padding: const EdgeInsets.all(16),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, scrollController) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Text('⛓️ 续写链条', style: TextStyle(
                        color: GameColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      )),
                      const Spacer(),
                      PixelButton(
                        label: '✕',
                        color: GameColors.bg3,
                        padding: const EdgeInsets.all(8),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: GameColors.borderLight),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: provider.continueChain.length,
                      itemBuilder: (_, i) {
                        final c = provider.continueChain[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: GameColors.cardDecoration(color: GameColors.bg3),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.title,
                                style: const TextStyle(
                                  color: GameColors.textLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c.content.length > 80
                                    ? '${c.content.substring(0, 80)}...'
                                    : c.content,
                                style: const TextStyle(
                                  color: GameColors.textMuted,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _exportGraphs(BuildContext context, NovelProvider provider) {
    final json = provider.exportChapterGraphsJson();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: GameColors.dialogDecoration(),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📤 图谱数据', style: TextStyle(
                color: GameColors.textLight,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 12,
              )),
              const SizedBox(height: 12),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: GameColors.bg3,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: GameColors.borderDark, width: 1),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: SelectableText(
                    json.length > 2000 ? '${json.substring(0, 2000)}...' : json,
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                      color: GameColors.textLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    label: '关闭',
                    color: GameColors.bg3,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _importGraphs(BuildContext context, NovelProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: GameColors.dialogDecoration(),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📥 导入图谱', style: TextStyle(
                color: GameColors.blueLight,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 12,
              )),
              const SizedBox(height: 8),
              const Text(
                '请粘贴从「导出图谱」复制的内容（JSON格式）：',
                style: TextStyle(color: GameColors.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: GameColors.bg3,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: GameColors.borderLight, width: 2),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: GameColors.textLight,
                  ),
                  cursorColor: GameColors.blueBright,
                  decoration: const InputDecoration(
                    hintText: '{"exportTime": "...", "chapterGraphMap": {...}}',
                    hintStyle: TextStyle(color: GameColors.textMuted, fontSize: 11),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    label: '取消',
                    color: GameColors.bg3,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    label: '导入',
                    color: GameColors.blueLight,
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) {
                        showPixelSnackBar(ctx, '内容不能为空', isError: true);
                        return;
                      }
                      try {
                        provider.importChapterGraphsJson(text);
                        Navigator.pop(ctx);
                        showPixelSnackBar(context, '图谱导入成功！');
                      } catch (e) {
                        showPixelSnackBar(context, 'JSON格式错误: $e', isError: true);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrecheckDrawer(BuildContext context, NovelProvider provider) {
    final precheck = provider.precheckResult;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: GameColors.dialogDecoration().copyWith(color: GameColors.bg2),
          padding: const EdgeInsets.all(16),
          child: DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Text('🔍 前置校验详情', style: TextStyle(
                        color: GameColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      )),
                      const Spacer(),
                      if (precheck != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: precheck.isPass ? GameColors.green : GameColors.orange,
                            border: Border.all(color: GameColors.borderLight, width: 2),
                          ),
                          child: Text(
                            precheck.isPass ? '✅ 通过' : '⚠️ 未通过',
                            style: const TextStyle(color: GameColors.textLight, fontSize: 10),
                          ),
                        ),
                      const SizedBox(width: 8),
                      PixelButton(
                        label: '✕',
                        color: GameColors.bg3,
                        padding: const EdgeInsets.all(8),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: GameColors.borderLight),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(8),
                      children: [
                        if (precheck == null)
                          const Center(
                            child: Text(
                              '请点击「开始续写」触发前置校验',
                              style: TextStyle(color: GameColors.textMuted),
                            ),
                          )
                        else ...[
                          _PrecheckSection('🚫 人设红线', precheck.redLines, GameColors.red),
                          _PrecheckSection('⛔ 设定禁区', precheck.forbiddenRules, GameColors.orange),
                          _PrecheckSection('🔮 可呼应伏笔', precheck.foreshadowList, GameColors.pink),
                          _PrecheckSection('⚠️ 潜在矛盾预警', precheck.conflictWarning, GameColors.yellow),
                          _PrecheckSection('📖 可推进剧情方向', precheck.possiblePlotDirections, GameColors.blueLight),
                          _PrecheckSection('✅ 合规性报告', precheck.complianceReport, GameColors.green),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? GameColors.blue : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: selected ? GameColors.blueBright : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? GameColors.textLight : GameColors.textMuted,
              fontFamily: 'monospace',
              fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
              fontSize: 11,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: GameColors.bg2,
        border: Border.all(color: GameColors.borderLight, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: GameColors.textMuted,
          fontFamily: 'monospace',
          fontSize: 10,
        ),
      ),
    );
  }
}

class _PixelActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool enabled;
  final VoidCallback? onTap;

  const _PixelActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: GameColors.cardDecoration(
          color: enabled ? GameColors.bg2 : GameColors.bg3,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: enabled ? color.withOpacity(0.2) : GameColors.bg3,
                border: Border.all(
                  color: enabled ? color : GameColors.borderLight,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: enabled ? GameColors.textLight : GameColors.textMuted,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: enabled ? GameColors.textMuted : GameColors.textMuted.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (enabled)
              Text('›', style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          ],
        ),
      ),
    );
  }
}

class _PixelEmptyState extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Widget action;

  const _PixelEmptyState({
    required this.icon,
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
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: GameColors.textLight,
                fontFamily: 'monospace',
                fontFamilyFallback: ['Noto Sans SC'],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: GameColors.textMuted,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            action,
          ],
        ),
      ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Text(
              content.isEmpty ? '无' : content,
              style: const TextStyle(color: GameColors.textLight, fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChainChapterCardPixel extends StatelessWidget {
  final int index;
  final ContinueChapter chapter;
  final bool isGeneratingWrite;
  final VoidCallback onContinue;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  const _ChainChapterCardPixel({
    required this.index,
    required this.chapter,
    required this.isGeneratingWrite,
    required this.onContinue,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: GameColors.cardDecoration(color: GameColors.bg3),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: GameColors.orange,
                  border: Border.all(color: GameColors.borderLight, width: 2),
                ),
                child: Text(
                  '第${index + 1}章',
                  style: const TextStyle(
                    color: GameColors.textLight,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  chapter.content.length > 60
                      ? '${chapter.content.substring(0, 60)}...'
                      : chapter.content,
                  style: const TextStyle(color: GameColors.textMuted, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _MiniBtn(
                label: '▶️ 续写',
                color: GameColors.orange,
                enabled: !isGeneratingWrite,
                onTap: onContinue,
              ),
              const SizedBox(width: 6),
              _MiniBtn(
                label: '📋 复制',
                color: GameColors.blue,
                onTap: onCopy,
              ),
              const SizedBox(width: 6),
              _MiniBtn(
                label: '🗑️',
                color: GameColors.red,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _MiniBtn({
    required this.label,
    required this.color,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: enabled ? color : GameColors.bg2,
          border: Border.all(
            color: enabled ? GameColors.borderLight : GameColors.borderDark,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? GameColors.textLight : GameColors.textMuted,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}
