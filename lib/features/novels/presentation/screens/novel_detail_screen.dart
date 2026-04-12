import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/novel.dart';
import '../../domain/models/chapter.dart';
import '../providers/novel_providers.dart';
import '../../domain/usecases/graph_usecases.dart';
import 'chapter_editor_screen.dart';
import 'character_profile_screen.dart';
import 'world_setting_screen.dart';
import '../../../../app/theme/app_theme.dart';

class NovelDetailScreen extends ConsumerStatefulWidget {
  final Novel novel;

  const NovelDetailScreen({super.key, required this.novel});

  @override
  ConsumerState<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends ConsumerState<NovelDetailScreen>
    with TickerProviderStateMixin {
  late Novel _novel;
  late AnimationController _headerAnimController;
  late Animation<double> _headerFadeAnim;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _novel = widget.novel;
    _tabController = TabController(length: 3, vsync: this);
    _headerAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _headerFadeAnim = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(chapterListProvider(_novel.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(_novel.title),
        titleTextStyle: AppTypography.titleMedium,
        actions: [
          // Graph overview button
          IconButton(
            icon: const Icon(Icons.account_tree_outlined),
            tooltip: '图谱总览',
            onPressed: _showGraphOverview,
          ),
          // More menu
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') _editNovel();
              if (v == 'export') _exportTxt();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('编辑信息'),
                ],
              )),
              const PopupMenuItem(value: 'export', child: Row(
                children: [
                  Icon(Icons.file_download_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('导出TXT'),
                ],
              )),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== Tab Bar =====
          Container(
            color: AppColors.surfaceIvory,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryIndigo,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.primaryIndigo,
              tabs: const [
                Tab(text: '章节列表'),
                Tab(text: '图谱管理'),
                Tab(text: '小说设定'),
              ],
            ),
          ),
          // ===== Tab Content =====
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: 章节列表
                Column(
                  children: [
                    FadeTransition(
                      opacity: _headerFadeAnim,
                      child: _buildHeader(),
                    ),
                    Expanded(
                      child: chaptersAsync.when(
                        loading: () => ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: 3,
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ShimmerLoading(
                              width: double.infinity, height: 72,
                              borderRadius: AppRadius.borderMd,
                            ),
                          ),
                        ),
                        error: (e, _) => MiaobiEmptyState(
                          icon: Icons.error_outline,
                          title: '加载失败',
                          subtitle: e.toString(),
                        ),
                        data: (chapters) => chapters.isEmpty
                            ? _buildEmpty()
                            : _buildChapterList(chapters),
                      ),
                    ),
                  ],
                ),
                // Tab 2: 图谱管理
                _GraphManagementTab(novel: _novel),
                // Tab 3: 小说设定 (F7)
                _NovelSettingsTab(novel: _novel),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateOrChapterize,
        icon: const Icon(Icons.add),
        label: const Text('新建章节'),
        tooltip: '新建章节',
      ),
    );
  }

  Widget _buildHeader() {
    final totalWords = _novel.wordCount ?? 0;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryIndigo.withOpacity(0.08),
            AppColors.accentCoral.withOpacity(0.06),
          ],
        ),
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: AppColors.primaryIndigo.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 封面缩略图
              Hero(
                tag: 'novel-cover-${_novel.id}',
                child: Container(
                  width: 50,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.primaryIndigo.withOpacity(0.12),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Icon(
                    Icons.auto_stories_outlined,
                    color: AppColors.primaryIndigo.withOpacity(0.5),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_novel.author.isNotEmpty)
                      Text(
                        '作者: ${_novel.author}',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primaryIndigo,
                        ),
                      ),
                    if (_novel.introduction.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _novel.introduction,
                        style: AppTypography.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 统计信息
          Row(
            children: [
              _buildStatChip(Icons.text_fields, '$totalWords 字', AppColors.primaryIndigo),
              const SizedBox(width: 8),
              _buildStatChip(Icons.auto_awesome, 'AI辅助', AppColors.aiPurple),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.auto_fix_high, size: 20),
                tooltip: '智能分章',
                onPressed: _showAutoChapterizeDialog,
                color: AppColors.accentCoral,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() => MiaobiEmptyState(
        icon: Icons.edit_note_outlined,
        title: '还没有章节',
        subtitle: '开始创作第一章吧~\n或者使用智能分章导入内容',
        actionLabel: '新建章节',
        onAction: _createChapter,
      );

  Widget _buildChapterList(List<Chapter> chapters) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 100),
      itemCount: chapters.length,
      itemBuilder: (ctx, i) => _AnimatedChapterCard(
        chapter: chapters[i],
        index: i,
        onTap: () => _openChapter(chapters[i]),
        onDelete: () => _deleteChapter(chapters[i]),
      ),
    );
  }

  void _showCreateOrChapterize() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentCoral.withOpacity(0.1),
                  borderRadius: AppRadius.borderMd,
                ),
                child: const Icon(Icons.add, color: AppColors.accentCoral),
              ),
              title: const Text('新建章节'),
              subtitle: const Text('从空白开始写'),
              onTap: () {
                Navigator.pop(ctx);
                _createChapter();
              },
            ),
            ListTile(
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.aiPurple.withOpacity(0.1),
                  borderRadius: AppRadius.borderMd,
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.aiPurple),
              ),
              title: const Text('智能分章'),
              subtitle: const Text('粘贴内容自动分割章节'),
              onTap: () {
                Navigator.pop(ctx);
                _showAutoChapterizeDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _openChapter(Chapter chapter) {
    ref.read(selectedChapterProvider.notifier).state = chapter;
    Navigator.push(
      context,
      slideRoute(ChapterEditorScreen(novel: _novel, chapter: chapter)),
    );
  }

  Future<void> _createChapter() async {
    final chapters = ref.read(chapterListProvider(_novel.id)).valueOrNull ?? [];
    final nextNumber = chapters.length + 1;
    final controller = TextEditingController(text: '第$nextNumber章');

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新建章节'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '章节标题'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('创建'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final chapter = Chapter(
        id: '',
        novelId: _novel.id,
        number: nextNumber,
        title: result,
        createdAt: DateTime.now(),
      );
      final created = await ref
          .read(chapterListProvider(_novel.id).notifier)
          .create(chapter);
      if (created != null) _openChapter(created);
    }
  }

  Future<void> _deleteChapter(Chapter chapter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除章节'),
        content: Text('确定删除"${chapter.title}"？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(chapterListProvider(_novel.id).notifier).delete(chapter.id);
    }
  }

  Future<void> _showAutoChapterizeDialog() async {
    final contentController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.aiPurple, size: 20),
            const SizedBox(width: 8),
            const Text('智能分章'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '粘贴小说内容，系统将自动识别章节进行分割',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: '在此粘贴小说内容...',
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.borderMd,
                  ),
                ),
                maxLines: 10,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('开始分章'),
          ),
        ],
      ),
    );

    if (result == true && contentController.text.isNotEmpty) {
      await ref
          .read(chapterListProvider(_novel.id).notifier)
          .autoChapterize(contentController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('分章完成！'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _editNovel() async {
    final titleCtrl = TextEditingController(text: _novel.title);
    final authorCtrl = TextEditingController(text: _novel.author);
    final introCtrl = TextEditingController(text: _novel.introduction);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('编辑小说信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: '书名')),
            const SizedBox(height: 12),
            TextField(controller: authorCtrl, decoration: const InputDecoration(labelText: '作者')),
            const SizedBox(height: 12),
            TextField(controller: introCtrl, decoration: const InputDecoration(labelText: '简介'), maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('保存')),
        ],
      ),
    );

    if (result == true) {
      final updated = _novel.copyWith(
        title: titleCtrl.text,
        author: authorCtrl.text,
        introduction: introCtrl.text,
      );
      final updateUseCase = ref.read(updateNovelUseCaseProvider);
      await updateUseCase(updated);
      setState(() => _novel = updated);
    }
  }

  Future<void> _exportTxt() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('导出功能开发中...')),
    );
  }

  Future<void> _showGraphOverview() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('图谱总览开发中...')),
    );
  }
}

