import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/novel.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/chapter_graph.dart';
import '../providers/novel_providers.dart';
import '../../../writing/domain/usecases/writing_usecases.dart';
import '../../domain/models/writing_config.dart';
import '../../../../app/theme/app_theme.dart';

class ChapterEditorScreen extends ConsumerStatefulWidget {
  final Novel novel;
  final Chapter chapter;

  const ChapterEditorScreen({
    super.key,
    required this.novel,
    required this.chapter,
  });

  @override
  ConsumerState<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends ConsumerState<ChapterEditorScreen>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late Chapter _chapter;
  bool _isGenerating = false;
  String _generatedContent = '';
  bool _showAiResult = false;
  bool _isSaved = true;

  //  F5 State 
  bool _showPreWritePanel = false;
  PreCheckResult? _preCheckResult;
  bool _isPreChecking = false;
  Chapter? _selectedReferenceChapter;

  //  F6 State 
  QualityEvaluationReport? _qualityReport;
  bool _isEvaluating = false;
  bool _showQualityCard = false;

  // 
  late AnimationController _saveAnimController;
  late Animation<double> _saveFadeAnim;
  bool _showSaveIndicator = false;

  // AI 
  String _displayedContent = '';

  @override
  void initState() {
    super.initState();
    _chapter = widget.chapter;
    _controller = TextEditingController(text: _chapter.content);
    _controller.addListener(_onTextChanged);

    _saveAnimController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _saveFadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _saveAnimController, curve: Curves.easeOut),
    );
    _saveAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            _saveAnimController.reverse().then((_) {
              if (mounted) setState(() => _showSaveIndicator = false);
            });
          }
        });
      }
    });
  }

  void _onTextChanged() {
    if (_isSaved) setState(() => _isSaved = false);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _saveAnimController.dispose();
    super.dispose();
  }

  WritingConfig _getDefaultConfig() => const WritingConfig(
    provider: 'siliconflow',
    model: 'Pro',
    temperature: 0.8,
    maxTokens: 500,
    topP: 0.9,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              _chapter.title,
              style: AppTypography.titleMedium.copyWith(fontSize: 16),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _showSaveIndicator
                  ? FadeTransition(
                      opacity: _saveFadeAnim,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 10, color: AppColors.success),
                          const SizedBox(width: 3),
                          Text(
                            '',
                            style: TextStyle(fontSize: 10, color: AppColors.success),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      _isSaved ? '' : '',
                      style: TextStyle(
                        fontSize: 10,
                        color: _isSaved ? Colors.transparent : AppColors.warning,
                      ),
                    ),
            ),
          ],
        ),
        titleSpacing: 0,
        actions: [
          _buildAiMenuButton(),
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: '',
            onPressed: _saveChapter,
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'graph') _showGraphDialog();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'graph',
                child: Row(
                  children: [
                    Icon(Icons.account_tree_outlined, size: 18),
                    SizedBox(width: 8),
                    Text(''),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          //  F5:  
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showPreWritePanel
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: _buildPreWritePanel(),
          ),

          //  F6:  
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showQualityCard && _qualityReport != null
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: _buildQualityEvaluationCard(),
          ),

          //   
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                color: AppColors.writingAreaBg,
                borderRadius: AppRadius.borderLg,
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: AppRadius.borderLg,
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: '...',
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  ),
                  style: AppTypography.bodyLarge.copyWith(
                    height: 1.8,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
          ),

          //  AI  
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _showAiResult
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: _buildAiResultPanel(),
          ),

          //   
          _buildStatusBar(),
        ],
      ),
    );
  }

  //  F5:  
  Widget _buildPreWritePanel() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Icon(Icons.assignment_turned_in, color: AppColors.aiPurple, size: 18),
                const SizedBox(width: 8),
                Text(
                  '',
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 15,
                    color: AppColors.aiPurple,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() {
                    _showPreWritePanel = false;
                    _preCheckResult = null;
                  }),
                  color: AppColors.textTertiary,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          //  / 
          if (_preCheckResult != null)
            _buildPreCheckResultView()
          else if (_isPreChecking)
            _buildPreCheckLoading()
          else
            _buildPreCheckForm(),

          // 
          if (_preCheckResult != null && _preCheckResult!.isPass)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    setState(() => _showPreWritePanel = false);
                    _startAIWriting();
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text(' AI '),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.aiPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreCheckForm() {
    final chaptersAsync = ref.watch(chapterListProvider(widget.novel.id));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('', style: AppTypography.labelMedium),
          const SizedBox(height: 8),
          chaptersAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text(': $e', style: TextStyle(color: AppColors.error)),
            data: (chapters) {
              // Filter out current chapter
              final otherChapters = chapters.where((c) => c.id != _chapter.id).toList();
              if (otherChapters.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: AppRadius.borderSm,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '暂无其他章节',
                          style: AppTypography.caption.copyWith(color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Chapter>(
                    value: _selectedReferenceChapter,
                    decoration: InputDecoration(
                      hintText: '',
                      border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: otherChapters.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.title, style: AppTypography.bodyMedium),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedReferenceChapter = v),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _runPreCheck,
                      icon: const Icon(Icons.assignment_turned_in_outlined, size: 16),
                      label: const Text('开始校验'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.aiPurple,
                        side: BorderSide(color: AppColors.aiPurple),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreCheckLoading() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text('...', style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPreCheckResultView() {
    final r = _preCheckResult!;
    final isPass = r.isPass;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPass
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: AppRadius.borderSm,
              border: Border.all(
                color: isPass
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPass ? Icons.check_circle : Icons.warning,
                  size: 18,
                  color: isPass ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isPass ? '校验通过' : '发现问题',
                    style: AppTypography.labelMedium.copyWith(
                      color: isPass ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (r.logicIssues.isNotEmpty) ...[
            const SizedBox(height: 8),
            _preCheckItem('逻辑问题', r.logicIssues.join('\n'), Icons.trending_up, AppColors.primaryIndigo),
          ],
          if (r.characterConsistency.isNotEmpty) ...[
            const SizedBox(height: 8),
            _preCheckItem('人物一致性', r.characterConsistency.join('\n'), Icons.person_outline, AppColors.warning),
          ],
          if (r.redLines.isNotEmpty) ...[
            const SizedBox(height: 8),
            _preCheckItem('人设红线', r.redLines.join('\n'), Icons.block, AppColors.error),
          ],
          if (r.worldViolations.isNotEmpty) ...[
            const SizedBox(height: 8),
            _preCheckItem('世界观违规', r.worldViolations.join('\n'), Icons.auto_awesome, AppColors.aiPurple),
          ],
          if (r.settingInconsistency.isNotEmpty) ...[
            const SizedBox(height: 8),
            _preCheckItem('设定不一致', r.settingInconsistency.join('\n'), Icons.warning_amber, AppColors.accentCoral),
          ],
          if (r.qualityWarnings.isNotEmpty) ...[
            const SizedBox(height: 8),
            _preCheckItem('质量警告', r.qualityWarnings.join('\n'), Icons.fact_check_outlined, AppColors.textSecondary),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _runPreCheck,
                  icon: const Icon(Icons.refresh, size: 14),
                  label: const Text('重新校验'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.aiPurple,
                    side: BorderSide(color: AppColors.aiPurple.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() {
                    _preCheckResult = null;
                    _showPreWritePanel = false;
                  }),
                  style: TextButton.styleFrom(foregroundColor: AppColors.textTertiary),
                  child: const Text(''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preCheckItem(String title, String content, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: AppRadius.borderSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(fontSize: 12),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  //  F6:  
  Widget _buildQualityEvaluationCard() {
    final report = _qualityReport;
    if (report == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 380),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, color: AppColors.primaryIndigo, size: 18),
                const SizedBox(width: 8),
                Text(
                  '质量评估',
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 15,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: report.isPass
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Text(
                    report.isPass ? '合格' : '不合格',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: report.isPass ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() {
                    _showQualityCard = false;
                    _qualityReport = null;
                  }),
                  color: AppColors.textTertiary,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // 
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                // 
                Row(
                  children: [
                    Text(
                      '总分',
                      style: AppTypography.labelMedium,
                    ),
                    const Spacer(),
                    Text(
                      '${report.totalScore.toStringAsFixed(0)} ',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primaryIndigo,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: report.totalScore / 100,
                  backgroundColor: AppColors.primaryIndigo.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(
                    report.totalScore >= 85 ? AppColors.success : AppColors.warning,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),

                const SizedBox(height: 12),

                // 
                _scoreBar('人设一致性', report.characterConsistencyScore),
                const SizedBox(height: 6),
                _scoreBar('设定合规性', report.worldSettingComplianceScore),
                const SizedBox(height: 6),
                _scoreBar('剧情衔接度', report.plotContinuityScore),
                const SizedBox(height: 6),
                _scoreBar('文风匹配度', report.writingStyleMatchScore),
                const SizedBox(height: 6),
                _scoreBar('内容质量', report.contentQualityScore),

                if (report.evaluationReport.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceIvory,
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: Text(
                      report.evaluationReport,
                      style: AppTypography.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // 
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _acceptGeneratedWithQuality,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(''),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _regenerateWithQuality,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.aiPurple,
                          side: BorderSide(color: AppColors.aiPurple),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(''),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        onPressed: _discardGenerated,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textTertiary,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _scoreBar(String label, double score) {
    final isPass = score >= 80;
    final color = isPass ? AppColors.success : AppColors.warning;
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            score.toStringAsFixed(0),
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  //  AI  F6  
  Widget _buildAiResultPanel() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: AppColors.aiPurpleLight.withOpacity(0.25),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        border: Border(
          top: BorderSide(
            color: AppColors.aiPurple.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.aiPurple, size: 16),
                const SizedBox(width: 6),
                Text(
                  'AI ',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.aiPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isEvaluating) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 12, height: 12,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '...',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.aiPurple,
                      fontSize: 11,
                    ),
                  ),
                ],
                const Spacer(),
                if (_generatedContent.isNotEmpty && !_isEvaluating && !_showQualityCard)
                  FilledButton(
                    onPressed: () => _evaluateQuality(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryIndigo,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      minimumSize: Size.zero,
                    ),
                    child: const Text(''),
                  ),
                if (_generatedContent.isNotEmpty && !_isEvaluating && !_showQualityCard) ...[
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: _acceptGenerated,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentCoral,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      minimumSize: Size.zero,
                    ),
                    child: const Text(''),
                  ),
                ],
                const SizedBox(width: 4),
                TextButton(
                  onPressed: _discardGenerated,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    minimumSize: Size.zero,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text(''),
                ),
              ],
            ),
          ),
          if (_generatedContent.isNotEmpty)
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  _displayedContent.isEmpty ? _generatedContent : _displayedContent,
                  style: AppTypography.bodyLarge.copyWith(fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAiMenuButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isGenerating
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : IconButton(
              key: const ValueKey('ai_btn'),
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: _showAiResult ? AppColors.aiPurple : AppColors.primaryIndigo,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _showAiResult ? AppColors.aiPurple : AppColors.primaryIndigo,
                    ),
                  ),
                ],
              ),
              tooltip: 'AI',
              onPressed: _showPreWriteSettings,
            ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: ScaleTransition(
                  scale: animation,
                  child: child,
                ));
              },
              child: Text(
                '${_controller.text.length} ',
                key: ValueKey(_controller.text.length),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primaryIndigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (_showAiResult && _isGenerating)
              SizedBox(
                width: 60,
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.aiPurple.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(AppColors.aiPurple),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            const Spacer(),
            Text(
              _chapter.title,
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }

  //  F5: Pre-write Settings 
  void _showPreWriteSettings() {
    setState(() {
      _showPreWritePanel = true;
      _preCheckResult = null;
      _selectedReferenceChapter = null;
    });
  }

  Future<void> _runPreCheck() async {
    setState(() {
      _isPreChecking = true;
      _preCheckResult = null;
    });

    try {
      final useCase = ref.read(preWriteValidationUseCaseProvider);
      final result = await useCase(
        novelId: widget.novel.id,
        currentChapterContent: _controller.text,
        referenceChapterId: _selectedReferenceChapter?.id ?? '',
      );
      if (mounted) {
        setState(() {
          _preCheckResult = result;
          _isPreChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(': $e'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _isPreChecking = false;
          _showPreWritePanel = false;
        });
      }
    }
  }

  //  F5: Start AI Writing 
  Future<void> _startAIWriting() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _generatedContent = '';
      _displayedContent = '';
      _showAiResult = true;
      _showQualityCard = false;
      _qualityReport = null;
    });

    try {
      final useCase = ref.read(generateContinuationUseCaseProvider);

      await for (final token in useCase(
        context: _controller.text,
        characters: '',
        relationships: '',
        config: _getDefaultConfig(),
        maxWords: 500,
      )) {
        setState(() {
          _generatedContent += token;
          if (_displayedContent.length < 200) {
            _displayedContent += token;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI: $e'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() => _showAiResult = false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _displayedContent = _generatedContent;
        });
      }
    }
  }

  //  F6: Quality Evaluation 
  Future<void> _evaluateQuality() async {
    if (_generatedContent.isEmpty || _isEvaluating) return;

    setState(() => _isEvaluating = true);

    try {
      final useCase = ref.read(qualityEvaluateUseCaseProvider);
      final report = await useCase(
        originalContext: _controller.text,
        generatedContent: _generatedContent,
        characterPool: const [], // Empty for now, will be populated from merged graph
        writingStyleGuide: null,
      );

      if (mounted) {
        setState(() {
          _qualityReport = report;
          _isEvaluating = false;
          _showQualityCard = true;
          _showAiResult = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isEvaluating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(': $e'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }
  }

  void _acceptGeneratedWithQuality() {
    _acceptGenerated();
    setState(() {
      _showQualityCard = false;
      _qualityReport = null;
    });
  }

  void _regenerateWithQuality() {
    setState(() {
      _showQualityCard = false;
      _qualityReport = null;
    });
    _startAIWriting();
  }

  void _acceptGenerated() {
    _controller.text += _generatedContent;
    _discardGenerated();
  }

  void _discardGenerated() {
    setState(() {
      _generatedContent = '';
      _displayedContent = '';
      _showAiResult = false;
      _showQualityCard = false;
      _qualityReport = null;
    });
  }

  Future<void> _saveChapter() async {
    final updated = _chapter.copyWith(
      content: _controller.text,
      wordCount: _controller.text.length,
    );
    await ref
        .read(chapterListProvider(widget.novel.id).notifier)
        .update(updated);
    _chapter = updated;
    if (mounted) {
      setState(() {
        _isSaved = true;
        _showSaveIndicator = true;
      });
      _saveAnimController.forward();
    }
  }

  Future<void> _showGraphDialog() async {
    final selectedType = await showModalBottomSheet<GraphType>(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('', style: AppTypography.titleMedium),
            ),
            const SizedBox(height: 12),
            _graphTypeTile(
              Icons.people_outline,
              '',
              '',
              AppColors.nodeCharacter,
              () => Navigator.pop(ctx, GraphType.characterRelationship),
            ),
            _graphTypeTile(
              Icons.timeline_outlined,
              '',
              '',
              AppColors.nodeEvent,
              () => Navigator.pop(ctx, GraphType.plotTimeline),
            ),
            _graphTypeTile(
              Icons.map_outlined,
              '',
              '',
              AppColors.nodeLocation,
              () => Navigator.pop(ctx, GraphType.locationMap),
            ),
            _graphTypeTile(
              Icons.mood_outlined,
              '',
              '',
              AppColors.nodeEmotion,
              () => Navigator.pop(ctx, GraphType.emotionAnalysis),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (selectedType != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getGraphTypeName(selectedType)}...'),
          backgroundColor: AppColors.aiPurple,
        ),
      );
    }
  }

  Widget _graphTypeTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: AppRadius.borderMd,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 15)),
      subtitle: Text(subtitle, style: AppTypography.caption),
      onTap: onTap,
    );
  }

  String _getGraphTypeName(GraphType type) {
    switch (type) {
      case GraphType.characterRelationship: return '';
      case GraphType.plotTimeline: return '';
      case GraphType.locationMap: return '';
      case GraphType.emotionAnalysis: return '';
    }
  }
}
