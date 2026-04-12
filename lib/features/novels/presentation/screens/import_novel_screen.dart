import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/novel_providers.dart';
import '../../domain/usecases/chapter_usecases.dart';
import '../../../../app/theme/app_theme.dart';

class ImportNovelScreen extends ConsumerStatefulWidget {
  const ImportNovelScreen({super.key});

  @override
  ConsumerState<ImportNovelScreen> createState() => _ImportNovelScreenState();
}

class _ImportNovelScreenState extends ConsumerState<ImportNovelScreen> {
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _introCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _autoChapterize = true;
  ChapterRegexPreset _selectedPreset = ChapterRegexPreset.standard;
  final _customRegexCtrl = TextEditingController();
  bool _useCustomRegex = false;
  bool _showAdvanced = false;

  // Preview state
  List<String> _previewTitles = [];
  bool _isLoadingPreview = false;
  String? _selectedFileName;
  String? _encodingLabel;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _introCtrl.dispose();
    _contentCtrl.dispose();
    _customRegexCtrl.dispose();
    super.dispose();
  }

  // ─── File Picking & Encoding Detection ───────────────────────

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final path = file.path;
    if (path == null) return;

    setState(() {
      _selectedFileName = file.name;
    });

    // Try UTF-8 first, then GBK
    String? content;
    String? encoding;

    try {
      final bytes = await File(path).readAsBytes();
      // Try UTF-8
      try {
        content = utf8.decode(bytes, allowMalformed: true);
        encoding = 'UTF-8';
      } catch (_) {
        // Fallback to GBK (Latin1 as fallback which covers GBK single-byte range)
        content = latin1.decode(bytes);
        encoding = 'GBK';
      }

      // Detect BOM
      if (bytes.length >= 3 &&
          bytes[0] == 0xEF &&
          bytes[1] == 0xBB &&
          bytes[2] == 0xBF) {
        content = utf8.decode(bytes.sublist(3), allowMalformed: true);
        encoding = 'UTF-8 (BOM)';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('文件读取失败: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() {
      _contentCtrl.text = content ?? '';
      _encodingLabel = encoding;
    });

    _updatePreview();
  }

  // ─── Preview Chapter Split ──────────────────────────────────

  Future<void> _updatePreview() async {
    final content = _contentCtrl.text;
    if (content.isEmpty) {
      setState(() => _previewTitles = []);
      return;
    }

    setState(() => _isLoadingPreview = true);

    try {
      final useCase = ref.read(autoChapterizeUseCaseProvider);
      final result = await useCase.call(
        content,
        'temp-preview-novel',
        preset: _useCustomRegex ? null : _selectedPreset,
        customRegex: _useCustomRegex ? _customRegexCtrl.text : null,
      );
      if (mounted) {
        setState(() {
          _previewTitles = result.detectedTitles;
          _isLoadingPreview = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPreview = false);
      }
    }
  }

  // ─── Import Logic ───────────────────────────────────────────

  Future<void> _import() async {
    if (_titleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('请输入书名'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Create novel first
    final createUseCase = ref.read(createNovelUseCaseProvider);
    final novel = await createUseCase(
      title: _titleCtrl.text,
      author: _authorCtrl.text.isEmpty ? null : _authorCtrl.text,
      introduction: _introCtrl.text.isEmpty ? null : _introCtrl.text,
    );

    if (novel != null && mounted) {
      // Auto chapterize if enabled
      if (_autoChapterize && _contentCtrl.text.isNotEmpty) {
        final notifier = ref.read(chapterListProvider(novel.id).notifier);
        await notifier.autoChapterize(
          _contentCtrl.text,
          preset: _useCustomRegex ? null : _selectedPreset,
          customRegex: _useCustomRegex ? _customRegexCtrl.text : null,
        );
      }

      // Refresh the novel list before popping
      ref.read(novelListProvider.notifier).load();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已导入《${novel.title}》'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  // ─── UI ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入小说'),
        titleTextStyle: AppTypography.titleMedium,
        actions: [
          FilledButton(
            onPressed: _import,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: const Text('导入'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // ===== 书名 =====
          _buildSectionLabel('书名信息'),
          const SizedBox(height: 8),
          _buildInputCard(
            child: TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: '书名',
                hintText: '输入小说名称',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(height: 12),

          // ===== 作者 =====
          _buildSectionLabel('作者信息（可选）'),
          const SizedBox(height: 8),
          _buildInputCard(
            child: TextField(
              controller: _authorCtrl,
              decoration: const InputDecoration(
                labelText: '作者',
                hintText: '输入作者名称',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ===== 简介 =====
          _buildSectionLabel('简介（可选）'),
          const SizedBox(height: 8),
          _buildInputCard(
            child: TextField(
              controller: _introCtrl,
              decoration: const InputDecoration(
                labelText: '一句话简介',
                hintText: '简单描述这个故事',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 24),

          // ===== 小说内容 =====
          _buildSectionLabel('小说内容'),
          const SizedBox(height: 4),
          Text(
            '选择 TXT 文件或直接粘贴文本',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 12),

          // 文件选择按钮
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_open_outlined, size: 18),
                label: Text(_selectedFileName ?? '选择TXT文件'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryIndigo,
                  side: const BorderSide(color: AppColors.primaryIndigo),
                ),
              ),
              if (_encodingLabel != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.aiPurple.withOpacity(0.1),
                    borderRadius: AppRadius.borderSm,
                  ),
                  child: Text(
                    _encodingLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.aiPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // 自动分章 Switch（卡片式）
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: AppRadius.borderMd,
              boxShadow: AppShadows.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.aiPurple.withOpacity(0.1),
                    borderRadius: AppRadius.borderSm,
                  ),
                  child: const Icon(Icons.auto_fix_high, color: AppColors.aiPurple, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('自动分章', style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('根据章节标题自动分割章节', style: AppTypography.caption),
                    ],
                  ),
                ),
                Switch(
                  value: _autoChapterize,
                  onChanged: (v) => setState(() => _autoChapterize = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 章节格式预设（展开）
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: AppRadius.borderMd,
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                  borderRadius: AppRadius.borderMd,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                    child: Row(
                      children: [
                        Icon(Icons.tune, color: AppColors.aiPurple, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('章节格式预设', style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(
                                _useCustomRegex
                                    ? '自定义正则'
                                    : _selectedPreset.label,
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _showAdvanced ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showAdvanced) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Preset selector
                        Text('选择预设格式', style: AppTypography.labelMedium),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ChapterRegexPreset.values.map((preset) {
                            final isSelected = !_useCustomRegex && _selectedPreset == preset;
                            return ChoiceChip(
                              label: Text(preset.label),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedPreset = preset;
                                  _useCustomRegex = false;
                                });
                                _updatePreview();
                              },
                              selectedColor: AppColors.aiPurple.withOpacity(0.2),
                              labelStyle: TextStyle(
                                fontSize: 12,
                                color: isSelected ? AppColors.aiPurple : AppColors.textSecondary,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Custom regex toggle
                        Row(
                          children: [
                            Checkbox(
                              value: _useCustomRegex,
                              onChanged: (v) {
                                setState(() => _useCustomRegex = v ?? false);
                                _updatePreview();
                              },
                              activeColor: AppColors.aiPurple,
                            ),
                            Text('使用自定义正则', style: AppTypography.bodyMedium),
                          ],
                        ),
                        if (_useCustomRegex) ...[
                          const SizedBox(height: 8),
                          TextField(
                            controller: _customRegexCtrl,
                            decoration: InputDecoration(
                              hintText: '输入自定义正则表达式（支持多行模式）',
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.borderSm,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                            onChanged: (_) => _updatePreview(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 分章预览
          if (_previewTitles.isNotEmpty || _isLoadingPreview) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.aiPurple.withOpacity(0.05),
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.aiPurple.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.preview, size: 16, color: AppColors.aiPurple),
                      const SizedBox(width: 6),
                      Text(
                        '分章预览',
                        style: AppTypography.labelMedium.copyWith(color: AppColors.aiPurple),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.aiPurple.withOpacity(0.15),
                          borderRadius: AppRadius.borderXl,
                        ),
                        child: Text(
                          '${_previewTitles.length} 章',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.aiPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingPreview)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 120),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _previewTitles.map((title) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.cardWhite,
                                borderRadius: AppRadius.borderSm,
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 内容输入区
          Container(
            constraints: const BoxConstraints(minHeight: 200),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: AppColors.divider),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              children: [
                // 字数统计栏
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceIvory,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.md - 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.article_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '字数: ${_contentCtrl.text.length}',
                        style: AppTypography.caption,
                      ),
                      const Spacer(),
                      if (_contentCtrl.text.isEmpty)
                        Text(
                          '粘贴 .txt 内容或选择文件导入',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                // 内容 TextField
                TextField(
                  controller: _contentCtrl,
                  decoration: const InputDecoration(
                    hintText: '在此粘贴小说内容...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLines: null,
                  minLines: 8,
                  onChanged: (_) {
                    setState(() {});
                    _updatePreview();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 导入按钮
          FilledButton.icon(
            onPressed: _import,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('开始导入'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppTypography.labelMedium.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: AppRadius.borderMd,
        boxShadow: AppShadows.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: child,
    );
  }
}


