import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/novel.dart';
import '../providers/novel_providers.dart';
import 'novel_detail_screen.dart';
import 'import_novel_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../../app/theme/app_theme.dart';

class NovelListScreen extends ConsumerStatefulWidget {
  const NovelListScreen({super.key});

  @override
  ConsumerState<NovelListScreen> createState() => _NovelListScreenState();
}

class _NovelListScreenState extends ConsumerState<NovelListScreen>
    with TickerProviderStateMixin {
  bool _isSearchOpen = false;
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  late AnimationController _searchAnimController;
  late Animation<double> _searchWidthAnim;

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _searchWidthAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _searchAnimController, curve: Curves.easeOutCubic),
    );
    Future.microtask(() => ref.read(novelListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _searchAnimController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _isSearchOpen = !_isSearchOpen);
    if (_isSearchOpen) {
      _searchAnimController.forward();
      _searchFocus.requestFocus();
    } else {
      _searchAnimController.reverse();
      _searchCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final novelsAsync = ref.watch(novelListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('妙笔'),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.primaryIndigo,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          // Search toggle
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                key: ValueKey(_isSearchOpen),
              ),
            ),
            onPressed: _toggleSearch,
            tooltip: '搜索',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              slideRoute(const SettingsScreen()),
            ),
            tooltip: '设置',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AnimatedBuilder(
            animation: _searchWidthAnim,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _searchWidthAnim,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: _searchCtrl,
                    focusNode: _searchFocus,
                    decoration: InputDecoration(
                      hintText: '搜索小说...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: AppColors.cardWhite,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        borderSide: const BorderSide(color: AppColors.primaryIndigo, width: 1.5),
                      ),
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: novelsAsync.when(
        loading: () => _buildShimmerList(),
        error: (e, _) => Center(
          child: MiaobiEmptyState(
            icon: Icons.error_outline,
            title: '加载失败',
            subtitle: e.toString(),
            actionLabel: '重试',
            onAction: () => ref.read(novelListProvider.notifier).load(),
          ),
        ),
        data: (novels) {
          final query = _searchCtrl.text.toLowerCase();
          final filtered = query.isEmpty
              ? novels
              : novels.where((n) =>
                  n.title.toLowerCase().contains(query) ||
                  n.author.toLowerCase().contains(query)).toList();
          return filtered.isEmpty
              ? (query.isEmpty ? _buildEmpty() : _buildNoResults())
              : _buildList(filtered);
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 4,
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }

  Widget _buildNoResults() {
    return MiaobiEmptyState(
      icon: Icons.search_off,
      title: '没有找到相关小说',
      subtitle: '换个关键词试试吧~',
    );
  }

  Widget _buildFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Import FAB with label
        FloatingActionButton.small(
          heroTag: 'import_fab',
          onPressed: () => Navigator.push(
            context,
            slideRoute(const ImportNovelScreen()),
          ),
          backgroundColor: AppColors.primaryIndigo,
          tooltip: '导入小说',
          child: const Icon(Icons.file_upload_outlined, size: 20),
        ),
        const SizedBox(height: 12),
        // Create FAB
        FloatingActionButton(
          heroTag: 'create_fab',
          onPressed: _showCreateDialog,
          tooltip: '创建新小说',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildEmpty() => MiaobiEmptyState(
        icon: Icons.auto_stories_outlined,
        title: '还没有小说',
        subtitle: '开始创作你的第一本小说吧~\n或者导入已有文件',
        actionLabel: '创建小说',
        onAction: _showCreateDialog,
      );

  Widget _buildList(List<Novel> novels) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 100),
            itemCount: novels.length,
            itemBuilder: (ctx, i) => _AnimatedNovelCard(
              novel: novels[i],
              index: i,
              onTap: () => _openNovel(novels[i]),
              onDelete: () => _deleteNovel(novels[i]),
            ),
          ),
        ),
        // Bottom count indicator
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            '已加载 ${novels.length} 本小说',
            style: AppTypography.caption,
          ),
        ),
      ],
    );
  }

  void _openNovel(Novel novel) {
    ref.read(selectedNovelProvider.notifier).state = novel;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => NovelDetailScreen(novel: novel),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, animation, __, child) {
          final slideAnim = Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ));
          return SlideTransition(
            position: slideAnim,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteNovel(Novel novel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除小说'),
        content: Text('确定要删除《${novel.title}》吗？所有章节将被删除！'),
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
      ref.read(novelListProvider.notifier).delete(novel.id);
    }
  }

  Future<void> _showCreateDialog() async {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final introCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('创建新小说'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: '书名', hintText: '输入小说名称'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: authorCtrl,
                decoration: const InputDecoration(labelText: '作者（可选）'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: introCtrl,
                decoration: const InputDecoration(labelText: '简介（可选）'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('创建')),
        ],
      ),
    );

    if (result == true && titleCtrl.text.isNotEmpty) {
      final createUseCase = ref.read(createNovelUseCaseProvider);
      final novel = await createUseCase(
        title: titleCtrl.text,
        author: authorCtrl.text.isEmpty ? null : authorCtrl.text,
        introduction: introCtrl.text.isEmpty ? null : introCtrl.text,
      );
      if (novel != null && mounted) {
        _openNovel(novel);
      }
    }
  }
}

