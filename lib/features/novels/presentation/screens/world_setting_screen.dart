import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/character_profile.dart';
import '../providers/novel_providers.dart';
import '../../../../app/theme/app_theme.dart';

// ─── F7: Novel World Setting Screen ───────────────────────────

class WorldSettingScreen extends ConsumerStatefulWidget {
  final String novelId;

  const WorldSettingScreen({super.key, required this.novelId});

  @override
  ConsumerState<WorldSettingScreen> createState() => _WorldSettingScreenState();
}

class _WorldSettingScreenState extends ConsumerState<WorldSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(_worldSettingsProvider(widget.novelId));

    return Scaffold(
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (settings) => settings.isEmpty
            ? _buildEmpty()
            : _buildSettingList(settings),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSettingEditor(null),
        backgroundColor: AppColors.aiPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.public_outlined, size: 64, color: AppColors.textTertiary),
        const SizedBox(height: 16),
        Text('暂无世界观设定', style: AppTypography.titleMedium),
        const SizedBox(height: 8),
        Text('点击下方 + 创建世界设定', style: AppTypography.caption),
      ],
    ),
  );

  Widget _buildSettingList(List<NovelWorldSetting> settings) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: settings.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _WorldSettingCard(
          setting: settings[i],
          onTap: () => _showSettingEditor(settings[i]),
          onDelete: () => _deleteSetting(settings[i]),
        ),
      ),
    );
  }

  Future<void> _deleteSetting(NovelWorldSetting setting) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除世界观设定'),
        content: const Text('确定删除该世界观设定？'),
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
      final repo = ref.read(worldSettingRepositoryProvider);
      await repo.delete(setting.id);
      ref.invalidate(_worldSettingsProvider(widget.novelId));
    }
  }

  Future<void> _showSettingEditor(NovelWorldSetting? existing) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _WorldSettingEditor(
        novelId: widget.novelId,
        existing: existing,
      ),
    );

    if (result == true) {
      ref.invalidate(_worldSettingsProvider(widget.novelId));
    }
  }
}