/// ============================================================
/// 动画章节卡片
/// ============================================================
class _AnimatedChapterCard extends StatefulWidget {
  final Chapter chapter;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AnimatedChapterCard({
    required this.chapter,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_AnimatedChapterCard> createState() => _AnimatedChapterCardState();
}

class _AnimatedChapterCardState extends State<_AnimatedChapterCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _slideAnim = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: widget.index * 30), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: Opacity(opacity: _fadeAnim.value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Dismissible(
          key: Key(widget.chapter.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: AppRadius.borderMd,
            ),
            child: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('删除章节'),
                content: Text('确定删除"${widget.chapter.title}"？'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('删除', style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => widget.onDelete(),
          child: _ChapterCard(
            chapter: widget.chapter,
            onTap: widget.onTap,
            onDelete: widget.onDelete,
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// 章节卡片
/// ============================================================
class _ChapterCard extends StatefulWidget {
  final Chapter chapter;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChapterCard({
    required this.chapter,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<_ChapterCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.borderMd,
        boxShadow: _isPressed ? null : AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderMd,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          borderRadius: AppRadius.borderMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // 序号圆
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.chapter.graphId != null
                        ? AppColors.aiPurple.withOpacity(0.12)
                        : AppColors.primaryIndigo.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.chapter.number}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: widget.chapter.graphId != null
                            ? AppColors.aiPurple
                            : AppColors.primaryIndigo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 章节信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.chapter.title,
                              style: AppTypography.titleMedium.copyWith(fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.chapter.graphId != null)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.aiPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppRadius.xl),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.account_tree, size: 10, color: AppColors.aiPurple),
                                  const SizedBox(width: 3),
                                  Text(
                                    '图谱',
                                    style: TextStyle(fontSize: 10, color: AppColors.aiPurple, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.chapter.wordCount} 字',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                // 操作
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: widget.onDelete,
                  color: AppColors.textTertiary,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//   F4: Graph Management Tab
// ═══════════════════════════════════════════════════════════════

class _GraphManagementTab extends ConsumerStatefulWidget {
  final Novel novel;
  const _GraphManagementTab({required this.novel});

  @override
  ConsumerState<_GraphManagementTab> createState() => _GraphManagementTabState();
}

class _GraphManagementTabState extends ConsumerState<_GraphManagementTab> {
  bool _isGenerating = false;
  bool _isMerging = false;
  bool _isExporting = false;
  bool _isImporting = false;
  int _batchSize = 50;
  double _mergeProgress = 0.0;
  String? _mergeResult;

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(chapterListProvider(widget.novel.id));

    return chaptersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('加载失败: $e')),
      data: (chapters) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // ── 统计卡片 ──
          _buildStatsCard(chapters),
          const SizedBox(height: 16),

          // ── 操作按钮区 ──
          _buildActionButtons(chapters),
          const SizedBox(height: 16),

          // ── 进度/结果区 ──
          if (_isGenerating || _isMerging || _mergeResult != null)
            _buildProgressArea(),

          // ── 章节图谱状态列表 ──
          _buildChapterGraphList(chapters),
        ],
      ),
    );
  }

  Widget _buildStatsCard(List<Chapter> chapters) {
    final generatedCount = chapters.where((c) => c.graphId != null).length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.aiPurple.withOpacity(0.1),
            AppColors.primaryIndigo.withOpacity(0.06),
          ],
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        children: [
          _statItem('总章节', '${chapters.length}'),
          const SizedBox(width: 24),
          _statItem('已生成图谱', '$generatedCount', color: AppColors.success),
          const SizedBox(width: 24),
          _statItem('未生成', '${chapters.length - generatedCount}',
              color: chapters.length - generatedCount > 0 ? AppColors.warning : null),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(List<Chapter> chapters) {
    final ungenerated = chapters.where((c) => c.graphId == null).toList();
    return Column(
      children: [
        // F8: 导入导出按钮
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.file_upload_outlined,
                title: '导出图谱',
                subtitle: '导出JSON备份',
                color: AppColors.success,
                isLoading: _isExporting,
                onTap: _isExporting ? null : () => _exportGraphs(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.file_download_outlined,
                title: '导入图谱',
                subtitle: '从JSON恢复',
                color: AppColors.primaryLight,
                isLoading: _isImporting,
                onTap: _isImporting ? null : () => _importGraphs(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 生成分章图谱
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.auto_awesome,
                title: '生成分章图谱',
                subtitle: '为${ungenerated.length}个章节生成AI图谱',
                color: AppColors.aiPurple,
                isLoading: _isGenerating,
                onTap: ungenerated.isEmpty || _isGenerating
                    ? null
                    : () => _generateChapterGraphs(ungenerated),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.merge,
                title: '分批合并图谱',
                subtitle: '每批 $_batchSize 章',
                color: AppColors.accentCoral,
                isLoading: _isMerging,
                onTap: chapters.length < 2 || _isMerging
                    ? null
                    : () => _showBatchMergeDialog(chapters),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 整体合并
        _ActionCard(
          icon: Icons.account_tree,
          title: '整体合并图谱',
          subtitle: '合并所有章节图谱为全局知识图谱',
          color: AppColors.primaryIndigo,
          isLoading: _isMerging,
          onTap: chapters.length < 2 || _isMerging
              ? null
              : () => _mergeAllGraphs(chapters),
        ),
      ],
    );
  }

  Widget _buildProgressArea() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.borderMd,
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_isGenerating || _isMerging)
                const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(Icons.check_circle, size: 16, color: AppColors.success),
              const SizedBox(width: 8),
              Text(
                _isGenerating
                    ? '正在生成图谱...'
                    : _isMerging
                        ? '正在合并图谱...'
                        : '处理完成',
                style: AppTypography.labelMedium,
              ),
            ],
          ),
          if (_isMerging) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(value: _mergeProgress),
            const SizedBox(height: 4),
            Text(
              '${(_mergeProgress * 100).toInt()}%',
              style: AppTypography.caption,
            ),
          ],
          if (_mergeResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceIvory,
                borderRadius: AppRadius.borderSm,
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _mergeResult!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => setState(() => _mergeResult = null),
              icon: const Icon(Icons.close, size: 16),
              label: const Text('关闭'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChapterGraphList(List<Chapter> chapters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('章节图谱状态', style: AppTypography.titleMedium),
        const SizedBox(height: 8),
        ...chapters.map((chapter) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: AppRadius.borderSm,
                  boxShadow: AppShadows.cardShadow,
                ),
                child: Row(
                  children: [
                    Icon(
                      chapter.graphId != null
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 16,
                      color: chapter.graphId != null
                          ? AppColors.success
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        chapter.title,
                        style: AppTypography.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      chapter.graphId != null ? '已生成' : '未生成',
                      style: AppTypography.caption.copyWith(
                        color: chapter.graphId != null
                            ? AppColors.success
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Future<void> _generateChapterGraphs(List<Chapter> ungenerated) async {
    setState(() => _isGenerating = true);
    try {
      final generator = ref.read(advancedGraphGeneratorProvider);
      for (var i = 0; i < ungenerated.length; i++) {
        final chapter = ungenerated[i];
        try {
          await generator.generateSingleChapterGraph(
            chapterId: chapter.id,
            chapterTitle: chapter.title,
            content: chapter.content,
            chapterNumber: chapter.number,
          );
        } catch (e) {
          // Skip failed chapters silently
        }
      }
      if (mounted) {
        ref.invalidate(chapterListProvider(widget.novel.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('图谱生成完成！共处理 ${ungenerated.length} 个章节'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _showBatchMergeDialog(List<Chapter> chapters) async {
    final controller = TextEditingController(text: '$_batchSize');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('分批合并图谱'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('将 ${chapters.length} 个章节图谱分批合并'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '每批章节数',
                hintText: '默认 50',
              ),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null && parsed > 0) {
                  _batchSize = parsed.clamp(10, 100);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('开始合并')),
        ],
      ),
    );

    if (confirmed == true) {
      await _batchMerge(chapters);
    }
  }

  Future<void> _batchMerge(List<Chapter> chapters) async {
    setState(() {
      _isMerging = true;
      _mergeProgress = 0.0;
      _mergeResult = null;
    });

    try {
      final graphRepo = ref.read(graphRepositoryProvider);
      final graphs = await graphRepo.getAdvancedGraphsForNovel(widget.novel.id);
      if (graphs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('没有找到已生成的章节图谱，请先生成图谱'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        return;
      }

      final batchUseCase = ref.read(batchMergeGraphsUseCaseProvider);
      final totalBatches = (graphs.length / _batchSize).ceil();
      final batchResults = <BatchMergeResult>[];

      await for (final result in batchUseCase.call(
        graphs: graphs,
        batchSize: _batchSize,
        novelId: widget.novel.id,
      )) {
        batchResults.add(result);
        if (mounted) {
          setState(() {
            _mergeProgress = (result.batchIndex + 1) / totalBatches;
          });
        }
      }

      // Save merged result preview
      if (mounted) {
        setState(() {
          _mergeResult = '分批合并完成！共 ${batchResults.length} 批次\n'
              '首批批次章节: ${batchResults.firstOrNull?.chapterIds.join(", ") ?? "-"}';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('合并失败: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isMerging = false);
    }
  }

  Future<void> _mergeAllGraphs(List<Chapter> chapters) async {
    setState(() {
      _isMerging = true;
      _mergeProgress = 0.0;
      _mergeResult = null;
    });

    try {
      final graphRepo = ref.read(graphRepositoryProvider);
      final graphs = await graphRepo.getAdvancedGraphsForNovel(widget.novel.id);
      if (graphs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('没有找到已生成的章节图谱，请先生成图谱'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        return;
      }

      // Merge all graphs into one
      final merged = await graphRepo.mergeAll(graphs, widget.novel.id);

      if (mounted) {
        setState(() {
          _mergeProgress = 1.0;
          _mergeResult = '整体合并完成！\n'
              '人物库: ${merged.characterPool.length} 人\n'
              '实体关系: ${merged.entityNetwork.length} 条\n'
              '伏笔线索: ${merged.worldSettingPool.allForeshadows.length} 条';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('合并失败: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isMerging = false);
    }
  }

  // F8: Export graphs to JSON
  Future<void> _exportGraphs() async {
    setState(() => _isExporting = true);
    try {
      final graphRepo = ref.read(graphRepositoryProvider);
      final jsonStr = await graphRepo.exportAllGraphs(widget.novel.id);

      if (mounted) {
        setState(() => _isExporting = false);
        // Show export result in snackbar (actual file save requires file_picker package)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('图谱已导出，共 ${jsonStr.length} 字符\n（实际保存需file_picker支持）'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导出失败: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // F8: Import graphs from JSON
  Future<void> _importGraphs() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_download_outlined, size: 20),
            SizedBox(width: 8),
            Text('导入图谱'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '请粘贴之前导出的图谱JSON数据',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: '在此粘贴JSON...',
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.borderMd,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('导入'),
          ),
        ],
      ),
    );

    if (confirmed == null || confirmed.isEmpty) return;

    setState(() => _isImporting = true);
    try {
      final graphRepo = ref.read(graphRepositoryProvider);
      await graphRepo.importGraphs(widget.novel.id, confirmed);

      if (mounted) {
        ref.invalidate(chapterListProvider(widget.novel.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图谱导入成功！'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导入失败: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//   F7: Novel Settings Tab
// ═══════════════════════════════════════════════════════════════

class _NovelSettingsTab extends ConsumerWidget {
  final Novel novel;

  const _NovelSettingsTab({required this.novel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.surfaceIvory,
            child: TabBar(
              labelColor: AppColors.primaryIndigo,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.primaryIndigo,
              tabs: const [
                Tab(text: '角色管理'),
                Tab(text: '世界观设定'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                CharacterProfileScreen(novelId: novel.id),
                WorldSettingScreen(novelId: novel.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isLoading;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return Material(
      color: isDisabled
          ? AppColors.cardWhite.withOpacity(0.6)
          : AppColors.cardWhite,
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderMd,
            boxShadow: isDisabled ? null : AppShadows.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: AppRadius.borderSm,
                ),
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color,
                        ),
                      )
                    : Icon(icon, color: isDisabled ? AppColors.textTertiary : color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelMedium.copyWith(
                        color: isDisabled ? AppColors.textTertiary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isDisabled && !isLoading)
                Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