/// ============================================================
/// 动画小说卡片（Staggered 出现 + Press 反馈）
/// ============================================================
class _AnimatedNovelCard extends StatefulWidget {
  final Novel novel;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AnimatedNovelCard({
    required this.novel,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_AnimatedNovelCard> createState() => _AnimatedNovelCardState();
}

class _AnimatedNovelCardState extends State<_AnimatedNovelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    // Staggered delay
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: Opacity(
            opacity: _fadeAnim.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _NovelCard(
          novel: widget.novel,
          isPressed: _isPressed,
          onTap: widget.onTap,
          onDelete: widget.onDelete,
          onTapDown: () => setState(() => _isPressed = true),
          onTapUp: () => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
        ),
      ),
    );
  }
}

/// ============================================================
/// 小说卡片
/// ============================================================
class _NovelCard extends StatelessWidget {
  final Novel novel;
  final bool isPressed;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapCancel;

  const _NovelCard({
    required this.novel,
    required this.isPressed,
    required this.onTap,
    required this.onDelete,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..scale(isPressed ? 0.97 : 1.0),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.borderLg,
        boxShadow: isPressed ? null : AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderLg,
        child: InkWell(
          onTap: onTap,
          onTapDown: (_) => onTapDown?.call(),
          onTapUp: (_) => onTapUp?.call(),
          onTapCancel: onTapCancel,
          borderRadius: AppRadius.borderLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Hero 封面图
                Hero(
                  tag: 'novel-cover-${novel.id}',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryIndigo.withOpacity(0.1),
                      borderRadius: AppRadius.borderMd,
                      image: novel.cover != null
                          ? DecorationImage(
                              image: NetworkImage(novel.cover!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: novel.cover == null
                        ? Icon(
                            Icons.auto_stories_outlined,
                            color: AppColors.primaryIndigo.withOpacity(0.4),
                            size: 28,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                // 信息区
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        novel.title,
                        style: AppTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (novel.author.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          novel.author,
                          style: AppTypography.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (novel.introduction.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          novel.introduction,
                          style: AppTypography.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            _formatDate(novel.updatedAt),
                            style: AppTypography.caption,
                          ),
                          if (novel.wordCount != null && novel.wordCount! > 0) ...[
                            const SizedBox(width: 8),
                            MiaobiBadge(
                              label: '${(novel.wordCount! / 10000).toStringAsFixed(1)}W字',
                              color: AppColors.primaryIndigo,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // 更多按钮
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'delete') onDelete();
                  },
                  icon: const Icon(Icons.more_vert, color: AppColors.textTertiary, size: 20),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                          SizedBox(width: 8),
                          Text('删除', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
