import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/chapter.dart';
import '../../../../models/novel_book.dart';
import '../../../../services/storage_service.dart';
import '../../../../services/novel_api_service.dart';

/// v5.0 Writing State
class WritingState {
  final List<ContinueChapter> continueChain;
  final int continueIdCounter;
  final String selectedBaseChapterId;
  final String writePreview;
  final Map<String, dynamic>? precheckResult;
  final Map<String, dynamic>? qualityResult;
  final bool qualityResultShow;
  final bool isGenerating;
  final bool stopFlag;
  final String progressText;
  final String? error;

  const WritingState({
    this.continueChain = const [],
    this.continueIdCounter = 1,
    this.selectedBaseChapterId = '',
    this.writePreview = '',
    this.precheckResult,
    this.qualityResult,
    this.qualityResultShow = false,
    this.isGenerating = false,
    this.stopFlag = false,
    this.progressText = '',
    this.error,
  });

  WritingState copyWith({
    List<ContinueChapter>? continueChain,
    int? continueIdCounter,
    String? selectedBaseChapterId,
    String? writePreview,
    Map<String, dynamic>? precheckResult,
    Map<String, dynamic>? qualityResult,
    bool? qualityResultShow,
    bool? isGenerating,
    bool? stopFlag,
    String? progressText,
    String? error,
  }) {
    return WritingState(
      continueChain: continueChain ?? this.continueChain,
      continueIdCounter: continueIdCounter ?? this.continueIdCounter,
      selectedBaseChapterId: selectedBaseChapterId ?? this.selectedBaseChapterId,
      writePreview: writePreview ?? this.writePreview,
      precheckResult: precheckResult ?? this.precheckResult,
      qualityResult: qualityResult ?? this.qualityResult,
      qualityResultShow: qualityResultShow ?? this.qualityResultShow,
      isGenerating: isGenerating ?? this.isGenerating,
      stopFlag: stopFlag ?? this.stopFlag,
      progressText: progressText ?? this.progressText,
      error: error,
    );
  }
}

/// v5.0 Writing Notifier - Riverpod StateNotifier for writing feature
/// Keeps existing logic (from NovelProvider) but exposed via Riverpod
class WritingNotifier extends StateNotifier<WritingState> {
  final NovelApiService? apiService;
  final int _writeWordCount;
  final bool _enableQualityCheck;
  final bool _autoUpdateGraphAfterWrite;
  final Map<int, Map<String, dynamic>> Function() getChapterGraphMap;
  final Chapter? Function(int id) getChapterById;
  final Map<String, dynamic>? Function() getMergedGraph;
  final Future<Map<String, dynamic>?> Function(int, String) updateGraphWithContinueContent;

  WritingNotifier({
    required this.apiService,
    required int writeWordCount,
    required bool enableQualityCheck,
    required bool autoUpdateGraphAfterWrite,
    required this.getChapterGraphMap,
    required this.getChapterById,
    required this.getMergedGraph,
    required this.updateGraphWithContinueContent,
  })  : _writeWordCount = writeWordCount,
        _enableQualityCheck = enableQualityCheck,
        _autoUpdateGraphAfterWrite = autoUpdateGraphAfterWrite,
        super(const WritingState());

  void selectBaseChapter(String chapterId) {
    state = state.copyWith(
      selectedBaseChapterId: chapterId,
      precheckResult: null,
      writePreview: '',
      qualityResult: null,
      qualityResultShow: false,
    );
  }

  void addToChain(String content, {String? title, int? baseChapterId}) {
    final newChapter = ContinueChapter(
      id: state.continueIdCounter,
      title: title ?? '续写章节 ${state.continueChain.length + 1}',
      content: content,
      baseChapterId: baseChapterId ?? -1,
    );
    state = state.copyWith(
      continueChain: [...state.continueChain, newChapter],
      continueIdCounter: state.continueIdCounter + 1,
    );
  }

