import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/character_profile.dart';
import '../providers/novel_providers.dart';
import '../../../../app/theme/app_theme.dart';

// ─── F7: Character Profile Screen ─────────────────────────────

class CharacterProfileScreen extends ConsumerStatefulWidget {
  final String novelId;

  const CharacterProfileScreen({super.key, required this.novelId});

  @override
  ConsumerState<CharacterProfileScreen> createState() => _CharacterProfileScreenState();
}

class _CharacterProfileScreenState extends ConsumerState<CharacterProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(_characterProfilesProvider(widget.novelId));

    return Scaffold(
      body: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (profiles) => profiles.isEmpty
            ? _buildEmpty()
            : _buildProfileList(profiles),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProfileEditor(null),
        backgroundColor: AppColors.primaryIndigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_add_outlined, size: 64, color: AppColors.textTertiary),
        const SizedBox(height: 16),
        Text('暂无角色', style: AppTypography.titleMedium),
        const SizedBox(height: 8),
        Text('点击下方 + 添加角色及其人设红线', style: AppTypography.caption),
      ],
    ),
  );

  Widget _buildProfileList(List<CharacterProfile> profiles) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: profiles.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _CharacterProfileCard(
          profile: profiles[i],
          onTap: () => _showProfileEditor(profiles[i]),
          onDelete: () => _deleteProfile(profiles[i]),
        ),
      ),
    );
  }

  Future<void> _deleteProfile(CharacterProfile profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除角色'),
        content: Text('确定删除 "${profile.name}"？'),
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
      final repo = ref.read(characterProfileRepositoryProvider);
      await repo.delete(profile.id);
      ref.invalidate(_characterProfilesProvider(widget.novelId));
    }
  }

  Future<void> _showProfileEditor(CharacterProfile? existing) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _CharacterProfileEditor(
        novelId: widget.novelId,
        existing: existing,
      ),
    );

    if (result == true) {
      ref.invalidate(_characterProfilesProvider(widget.novelId));
    }
  }
}

// ─── Character Profile Card ───────────────────────────────────
class _CharacterProfileCard extends StatelessWidget {
  final CharacterProfile profile;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CharacterProfileCard({
    required this.profile,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardWhite,
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderMd,
            boxShadow: AppShadows.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryIndigo.withOpacity(0.12),
                    child: Text(
                      profile.name.isNotEmpty ? profile.name[0] : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryIndigo,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: AppTypography.titleMedium),
                        if (profile.alias.isNotEmpty)
                          Text(
                            '别名: ${profile.alias}',
                            style: AppTypography.caption,
                          ),
                      ],
                    ),
                  ),
                  if (profile.redLines.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.block, size: 11, color: AppColors.error),
                          const SizedBox(width: 3),
                          Text(
                            '${profile.redLines.length} 条红线',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: onDelete,
                    color: AppColors.textTertiary,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              if (profile.personality.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  profile.personality,
                  style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (profile.redLines.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: profile.redLines.take(3).map((line) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      line,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.error,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Character Profile Editor ─────────────────────────────────
class _CharacterProfileEditor extends ConsumerStatefulWidget {
  final String novelId;
  final CharacterProfile? existing;

  const _CharacterProfileEditor({
    required this.novelId,
    this.existing,
  });

  @override
  ConsumerState<_CharacterProfileEditor> createState() => _CharacterProfileEditorState();
}

class _CharacterProfileEditorState extends ConsumerState<_CharacterProfileEditor> {
  late TextEditingController _nameController;
  late TextEditingController _aliasController;
  late TextEditingController _personalityController;
  late List<String> _redLines;
  late List<String> _backstories;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _aliasController = TextEditingController(text: widget.existing?.alias ?? '');
    _personalityController = TextEditingController(text: widget.existing?.personality ?? '');
    _redLines = List.from(widget.existing?.redLines ?? []);
    _backstories = List.from(widget.existing?.backstories ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _personalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.person_add,
                    color: AppColors.primaryIndigo,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? '编辑角色' : '新建角色',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primaryIndigo,
                    ),
                  ),
                  const Spacer(),
                  if (_isSaving)
                    const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context, false),
                      color: AppColors.textTertiary,
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '角色名称 *',
                        hintText: '输入角色名称',
                        border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Alias
                    TextField(
                      controller: _aliasController,
                      decoration: InputDecoration(
                        labelText: '别名/昵称',
                        hintText: '角色的其他称呼',
                        border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Personality
                    TextField(
                      controller: _personalityController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: '性格特点',
                        hintText: '描述角色的性格、行为风格',
                        border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ─── Red Lines Section ──────────────────────
                    _sectionHeader(
                      '人设红线 *',
                      '角色绝对不能做的事',
                      Icons.block,
                      AppColors.error,
                    ),
                    const SizedBox(height: 8),
                    ..._redLines.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _redLineItem(entry.key, entry.value),
                    )),
                    const SizedBox(height: 4),
                    _addRedLineButton(),
                    const SizedBox(height: 16),

                    // ─── Backstories Section ───────────────────
                    _sectionHeader(
                      '背景故事',
                      '角色的过往经历',
                      Icons.history_edu,
                      AppColors.primaryIndigo,
                    ),
                    const SizedBox(height: 8),
                    ..._backstories.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _backstoryItem(entry.key, entry.value),
                    )),
                    const SizedBox(height: 4),
                    _addBackstoryButton(),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nameController.text.isEmpty || _isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryIndigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isEditing ? '保存修改' : '创建角色'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text('— $subtitle', style: AppTypography.caption),
      ],
    );
  }

  Widget _redLineItem(int index, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.06),
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.remove_circle_outline, size: 16, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTypography.bodyMedium),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => setState(() => _redLines.removeAt(index)),
            color: AppColors.textTertiary,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _backstoryItem(int index, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceIvory,
        borderRadius: AppRadius.borderSm,
      ),
      child: Row(
        children: [
          Icon(Icons.auto_stories, size: 16, color: AppColors.primaryIndigo),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTypography.bodyMedium),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => setState(() => _backstories.removeAt(index)),
            color: AppColors.textTertiary,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _addRedLineButton() {
    return OutlinedButton.icon(
      onPressed: () => _showAddRedLineDialog(),
      icon: const Icon(Icons.add, size: 16),
      label: const Text('添加红线'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: BorderSide(color: AppColors.error.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _addBackstoryButton() {
    return OutlinedButton.icon(
      onPressed: () => _showAddBackstoryDialog(),
      icon: const Icon(Icons.add, size: 16),
      label: const Text('添加背景'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryIndigo,
        side: BorderSide(color: AppColors.primaryIndigo.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Future<void> _showAddRedLineDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加人设红线'),
        content: TextField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: '例如：角色A绝对不能背叛主角',
            border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('添加'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _redLines.add(result));
    }
  }

  Future<void> _showAddBackstoryDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加背景故事'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '描述角色的过往经历...',
            border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('添加'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _backstories.add(result));
    }
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(characterProfileRepositoryProvider);
      final profile = CharacterProfile(
        id: widget.existing?.id ?? const Uuid().v4(),
        novelId: widget.novelId,
        name: _nameController.text,
        alias: _aliasController.text,
        personality: _personalityController.text,
        redLines: _redLines,
        backstories: _backstories,
      );

      if (widget.existing != null) {
        await repo.update(profile);
      } else {
        await repo.create(profile);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────
final _characterProfilesProvider = FutureProvider.family<List<CharacterProfile>, String>((ref, novelId) async {
  final repo = ref.read(characterProfileRepositoryProvider);
  return repo.getByNovel(novelId);
});