// ─── World Setting Card ───────────────────────────────────────
class _WorldSettingCard extends StatelessWidget {
  final NovelWorldSetting setting;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _WorldSettingCard({
    required this.setting,
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
                  Icon(Icons.public, color: AppColors.aiPurple, size: 20),
                  const SizedBox(width: 8),
                  Text('世界观设定', style: AppTypography.titleMedium),
                  const Spacer(),
                  if (setting.forbiddenRules.isNotEmpty)
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
                            '${setting.forbiddenRules.length}禁区',
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

              const SizedBox(height: 10),
              // Setting items
              _settingRow(Icons.access_time, '时代背景', setting.era),
              _settingRow(Icons.map, '地理区域', setting.geography),
              _settingRow(Icons.bolt, '力量体系', setting.powerSystem),
              _settingRow(Icons.groups, '社会结构', setting.society),

              if (setting.forbiddenRules.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: setting.forbiddenRules.take(3).map((rule) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(color: AppColors.error.withOpacity(0.2)),
                    ),
                    child: Text(
                      rule,
                      style: TextStyle(fontSize: 11, color: AppColors.error),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                ),
              ],

              if (setting.foreshadows.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '伏笔: ${setting.foreshadows.length}条',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.aiPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── World Setting Editor ──────────────────────────────────────
class _WorldSettingEditor extends ConsumerStatefulWidget {
  final String novelId;
  final NovelWorldSetting? existing;

  const _WorldSettingEditor({
    required this.novelId,
    this.existing,
  });

  @override
  ConsumerState<_WorldSettingEditor> createState() => _WorldSettingEditorState();
}

class _WorldSettingEditorState extends ConsumerState<_WorldSettingEditor> {
  late TextEditingController _eraController;
  late TextEditingController _geographyController;
  late TextEditingController _powerSystemController;
  late TextEditingController _societyController;
  late List<String> _forbiddenRules;
  late List<Foreshadow> _foreshadows;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _eraController = TextEditingController(text: widget.existing?.era ?? '');
    _geographyController = TextEditingController(text: widget.existing?.geography ?? '');
    _powerSystemController = TextEditingController(text: widget.existing?.powerSystem ?? '');
    _societyController = TextEditingController(text: widget.existing?.society ?? '');
    _forbiddenRules = List.from(widget.existing?.forbiddenRules ?? []);
    _foreshadows = List.from(widget.existing?.foreshadows ?? []);
  }

  @override
  void dispose() {
    _eraController.dispose();
    _geographyController.dispose();
    _powerSystemController.dispose();
    _societyController.dispose();
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
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Icon(Icons.public, color: AppColors.aiPurple, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? '编辑世界观' : '新建世界观',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.aiPurple,
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
                    TextField(
                      controller: _eraController,
                      decoration: InputDecoration(
                        labelText: '时代背景',
                        hintText: '例如：架空仙侠世界',
                        prefixIcon: Icon(Icons.access_time, size: 18, color: AppColors.textTertiary),
                        border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _geographyController,
                      decoration: InputDecoration(
                        labelText: '地理区域',
                        hintText: '例如：九州大陆、四大帝国',
                        prefixIcon: Icon(Icons.map, size: 18, color: AppColors.textTertiary),
                        border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _powerSystemController,
                      decoration: InputDecoration(
                        labelText: '力量体系',
                        hintText: '例如：修真体系、魔法体系',
                        prefixIcon: Icon(Icons.bolt, size: 18, color: AppColors.textTertiary),
                        border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _societyController,
                      decoration: InputDecoration(
                        labelText: '社会结构',
                        hintText: '例如：宗门林立、王朝更迭',
                        prefixIcon: Icon(Icons.groups, size: 18, color: AppColors.textTertiary),
                        border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Forbidden Rules
                    _sectionHeader('设定禁区 *', Icons.block, AppColors.error),
                    const SizedBox(height: 8),
                    ..._forbiddenRules.asMap().entries.map((e) => _forbiddenRuleItem(e.key, e.value)),
                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: _showAddForbiddenDialog,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('添加禁区'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Foreshadows
                    _sectionHeader('伏笔列表', Icons.auto_awesome, AppColors.aiPurple),
                    const SizedBox(height: 8),
                    ..._foreshadows.asMap().entries.map((e) => _foreshadowItem(e.key, e.value)),
                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: _showAddForeshadowDialog,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('添加伏笔'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.aiPurple,
                        side: BorderSide(color: AppColors.aiPurple.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.aiPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isEditing ? '保存修改' : '创建设定'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color) {
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
      ],
    );
  }

  Widget _forbiddenRuleItem(int index, String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.06),
          borderRadius: AppRadius.borderSm,
          border: Border.all(color: AppColors.error.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.block, size: 14, color: AppColors.error),
            const SizedBox(width: 8),
            Expanded(child: Text(rule, style: AppTypography.bodyMedium)),
            IconButton(
              icon: const Icon(Icons.close, size: 14),
              onPressed: () => setState(() => _forbiddenRules.removeAt(index)),
              color: AppColors.textTertiary,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foreshadowItem(int index, Foreshadow f) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.aiPurpleLight.withOpacity(0.3),
          borderRadius: AppRadius.borderSm,
        ),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, size: 14, color: AppColors.aiPurple),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.title, style: AppTypography.bodyMedium),
                  if (f.description.isNotEmpty)
                    Text(f.description, style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: f.isResolved
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Text(
                f.isResolved ? '已回收' : '待回收',
                style: TextStyle(
                  fontSize: 10,
                  color: f.isResolved ? AppColors.success : AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 14),
              onPressed: () => setState(() => _foreshadows.removeAt(index)),
              color: AppColors.textTertiary,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddForbiddenDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加设定禁区'),
        content: TextField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: '例如：仙人不干涉凡间事务',
            border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('添加')),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _forbiddenRules.add(result));
    }
  }

  Future<void> _showAddForeshadowDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加伏笔'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: '伏笔标题',
                hintText: '例如：神秘老人的身份',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: '伏笔描述',
                hintText: '简要描述伏笔内容',
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, {
              'title': titleController.text,
              'description': descController.text,
            }),
            child: const Text('添加'),
          ),
        ],
      ),
    );

    if (result != null && result['title'].toString().isNotEmpty) {
      setState(() {
        _foreshadows.add(Foreshadow(
          id: const Uuid().v4(),
          title: result['title'],
          description: result['description'] ?? '',
          isResolved: false,
        ));
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(worldSettingRepositoryProvider);
      final setting = NovelWorldSetting(
        id: widget.existing?.id ?? const Uuid().v4(),
        novelId: widget.novelId,
        era: _eraController.text,
        geography: _geographyController.text,
        powerSystem: _powerSystemController.text,
        society: _societyController.text,
        forbiddenRules: _forbiddenRules,
        foreshadows: _foreshadows,
      );

      if (widget.existing != null) {
        await repo.update(setting);
      } else {
        await repo.create(setting);
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
final _worldSettingsProvider = FutureProvider.family<List<NovelWorldSetting>, String>((ref, novelId) async {
  final repo = ref.read(worldSettingRepositoryProvider);
  return repo.getByNovel(novelId);
});