  void removeFromChain(int chainId) {
    state = state.copyWith(
      continueChain: state.continueChain.where((c) => c.id != chainId).toList(),
    );
  }

  void clearChain() {
    state = state.copyWith(continueChain: [], continueIdCounter: 1);
  }

  void clearPreview() {
    state = state.copyWith(
      writePreview: '',
      qualityResult: null,
      qualityResultShow: false,
    );
  }

  void stop() {
    state = state.copyWith(stopFlag: true, isGenerating: false, progressText: '');
  }

  void _resetStop() {
    state = state.copyWith(stopFlag: false);
  }

  /// Load state from persisted data
  void loadFromPersist({
    required List<ContinueChapter> chain,
    required int counter,
    required String preview,
    Map<String, dynamic>? precheck,
    Map<String, dynamic>? quality,
    bool qualityShow = false,
  }) {
    state = state.copyWith(
      continueChain: chain,
      continueIdCounter: counter,
      writePreview: preview,
      precheckResult: precheck,
      qualityResult: quality,
      qualityResultShow: qualityShow,
    );
  }

  /// Main write generation - delegates to existing logic
  Future<String?> generateWrite({
    Chapter? baseChapter,
    String? modifiedContent,
    Map<int, Map<String, dynamic>>? chapterGraphMap,
  }) async {
    if (apiService == null || state.selectedBaseChapterId.isEmpty) return null;

    final baseId = int.tryParse(state.selectedBaseChapterId) ?? 0;
    final chapter = baseChapter ?? getChapterById(baseId);
    if (chapter == null) return null;

    final baseContent = modifiedContent ?? chapter.content;
    final paragraphs = baseContent.split('\n').where((p) => p.trim().isNotEmpty).toList();
    final lastParagraph = paragraphs.isNotEmpty ? paragraphs.last.trim() : '';

    state = state.copyWith(isGenerating: true, progressText: '正在执行前置校验...', error: null);
    _resetStop();

    try {
      // Precheck
      final preChapters = getChapterGraphMap().keys
          .where((id) => id <= baseId && id >= (baseId - 5))
          .map((id) => id)
          .toList();
      final preGraphList = preChapters
          .map((id) => chapterGraphMap?[id] ?? getChapterGraphMap()[id])
          .whereType<Map<String, dynamic>>()
          .toList();

      Map<String, dynamic>? preResult;
      try {
        preResult = await apiService!.precheckContinuation(
          baseChapterId: baseId,
          preGraphList: preGraphList,
          modifiedChapterContent: modifiedContent,
        );
      } catch (_) {}

      final precheck = preResult ?? {
        'isPass': true,
        'preMergedGraph': <String, dynamic>{},
        'redLines': '无',
        'forbiddenRules': '无',
        'foreshadowList': '无明确可呼应伏笔',
        'conflictWarning': '无',
        'possiblePlotDirections': '推进主线剧情',
        'complianceReport': '直接续写',
      };

      final useGraph = (precheck['preMergedGraph'] as Map?)?.isNotEmpty == true
          ? precheck['preMergedGraph']
          : getMergedGraph();

      final systemPrompt = '''小说续写规则（100%遵守）：
人设锁定：续写内容必须完全贴合小说的核心人物设定，严格遵守人设红线：${precheck['redLines'] ?? '无'}
设定合规：严格遵守设定禁区：${precheck['forbiddenRules'] ?? '无'}
文本衔接：续写内容必须紧接在基准章节的最后一段之后开始，基准章节最后一段是："$lastParagraph"
剧情承接：合理呼应伏笔：${precheck['foreshadowList'] ?? '无'}，开启新章节
文风统一：完全贴合原文的叙事风格、语言习惯、节奏特点
字数要求：约$_writeWordCount字，误差不超过10%
矛盾规避：${precheck['conflictWarning'] ?? '无'}
输出要求：只输出续写的正文内容，不要任何标题、章节名、解释''';

      final userPrompt = '小说核心设定知识图谱：$useGraph\n基准章节内容：$baseContent\n请基于以上内容，按照规则续写后续的章节正文。';

      state = state.copyWith(
        progressText: '正在生成续写章节...',
        precheckResult: precheck,
      );

      String content = await apiService!.generateContinuation(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
        targetWordCount: _writeWordCount,
      );

      if (state.stopFlag) {
        state = state.copyWith(writePreview: '');
        return null;
      }

      // Quality check
      if (_enableQualityCheck) {
        state = state.copyWith(progressText: '正在执行质量校验...');

        final quality = await apiService!.evaluateQuality(
          continueContent: content,
          precheckResult: precheck,
          baseGraph: useGraph ?? {},
          baseChapterContent: baseContent,
          targetWordCount: _writeWordCount,
        );

        if (state.stopFlag) {
          state = state.copyWith(writePreview: '');
          return null;
        }

        final qualityMap = quality as Map<String, dynamic>;
        final passed = qualityMap['isPassed'] == true;
        state = state.copyWith(
          qualityResult: qualityMap,
          qualityResultShow: true,
        );

        if (!passed && !state.stopFlag) {
          state = state.copyWith(progressText: '质量不合格，正在重新生成...');
          content = await apiService!.generateContinuation(
            systemPrompt: '$systemPrompt\n注意：本次续写必须修正以下问题：${qualityMap['评估报告'] ?? ''}',
            userPrompt: userPrompt,
            targetWordCount: _writeWordCount,
          );
          if (state.stopFlag) return null;
          state = state.copyWith(qualityResult: null);
        }
      }

      state = state.copyWith(writePreview: content);

      // Add to chain
      final newChapter = ContinueChapter(
        id: state.continueIdCounter,
        title: '续写章节 ${state.continueChain.length + 1}',
        content: content,
        baseChapterId: baseId,
      );
      state = state.copyWith(
        continueChain: [...state.continueChain, newChapter],
        continueIdCounter: state.continueIdCounter + 1,
      );

      // Auto-update graph
      if (_autoUpdateGraphAfterWrite) {
        try {
          await updateGraphWithContinueContent(newChapter.id, content);
        } catch (_) {}
      }

      state = state.copyWith(isGenerating: false, progressText: '');
      return content;
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        progressText: '',
        error: '续写生成失败: $e',
      );
      return null;
    }
  }
}

/// Writing provider factory
final writingProviderNotifierProvider = StateNotifierProvider.family<
    WritingNotifier, WritingState, WritingProviderParams>((ref, params) {
  return WritingNotifier(
    apiService: params.apiService,
    writeWordCount: params.writeWordCount,
    enableQualityCheck: params.enableQualityCheck,
    autoUpdateGraphAfterWrite: params.autoUpdateGraphAfterWrite,
    getChapterGraphMap: params.getChapterGraphMap,
    getChapterById: params.getChapterById,
    getMergedGraph: params.getMergedGraph,
    updateGraphWithContinueContent: params.updateGraphWithContinueContent,
  );
});

class WritingProviderParams {
  final NovelApiService? apiService;
  final int writeWordCount;
  final bool enableQualityCheck;
  final bool autoUpdateGraphAfterWrite;
  final Map<int, Map<String, dynamic>> Function() getChapterGraphMap;
  final Chapter? Function(int id) getChapterById;
  final Map<String, dynamic>? Function() getMergedGraph;
  final Future<Map<String, dynamic>?> Function(int, String) updateGraphWithContinueContent;

  const WritingProviderParams({
    required this.apiService,
    required this.writeWordCount,
    required this.enableQualityCheck,
    required this.autoUpdateGraphAfterWrite,
    required this.getChapterGraphMap,
    required this.getChapterById,
    required this.getMergedGraph,
    required this.updateGraphWithContinueContent,
  });
}
