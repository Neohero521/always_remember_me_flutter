import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chapter.dart';
import '../models/novel_book.dart';
import '../models/knowledge_graph.dart';
import '../services/chapter_service.dart';
import '../services/novel_api_service.dart';
import '../services/storage_service.dart';

/// 全局状态管理
class NovelProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  final Completer<void> _initCompleter = Completer<void>();

  NovelProvider() {
    _loadSettings();
  }

  /// 等待初始化完成（main.dart 用 FutureBuilder 等这个）
  Future<void> waitForInitialization() => _initCompleter.future;

  // 防抖写入定时器（避免每次状态变更都触发 Hive IO）
  Timer? _persistTimer;
  static const _persistDebounceMs = 300;

  // === 配置 ===
  String _apiBaseUrl = '';
  String _apiKey = '';
  String _selectedModel = '';
  int _writeWordCount = 2000;
  bool _enableQualityCheck = true;
  bool _autoUpdateGraphAfterWrite = true;

  // === 阅读器状态 ===
  int _readerFontSize = 16;
  int? _currentChapterId;

  // === 章节状态 ===
  List<Chapter> _chapters = [];
  int _currentRegexIndex = 0;
  String _lastParsedText = '';
  List<RegexMatchResult> _sortedRegexList = [];
  String _customRegex = '';
  String _currentAutoRegex = '';  // 自动匹配时使用的正则

  // === 图谱状态 ===
  Map<int, Map<String, dynamic>> _chapterGraphMap = {};
  Map<String, dynamic>? _mergedGraph;
  List<Map<String, dynamic>> _batchMergedGraphs = [];

  // === 续写状态 ===
  List<ContinueChapter> _continueChain = [];
  int _continueIdCounter = 1;
  String _selectedBaseChapterId = '';
  String _writePreview = '';
  PrecheckResult? _precheckResult;
  QualityResult? _qualityResult;
  bool _qualityResultShow = false;

  // === 生成状态 ===
  bool _isGeneratingGraph = false;
  bool _isGeneratingWrite = false;
  bool _stopFlag = false;
  bool _isLoadingBook = false;

  // === 进度 ===
  String _graphProgressText = '';
  String _writeProgressText = '';

  // === 书架状态 ===
  List<NovelBook> _bookshelf = [];
  String? _currentBookId;

  // === API 服务（延迟初始化）===
  NovelApiService? _apiService;

  // Getters
  String get apiBaseUrl => _apiBaseUrl;
  String get apiKey => _apiKey;
  String get selectedModel => _selectedModel;
  int get writeWordCount => _writeWordCount;
  bool get enableQualityCheck => _enableQualityCheck;
  bool get autoUpdateGraphAfterWrite => _autoUpdateGraphAfterWrite;
  int get readerFontSize => _readerFontSize;
  int? get currentChapterId => _currentChapterId;
  List<Chapter> get chapters => _chapters;
  int get currentRegexIndex => _currentRegexIndex;
  String get lastParsedText => _lastParsedText;
  List<RegexMatchResult> get sortedRegexList => _sortedRegexList;
  String get customRegex => _customRegex;
  Map<int, Map<String, dynamic>> get chapterGraphMap => _chapterGraphMap;
  Map<String, dynamic>? get mergedGraph => _mergedGraph;
  List<Map<String, dynamic>> get batchMergedGraphs => _batchMergedGraphs;
  List<ContinueChapter> get continueChain => _continueChain;
  int get continueIdCounter => _continueIdCounter;
  String get selectedBaseChapterId => _selectedBaseChapterId;
  String get writePreview => _writePreview;
  PrecheckResult? get precheckResult => _precheckResult;
  QualityResult? get qualityResult => _qualityResult;
  bool get qualityResultShow => _qualityResultShow;
  bool get isGeneratingGraph => _isGeneratingGraph;
  bool get isGeneratingWrite => _isGeneratingWrite;
  bool get stopFlag => _stopFlag;
  bool get isLoadingBook => _isLoadingBook;
  String get graphProgressText => _graphProgressText;
  String get writeProgressText => _writeProgressText;

  NovelApiService? get apiService {
    if (_apiBaseUrl.isNotEmpty && _apiKey.isNotEmpty && _selectedModel.isNotEmpty) {
      _apiService ??= NovelApiService(
        baseUrl: _apiBaseUrl,
        apiKey: _apiKey,
        model: _selectedModel,
      );
    }
    return _apiService;
  }

  // === 配置方法 ===
  Future<void> updateConfig({
    String? apiBaseUrl,
    String? apiKey,
    String? selectedModel,
    int? writeWordCount,
    bool? enableQualityCheck,
    bool? autoUpdateGraphAfterWrite,
  }) async {
    if (apiBaseUrl != null) _apiBaseUrl = apiBaseUrl;
    if (apiKey != null) _apiKey = apiKey;
    if (selectedModel != null) _selectedModel = selectedModel;
    if (writeWordCount != null) _writeWordCount = writeWordCount;
    if (enableQualityCheck != null) _enableQualityCheck = enableQualityCheck;
    if (autoUpdateGraphAfterWrite != null) _autoUpdateGraphAfterWrite = autoUpdateGraphAfterWrite;
    _apiService = null;
    await _saveSettings();
    notifyListeners();
  }

  /// 更新阅读器状态（字号/当前章节）
  Future<void> updateReaderState({int? fontSize, int? chapterId}) async {
    if (fontSize != null) {
      _readerFontSize = fontSize.clamp(12, 28);
    }
    if (chapterId != null) {
      _currentChapterId = chapterId;
    }
    notifyListeners();
    await _saveSettings();
  }

  // === 章节解析 ===
  void parseChapters(String novelText, {String? customRegex}) {
    final text = ChapterService.removeBOM(novelText);
    String useRegex = '';

    if (customRegex != null && customRegex.isNotEmpty) {
      useRegex = customRegex;
      _currentAutoRegex = '';
    } else {
      if (_lastParsedText != text) {
        _lastParsedText = text;
        _sortedRegexList = ChapterService.getSortedRegexList(text);
        _currentRegexIndex = 0;
      } else {
        _currentRegexIndex = (_currentRegexIndex + 1) % _sortedRegexList.length;
      }
      if (_sortedRegexList.isEmpty) return;
      useRegex = _sortedRegexList[_currentRegexIndex].preset.regex;
      _currentAutoRegex = useRegex;  // 保存自动匹配使用的正则
    }

    _chapters = ChapterService.splitByRegex(text, useRegex);
    _customRegex = customRegex ?? '';
    _chapterGraphMap = {};
    _mergedGraph = null;
    _continueChain = [];
    _continueIdCounter = 1;
    _selectedBaseChapterId = '';
    _writePreview = '';
    _precheckResult = null;
    _qualityResult = null;
    _batchMergedGraphs = [];
    notifyListeners();
    _schedulePersist();
  }

  void parseChaptersByWordCount(String novelText, int wordCount) {
    final text = ChapterService.removeBOM(novelText);
    _chapters = ChapterService.splitByWordCount(text, wordCount);
    _chapterGraphMap = {};
    _mergedGraph = null;
    _continueChain = [];
    _continueIdCounter = 1;
    _selectedBaseChapterId = '';
    _writePreview = '';
    _precheckResult = null;
    _qualityResult = null;
    _lastParsedText = '';
    _batchMergedGraphs = [];
    notifyListeners();
    _schedulePersist();
  }

  void selectBaseChapter(String chapterId) {
    _selectedBaseChapterId = chapterId;
    _precheckResult = null;
    _writePreview = '';
    _qualityResult = null;
    _qualityResultShow = false;
    notifyListeners();
  }

  Chapter? getChapterById(int id) {
    try {
      return _chapters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // === 图谱生成 ===
  Future<void> generateGraphForChapter(int chapterId) async {
    if (apiService == null) return;
    final chapter = getChapterById(chapterId);
    if (chapter == null) return;

    _isGeneratingGraph = true;
    _stopFlag = false;
    _graphProgressText = '正在生成图谱...';
    notifyListeners();

    try {
      final graph = await apiService!.generateSingleChapterGraph(
        chapterId: chapter.id,
        chapterTitle: chapter.title,
        chapterContent: chapter.content,
      );
      _chapterGraphMap[chapterId] = graph;
      final idx = _chapters.indexWhere((c) => c.id == chapterId);
      if (idx >= 0) {
        _chapters[idx] = _chapters[idx].copyWith(hasGraph: true);
      }
    } catch (e) {
      debugPrint('图谱生成失败: $e');
      rethrow;
    } finally {
      _isGeneratingGraph = false;
      _graphProgressText = '';
      notifyListeners();
    }
  }

  Future<void> generateGraphsForAllChapters() async {
    if (apiService == null) return;
    _isGeneratingGraph = true;
    _stopFlag = false;
    notifyListeners();

    int successCount = 0;
    int failCount = 0;
    final List<String> failedChapterTitles = [];

    for (int i = 0; i < _chapters.length; i++) {
      if (_stopFlag) break;
      final chapter = _chapters[i];
      _graphProgressText = '图谱生成进度: ${i + 1}/${_chapters.length}（成功$successCount / 失败$failCount）';
      notifyListeners();

      if (!_chapterGraphMap.containsKey(chapter.id)) {
        try {
          final graph = await apiService!.generateSingleChapterGraph(
            chapterId: chapter.id,
            chapterTitle: chapter.title,
            chapterContent: chapter.content,
          );
          _chapterGraphMap[chapter.id] = graph;
          _chapters[i] = _chapters[i].copyWith(hasGraph: true);
          successCount++;
        } catch (e) {
          debugPrint('章节${chapter.title}图谱生成失败: $e');
          failCount++;
          failedChapterTitles.add(chapter.title);
        }
      } else {
        successCount++;
      }

      notifyListeners();
      if (i < _chapters.length - 1 && !_stopFlag) {
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    _isGeneratingGraph = false;
    _stopFlag = false;
    if (failCount > 0) {
      _graphProgressText = '图谱生成完成：成功 $successCount 个，失败 $failCount 个（${failedChapterTitles.take(3).join("、")}${failCount > 3 ? "..." : ""}）';
    } else {
      _graphProgressText = '图谱生成完成：成功 $successCount 个';
    }
    notifyListeners();
  }

  void stopGraphGeneration() {
    _stopFlag = true;
    _isGeneratingGraph = false;
    _graphProgressText = '';
    notifyListeners();
  }

  // === 图谱合并 ===
  Future<void> batchMergeGraphs({int batchSize = 50}) async {
    if (apiService == null) return;
    final sortedChapters = [..._chapters]..sort((a, b) => a.id - b.id);
    final graphList = sortedChapters
        .map((c) => _chapterGraphMap[c.id])
        .whereType<Map<String, dynamic>>()
        .toList();

    if (graphList.isEmpty) return;

    _batchMergedGraphs = [];
    _isGeneratingGraph = true;
    _stopFlag = false;
    notifyListeners();

    final batches = <List<Map<String, dynamic>>>[];
    for (int i = 0; i < graphList.length; i += batchSize) {
      batches.add(graphList.sublist(
        i,
        (i + batchSize).clamp(0, graphList.length),
      ));
    }

    try {
      for (int i = 0; i < batches.length; i++) {
        if (_stopFlag) break;
        _graphProgressText = '分批合并进度: ${i + 1}/${batches.length}';
        notifyListeners();

        final merged = await apiService!.batchMergeGraphs(
          graphList: batches[i],
          batchNumber: i + 1,
          totalBatches: batches.length,
        );
        _batchMergedGraphs.add(merged);

        if (i < batches.length - 1 && !_stopFlag) {
          await Future.delayed(const Duration(milliseconds: 1500));
        }
      }
    } catch (e) {
      debugPrint('分批合并失败: $e');
      rethrow;
    } finally {
      _isGeneratingGraph = false;
      _stopFlag = false;
      _graphProgressText = '';
      notifyListeners();
      _schedulePersist();
    }
  }

  Future<void> mergeAllGraphs() async {
    if (apiService == null) return;

    List<Map<String, dynamic>> graphList;
    if (_batchMergedGraphs.isNotEmpty) {
      graphList = _batchMergedGraphs;
    } else {
      graphList = _chapterGraphMap.values.toList();
    }

    if (graphList.isEmpty) return;

    _isGeneratingGraph = true;
    _graphProgressText = '正在合并全量图谱...';
    _stopFlag = false;
    notifyListeners();

    try {
      final merged = await apiService!.mergeAllGraphs(graphList: graphList);
      _mergedGraph = merged;
    } catch (e) {
      debugPrint('全量图谱合并失败: $e');
      rethrow;
    } finally {
      _isGeneratingGraph = false;
      _graphProgressText = '';
      notifyListeners();
      _schedulePersist();
    }
  }

  // === 图谱导入导出 ===
  String exportChapterGraphsJson() {
    final exportData = {
      'exportTime': DateTime.now().toIso8601String(),
      'chapterCount': _chapters.length,
      'chapterGraphMap': _chapterGraphMap,
    };
    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  void importChapterGraphsJson(String jsonString) {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final importedMap =
          data['chapterGraphMap'] as Map<String, dynamic>? ?? {};
      for (final entry in importedMap.entries) {
        final key = int.tryParse(entry.key);
        if (key != null) {
          _chapterGraphMap[key] = entry.value as Map<String, dynamic>;
        }
      }
      // 更新章节 hasGraph 状态
      for (int i = 0; i < _chapters.length; i++) {
        if (_chapterGraphMap.containsKey(_chapters[i].id)) {
          _chapters[i] = _chapters[i].copyWith(hasGraph: true);
        }
      }
      notifyListeners();
      _schedulePersist();
    } catch (e) {
      debugPrint('图谱导入失败: $e');
    }
  }

  // === 图谱状态校验 ===
  Map<String, dynamic> getChapterGraphStatus() {
    int hasGraphCount = 0;
    List<String> noGraphTitles = [];
    for (final chapter in _chapters) {
      if (_chapterGraphMap.containsKey(chapter.id)) {
        hasGraphCount++;
      } else {
        noGraphTitles.add(chapter.title);
      }
    }
    return {
      'totalCount': _chapters.length,
      'hasGraphCount': hasGraphCount,
      'noGraphCount': _chapters.length - hasGraphCount,
      'noGraphTitles': noGraphTitles,
    };
  }

  // === 续写前置校验 ===
  Future<PrecheckResult?> runPrecheck(int baseChapterId,
      {String? modifiedContent, bool useBaseChapter = false}) async {
    if (apiService == null) return null;

    final baseId = baseChapterId;
    // 取基准章节及前5章（共6章）的图谱
    final preChapters = _chapters
        .where((c) => c.id <= baseId && c.id >= (baseId - 5))
        .toList();
    final preGraphList = preChapters
        .map((c) => _chapterGraphMap[c.id])
        .whereType<Map<String, dynamic>>()
        .toList();

    try {
      final result = await apiService!.precheckContinuation(
        baseChapterId: baseChapterId,
        preGraphList: preGraphList,
        modifiedChapterContent: modifiedContent,
      );
      _precheckResult = PrecheckResult.fromJson(result);
      notifyListeners();
      return _precheckResult;
    } catch (e) {
      debugPrint('前置校验失败: $e');
      return null;
    }
  }

  // === 续写生成（基准章节续写） ===
  Future<String?> generateWrite({String? modifiedContent}) async {
    if (apiService == null || _selectedBaseChapterId.isEmpty) return null;

    final baseChapterId = int.tryParse(_selectedBaseChapterId) ?? 0;
    final baseChapter = getChapterById(baseChapterId);
    if (baseChapter == null) return null;

    final baseContent = modifiedContent ?? baseChapter.content;
    final baseParagraphs =
        baseContent.split('\n').where((p) => p.trim().isNotEmpty).toList();
    final baseLastParagraph =
        baseParagraphs.isNotEmpty ? baseParagraphs.last.trim() : '';

    _isGeneratingWrite = true;
    _stopFlag = false;
    _writeProgressText = '正在执行前置校验...';
    notifyListeners();

    try {
      // 执行前置校验
      final preResult = await runPrecheck(
        baseChapterId,
        modifiedContent: modifiedContent,
        useBaseChapter: true,  // 包含基准章节本身
      );
      final precheck = preResult ??
          PrecheckResult(
            isPass: true,
            preMergedGraph: {},
            redLines: '无',
            forbiddenRules: '无',
            foreshadowList: '无明确可呼应伏笔',
            conflictWarning: '无',
            possiblePlotDirections: '推进主线剧情',
            complianceReport: '直接续写',
          );

      final useGraph = precheck.preMergedGraph.isNotEmpty
          ? precheck.preMergedGraph
          : (_mergedGraph ?? {});

      final systemPrompt = '''小说续写规则（100%遵守）：
人设锁定：续写内容必须完全贴合小说的核心人物设定，严格遵守人设红线：${precheck.redLines}
设定合规：严格遵守设定禁区：${precheck.forbiddenRules}
文本衔接：续写内容必须紧接在基准章节的最后一段之后开始，基准章节最后一段是："$baseLastParagraph"
剧情承接：合理呼应伏笔：${precheck.foreshadowList}，开启新章节
文风统一：完全贴合原文的叙事风格、语言习惯、节奏特点
字数要求：约$_writeWordCount字，误差不超过10%
矛盾规避：${precheck.conflictWarning}
输出要求：只输出续写的正文内容，不要任何标题、章节名、解释''';

      final userPrompt =
          '小说核心设定知识图谱：${json.encode(useGraph)}\n基准章节内容：$baseContent\n请基于以上内容，按照规则续写后续的章节正文。';

      _writeProgressText = '正在生成续写章节...';
      notifyListeners();

      String continueContent = await apiService!.generateContinuation(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
        targetWordCount: _writeWordCount,
      );

      if (_stopFlag) {
        _writePreview = '';
        return null;
      }

      // 质量评估
      if (_enableQualityCheck) {
        _writeProgressText = '正在执行质量校验...';
        notifyListeners();

        final quality = await apiService!.evaluateQuality(
          continueContent: continueContent,
          precheckResult: {
            'isPass': precheck.isPass,
            '人设红线清单': precheck.redLines,
            '设定禁区清单': precheck.forbiddenRules,
            '可呼应伏笔清单': precheck.foreshadowList,
            '潜在矛盾预警': precheck.conflictWarning,
            '可推进剧情方向': precheck.possiblePlotDirections,
          },
          baseGraph: useGraph,
          baseChapterContent: baseContent,
          targetWordCount: _writeWordCount,
        );
        if (_stopFlag) { _writePreview = ''; return null; }
        _qualityResult = QualityResult.fromJson(quality);
        _qualityResultShow = true;

        if (!_qualityResult!.isPassed && !_stopFlag) {
          _writeProgressText = '质量不合格，正在重新生成...';
          notifyListeners();
          continueContent = await apiService!.generateContinuation(
            systemPrompt:
                '$systemPrompt\n注意：本次续写必须修正以下问题：${_qualityResult!.report}',
            userPrompt: userPrompt,
            targetWordCount: _writeWordCount,
          );
          if (_stopFlag) { _writePreview = ''; return null; }
          _qualityResult = null;
        }
      }

      _writePreview = continueContent;

      // 添加到续写链条
      final newChapter = ContinueChapter(
        id: _continueIdCounter++,
        title: '续写章节 ${_continueChain.length + 1}',
        content: continueContent,
        baseChapterId: baseChapterId,
      );
      _continueChain.add(newChapter);

      // 续写后自动生成图谱（如果开启）
      if (_autoUpdateGraphAfterWrite) {
        // 用 await 确保图谱生成完成再返回，避免用户看到成功但图谱未生成
        try {
          await updateGraphWithContinueContent(newChapter.id, continueContent);
        } catch (e) {
          debugPrint('自动图谱生成失败（不影响续写结果）: $e');
        }
      }

      _writeProgressText = '';
      notifyListeners();
      return continueContent;
    } catch (e) {
      debugPrint('续写生成失败: $e');
      _writeProgressText = '';
      return null;
    } finally {
      _isGeneratingWrite = false;
      _stopFlag = false;
      notifyListeners();
      _schedulePersist();
    }
  }

  // === 续写（从链条中已有章节继续写） ===
  Future<String?> continueFromChain(int targetChainId) async {
    if (apiService == null || _selectedBaseChapterId.isEmpty) return null;

    final targetChapter = _continueChain
        .where((c) => c.id == targetChainId)
        .firstOrNull;
    if (targetChapter == null) return null;

    final baseChapterId = int.tryParse(_selectedBaseChapterId) ?? 0;
    final baseChapter = getChapterById(baseChapterId);
    final baseContent = baseChapter?.content ?? '';

    final targetContent = targetChapter.content;
    final targetParagraphs =
        targetContent.split('\n').where((p) => p.trim().isNotEmpty).toList();
    final targetLastParagraph =
        targetParagraphs.isNotEmpty ? targetParagraphs.last.trim() : '';

    _isGeneratingWrite = true;
    _stopFlag = false;
    _writeProgressText = '正在从链条章节继续续写...';
    notifyListeners();

    try {
      final preResult = await runPrecheck(baseChapterId);
      final precheck = preResult ??
          PrecheckResult(
            isPass: true,
            preMergedGraph: {},
            redLines: '无',
            forbiddenRules: '无',
            foreshadowList: '无明确可呼应伏笔',
            conflictWarning: '无',
            possiblePlotDirections: '推进主线剧情',
            complianceReport: '直接续写',
          );

      final useGraph = precheck.preMergedGraph.isNotEmpty
          ? precheck.preMergedGraph
          : (_mergedGraph ?? {});

      // 构建前文上下文（包含链条中目标章节及前1章）
      String fullContext = '';
      final preBaseChapters = _chapters
          .where((c) => c.id < baseChapterId && c.id >= (baseChapterId - 2))
          .toList();
      for (final c in preBaseChapters) {
        fullContext += '$c.title\n${c.content}\n\n';
      }
      if (baseChapter != null) {
        fullContext += '$baseChapter.title\n$baseContent\n\n';
      }
      final targetBeforeChapters = _continueChain
          .where((c) => c.id <= targetChainId && c.id > (targetChainId - 2))
          .toList();
      for (int i = 0; i < targetBeforeChapters.length; i++) {
        final c = targetBeforeChapters[i];
        fullContext += '续写章节 ${i + 1}\n${c.content}\n\n';
      }

      final systemPrompt = '''小说续写规则（100%遵守）：
人设锁定：续写内容必须完全贴合小说的核心人物设定，严格遵守人设红线：${precheck.redLines}
设定合规：严格遵守设定禁区：${precheck.forbiddenRules}
文本衔接：续写内容必须紧接在上一章（续写章节 ${targetChapter.title}）的最后一段之后开始，上一章最后一段是："$targetLastParagraph"
剧情承接：合理呼应伏笔：${precheck.foreshadowList}，开启新章节，不重复前文情节
文风统一：完全贴合原文的叙事风格、语言习惯、节奏特点
字数要求：约$_writeWordCount字，误差不超过10%
矛盾规避：${precheck.conflictWarning}
输出要求：只输出续写的正文内容，不要任何标题、章节名、解释''';

      final userPrompt =
          '小说核心设定知识图谱：${json.encode(useGraph)}\n完整前文上下文：$fullContext\n请基于以上完整的前文内容和知识图谱，按照规则续写后续的新章节正文。';

      _writeProgressText = '正在生成续写章节...';
      notifyListeners();

      String continueContent = await apiService!.continueFromChainChapter(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
        targetWordCount: _writeWordCount,
      );

      if (_stopFlag) return null;

      // 更新链条中的章节内容
      final chainIdx =
          _continueChain.indexWhere((c) => c.id == targetChainId);
      if (chainIdx >= 0) {
        _continueChain[chainIdx] =
            _continueChain[chainIdx].copyWith(content: continueContent);
      }

      _writePreview = continueContent;

      // 添加新章节到链条
      final newChapter = ContinueChapter(
        id: _continueIdCounter++,
        title: '续写章节 ${_continueChain.length + 1}',
        content: continueContent,
        baseChapterId: baseChapterId,
      );
      _continueChain.add(newChapter);

      _writeProgressText = '';
      notifyListeners();
      return continueContent;
    } catch (e) {
      debugPrint('链条续写失败: $e');
      _writeProgressText = '';
      return null;
    } finally {
      _isGeneratingWrite = false;
      _stopFlag = false;
      notifyListeners();
      _schedulePersist();
    }
  }

  void stopWrite() {
    _stopFlag = true;
    _isGeneratingWrite = false;
    _writeProgressText = '';
    notifyListeners();
  }

  void clearWritePreview() {
    _writePreview = '';
    _qualityResult = null;
    _qualityResultShow = false;
    notifyListeners();
  }

  void removeContinueChapter(int chainId) {
    _continueChain.removeWhere((c) => c.id == chainId);
    notifyListeners();
    _schedulePersist();
  }

  void clearContinueChain() {
    _continueChain = [];
    _continueIdCounter = 1;
    notifyListeners();
    _schedulePersist();
  }

  void clearBatchMergedGraphs() {
    _batchMergedGraphs = [];
    notifyListeners();
    _schedulePersist();
  }

  void clearMergedGraph() {
    _mergedGraph = null;
    notifyListeners();
    _schedulePersist();
  }

  // === 图谱合规性校验 ===
  String? _graphComplianceResult;
  bool? _graphCompliancePass;

  String? get graphComplianceResult => _graphComplianceResult;
  bool? get graphCompliancePass => _graphCompliancePass;

  /// 校验图谱完整性（字段齐全 + 字数≥1200）
  void validateGraphCompliance() {
    final graph = _mergedGraph;
    if (graph == null) {
      _graphCompliancePass = false;
      _graphComplianceResult = '图谱尚未合并，请先生成合并图谱';
      notifyListeners();
      return;
    }

    // 检查必填字段
    const fullRequiredFields = [
      '全局基础信息', '人物信息库', '世界观设定库', '全剧情时间线',
      '全局文风标准', '全量实体关系网络', '反向依赖图谱', '逆向分析与质量评估',
    ];
    final missing = fullRequiredFields.where((f) => !graph.containsKey(f)).toList();

    // 检查字数
    final jsonStr = const JsonEncoder.withIndent('  ').convert(graph);
    final wordCount = jsonStr.length;

    if (missing.isNotEmpty) {
      _graphCompliancePass = false;
      _graphComplianceResult = '图谱合规性校验不通过，缺少必填字段：${missing.join("、")}，请重新生成/合并图谱';
    } else if (wordCount < 1200) {
      _graphCompliancePass = false;
      _graphComplianceResult = '图谱合规性校验不通过，内容字数不足，当前字数：$wordCount，最低要求：1200字，请重新生成图谱';
    } else {
      final score = graph['逆向分析与质量评估']?['全文本逻辑自洽性得分'] ?? 0;
      _graphCompliancePass = true;
      _graphComplianceResult = '图谱合规性校验通过，所有必填字段完整，内容字数：$wordCount字，全文本逻辑自洽性得分：$score/100';
    }
    notifyListeners();
  }

  /// 检验所有章节的图谱生成状态
  Map<String, dynamic> validateChapterGraphStatus() {
    if (_chapters.isEmpty) {
      return {
        'total': 0,
        'hasGraph': 0,
        'noGraph': 0,
        'noGraphTitles': <String>[],
      };
    }

    int hasGraphCount = 0;
    final List<String> noGraphTitles = [];

    for (final chapter in _chapters) {
      final hasGraph = _chapterGraphMap.containsKey(chapter.id);
      // 同步更新章节对象的hasGraph标记
      chapter.hasGraph = hasGraph;
      if (hasGraph) {
        hasGraphCount++;
      } else {
        noGraphTitles.add(chapter.title);
      }
    }

    return {
      'total': _chapters.length,
      'hasGraph': hasGraphCount,
      'noGraph': _chapters.length - hasGraphCount,
      'noGraphTitles': noGraphTitles,
    };
  }

  // === 魔改章节图谱更新 ===
  /// 用户修改章节内容后，重新生成该章节的图谱
  Future<Map<String, dynamic>?> updateModifiedChapterGraph(
    int chapterId,
    String modifiedContent,
  ) async {
    if (apiService == null) return null;
    final chapter = getChapterById(chapterId);
    if (chapter == null) return null;

    _isGeneratingGraph = true;
    _graphProgressText = '正在更新魔改章节图谱...';
    notifyListeners();

    try {
      // 用新的内容生成图谱
      final graph = await apiService!.generateSingleChapterGraph(
        chapterId: chapterId,
        chapterTitle: chapter.title,
        chapterContent: modifiedContent,
        isModified: true,
      );
      _chapterGraphMap[chapterId] = graph;

      // 更新章节内容
      final idx = _chapters.indexWhere((c) => c.id == chapterId);
      if (idx >= 0) {
        _chapters[idx] = _chapters[idx].copyWith(
          content: modifiedContent,
          hasGraph: true,
        );
      }

      _graphProgressText = '';
      notifyListeners();
      return graph;
    } catch (e) {
      debugPrint('魔改章节图谱更新失败: $e');
      _graphProgressText = '';
      return null;
    } finally {
      _isGeneratingGraph = false;
      notifyListeners();
      _schedulePersist();
    }
  }

  // === 续写章节图谱更新 ===
  /// 为续写章节生成图谱
  Future<Map<String, dynamic>?> updateGraphWithContinueContent(
    int continueId,
    String continueContent,
  ) async {
    if (apiService == null) return null;

    _isGeneratingGraph = true;
    _graphProgressText = '正在为续写章节生成图谱...';
    notifyListeners();

    try {
      final graph = await apiService!.generateSingleChapterGraph(
        chapterId: continueId,
        chapterTitle: '续写章节 $continueId',
        chapterContent: continueContent,
      );
      // 续写章节图谱用特殊key存储
      _chapterGraphMap[-continueId] = graph;

      _graphProgressText = '';
      notifyListeners();
      return graph;
    } catch (e) {
      debugPrint('续写章节图谱更新失败: $e');
      _graphProgressText = '';
      return null;
    } finally {
      _isGeneratingGraph = false;
      notifyListeners();
      _schedulePersist();
    }
  }

  // === 持久化 ===
  Future<bool> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('novel_app_settings', json.encode({
        'apiBaseUrl': _apiBaseUrl,
        'apiKey': _apiKey,
        'selectedModel': _selectedModel,
        'writeWordCount': _writeWordCount,
        'enableQualityCheck': _enableQualityCheck,
        'autoUpdateGraphAfterWrite': _autoUpdateGraphAfterWrite,
        'readerFontSize': _readerFontSize,
        'currentChapterId': _currentChapterId,
      }));
      debugPrint('设置保存成功');
      return true;
    } catch (e, st) {
      debugPrint('设置保存失败: $e $st');
      rethrow;
    }
  }

  Future<void> _loadSettings() async {
    // 0. 加载书架元数据
    try {
      _bookshelf = await _storage.loadBookshelf();
      // 尝试加载上次阅读的书
      final prefs = await SharedPreferences.getInstance();
      final lastBookId = prefs.getString('last_book_id');
      if (lastBookId != null && _bookshelf.any((b) => b.id == lastBookId)) {
        _currentBookId = lastBookId;
      } else if (_bookshelf.isNotEmpty) {
        _currentBookId = _bookshelf.first.id;
      }
      // 加载当前书的内容数据
      if (_currentBookId != null) {
        await _loadBookData(_currentBookId!);
      }

      // 启动时校验：遍历书架所有书的章节数元数据，发现不一致则纠正
      for (final book in _bookshelf) {
        final bookData = await _storage.loadNovelDataForBook(book.id);
        final actualCount = bookData?.chapters?.length ?? 0;
        if (book.chapterCount != actualCount) {
          debugPrint('[_loadSettings] 校正书籍${book.id}章节数: ${book.chapterCount} -> $actualCount');
          final idx = _bookshelf.indexWhere((b) => b.id == book.id);
          if (idx >= 0) {
            _bookshelf[idx] = _bookshelf[idx].copyWithMeta(chapterCount: actualCount);
          }
        }
      }
      if (_bookshelf.isNotEmpty) {
        await _storage.saveBookshelf(_bookshelf);
      }
    } catch (e) {
      debugPrint('书架加载失败: $e');
    }

    // 1. 先从 SharedPreferences 加载 API 配置（小数据，兼容旧版本）
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('novel_app_settings');
      if (data != null) {
        final map = json.decode(data) as Map<String, dynamic>;
        _apiBaseUrl = map['apiBaseUrl'] ?? '';
        _apiKey = map['apiKey'] ?? '';
        _selectedModel = map['selectedModel'] ?? '';
        _writeWordCount = map['writeWordCount'] ?? 2000;
        _enableQualityCheck = map['enableQualityCheck'] ?? true;
        _autoUpdateGraphAfterWrite = map['autoUpdateGraphAfterWrite'] ?? true;
        _readerFontSize = map['readerFontSize'] ?? 16;
        _currentChapterId = map['currentChapterId'] as int?;
      }
    } catch (e) {
      debugPrint('SharedPreferences 加载失败: $e');
    }

    notifyListeners();
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  // === 书架相关 getter ===
  List<NovelBook> get bookshelf => _bookshelf;
  String? get currentBookId => _currentBookId;

  /// 加载指定书籍的数据到内存
  /// 返回 true 表示加载成功，false 表示无数据
  Future<bool> _loadBookData(String bookId) async {
    try {
      final data = await _storage.loadNovelDataForBook(bookId);
      if (data == null) {
        debugPrint('[NovelProvider] _loadBookData($bookId): 无数据，初始化为空状态');
        _chapters = [];
        _chapterGraphMap = {};
        _continueChain = [];
        _continueIdCounter = 1;
        _mergedGraph = null;
        _batchMergedGraphs = [];
        _lastParsedText = '';
        _currentRegexIndex = 0;
        _customRegex = '';
        _selectedBaseChapterId = '';
        _writePreview = '';
        _precheckResult = null;
        _qualityResult = null;
        _qualityResultShow = false;
        _graphComplianceResult = null;
        _graphCompliancePass = null;
        // 空数据也同步元数据为0，避免显示旧章节数
        final nullShelfIdx = _bookshelf.indexWhere((b) => b.id == bookId);
        if (nullShelfIdx >= 0) {
          _bookshelf[nullShelfIdx] = _bookshelf[nullShelfIdx].copyWithMeta(chapterCount: 0);
          await _storage.saveBookshelf(_bookshelf);
        }
        notifyListeners();
        return false;
      }

      _chapters = data.chapters ?? [];
      _chapterGraphMap = data.chapterGraphMap ?? {};
      _continueChain = data.continueChain ?? [];
      _continueIdCounter = data.continueIdCounter ?? 1;
      if (data.mergedGraph != null && data.mergedGraph!.isNotEmpty) {
        _mergedGraph = json.decode(data.mergedGraph!) as Map<String, dynamic>;
      } else {
        _mergedGraph = null;
      }
      _batchMergedGraphs = (data.batchMergedGraphs ?? [])
          .map((s) => json.decode(s) as Map<String, dynamic>).toList();
      _lastParsedText = data.lastParsedText ?? '';
      _currentRegexIndex = data.currentRegexIndex ?? 0;
      _customRegex = data.customRegex ?? '';
      _selectedBaseChapterId = data.selectedBaseChapterId ?? '';
      _writePreview = data.writePreview ?? '';
      if (data.precheckResult != null) {
        _precheckResult = PrecheckResult.fromJson(data.precheckResult!);
      } else {
        _precheckResult = null;
      }
      if (data.qualityResult != null) {
        _qualityResult = QualityResult.fromJson(data.qualityResult!);
      } else {
        _qualityResult = null;
      }
      _qualityResultShow = data.qualityResultShow ?? false;
      if (data.graphCompliance != null) {
        _graphComplianceResult = data.graphCompliance!['result'] as String?;
        _graphCompliancePass = data.graphCompliance!['pass'] as bool?;
      } else {
        _graphComplianceResult = null;
        _graphCompliancePass = null;
      }
      // 同步书架元数据的章节数（无论章节是否为空都同步）
      final shelfIdx = _bookshelf.indexWhere((b) => b.id == bookId);
      if (shelfIdx >= 0) {
        _bookshelf[shelfIdx] = _bookshelf[shelfIdx].copyWithMeta(
          chapterCount: _chapters.length,
          lastReadChapterId: _currentChapterId ?? 0,
          readProgress: _chapters.isEmpty ? 0.0 : ((_currentChapterId ?? 0) / _chapters.length).clamp(0.0, 1.0),
          lastReadAt: DateTime.now(),
        );
        await _storage.saveBookshelf(_bookshelf);
      }
    debugPrint('[NovelProvider] _loadBookData($bookId): chapters loaded = ${data?.chapters?.length ?? 'null'}');
      notifyListeners();
      return true;
    } catch (e, st) {
      debugPrint('[NovelProvider] _loadBookData($bookId) 失败: $e $st');
      _chapters = [];
      notifyListeners();
      return false;
    }
  }

  /// 保存当前书籍数据到 Hive
  Future<void> _saveCurrentBookData() async {
    if (_currentBookId == null) return;
    await _storage.saveNovelDataForBook(_currentBookId!, NovelPersistData(
      chapters: _chapters,
      chapterGraphMap: _chapterGraphMap,
      continueChain: _continueChain,
      continueIdCounter: _continueIdCounter,
      mergedGraph: _mergedGraph != null ? const JsonEncoder.withIndent('  ').convert(_mergedGraph) : null,
      batchMergedGraphs: _batchMergedGraphs.map((g) => const JsonEncoder.withIndent('  ').convert(g)).toList(),
      lastParsedText: _lastParsedText,
      currentRegexIndex: _currentRegexIndex,
      customRegex: _customRegex,
      selectedBaseChapterId: _selectedBaseChapterId,
      writePreview: _writePreview,
      precheckResult: _precheckResult?.toJson(),
      qualityResult: _qualityResult?.toJson(),
      qualityResultShow: _qualityResultShow,
      graphCompliance: _graphComplianceResult != null ? {'result': _graphComplianceResult, 'pass': _graphCompliancePass} : null,
    ));
    // 更新书架元数据
    final idx = _bookshelf.indexWhere((b) => b.id == _currentBookId);
    if (idx >= 0) {
      final ch = _chapters;
      _bookshelf[idx] = _bookshelf[idx].copyWithMeta(
        chapterCount: ch.length,
        lastReadChapterId: _currentChapterId ?? 0,
        readProgress: ch.isEmpty ? 0.0 : ((_currentChapterId ?? 0) / ch.length).clamp(0.0, 1.0),
        lastReadAt: DateTime.now(),
      );
      await _storage.saveBookshelf(_bookshelf);
    }
  }

  /// 切换到指定书籍
  /// 返回 true 表示切换成功，false 表示无数据（书未被加载）
  Future<bool> selectBook(String bookId) async {
    debugPrint('[NovelProvider] selectBook($bookId) 开始，_currentBookId=$_currentBookId');
    // 已选中此书且章节数据已加载，无需切换
    if (_currentBookId == bookId && _chapters.isNotEmpty) {
      debugPrint('[NovelProvider] selectBook: 同一本书且已加载，跳过');
      return true;
    }
    // 保存旧书
    if (_currentBookId != null) {
      await _saveCurrentBookData();
    }
    _currentBookId = bookId;
    _isLoadingBook = true;
    notifyListeners();
    // 加载新书数据
    final hasData = await _loadBookData(bookId);
    _isLoadingBook = false;
    notifyListeners();
    // 保存当前书籍ID到 SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_book_id', bookId);
    debugPrint('[NovelProvider] selectBook($bookId) 完成，hasData=$hasData');
    return hasData;
  }

  /// 导入新书（从 ImportScreen 调用）
  Future<void> importBook({
    required String rawFileName,
    required String novelText,
    String? customTitle,
    String? customRegex,
    int? wordCount,
  }) async {
    try {
      // 1. 保存旧书数据
      final oldBookId = _currentBookId;
      if (oldBookId != null) {
        await _saveCurrentBookData();
      }

      // 2. 复用已有的解析结果（如果文本相同且已解析），否则重新解析
      List<Chapter> chaptersToSave;
      if (_lastParsedText == novelText && _chapters.isNotEmpty) {
        debugPrint('[importBook] 复用已有解析结果: ${_chapters.length} 个章节');
        chaptersToSave = _chapters;
      } else {
        debugPrint('[importBook] 重新解析章节（文本变化或未解析）');
        if (customRegex != null && customRegex.isNotEmpty) {
          chaptersToSave = ChapterService.splitByRegex(novelText, customRegex);
        } else if (wordCount != null) {
          chaptersToSave = ChapterService.splitByWordCount(novelText, wordCount);
        } else {
          // 使用自动匹配时保存的正则，而非空字符串兜底
          final regexToUse = _currentAutoRegex.isNotEmpty ? _currentAutoRegex : '';
          chaptersToSave = ChapterService.splitByRegex(novelText, regexToUse);
        }
      }
      debugPrint('[importBook] 最终章节数: ${chaptersToSave.length} 个');
      _chapters = chaptersToSave;
      _lastParsedText = novelText;

      // 3. 创建书架元数据并加入书架
      final bookId = DateTime.now().millisecondsSinceEpoch.toString();
      final book = NovelBook.fromImport(
        id: bookId,
        rawFileName: rawFileName,
        customTitle: customTitle,
      ).copyWithMeta(chapterCount: _chapters.length);
      _bookshelf.add(book);
      await _storage.saveBookshelf(_bookshelf);

      // 4. 先把新书数据存到 Hive（selectBook 会从这里加载）
      _currentBookId = bookId;
      _continueChain = [];
      _continueIdCounter = 1;
      _chapterGraphMap = {};
      _mergedGraph = null;
      _batchMergedGraphs = [];
      _selectedBaseChapterId = '';
      _writePreview = '';
      _precheckResult = null;
      _qualityResult = null;
      _qualityResultShow = false;
      await _saveCurrentBookData();

      // 5. 通过 selectBook 完整切换（包含加载、元数据同步、notify）
      await selectBook(bookId);

      // 6. 保存最新章节数据到 Hive
      await _saveCurrentBookData();

      // 8. 保存 last_book_id
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_book_id', bookId);
      notifyListeners();

      debugPrint('[importBook] 导入成功：bookId=$bookId, 章节数=${_chapters.length}');
    } catch (e, st) {
      debugPrint('[importBook] 导入失败: $e $st');
      rethrow;
    }
  }

  /// 删除书籍
  Future<void> deleteBook(String bookId) async {
    _bookshelf.removeWhere((b) => b.id == bookId);
    await _storage.saveBookshelf(_bookshelf);
    await _storage.deleteBookData(bookId);
    if (_currentBookId == bookId) {
      if (_bookshelf.isNotEmpty) {
        await selectBook(_bookshelf.first.id);
      } else {
        _currentBookId = null;
        _chapters = [];
        _chapterGraphMap = {};
        _continueChain = [];
        _mergedGraph = null;
        _batchMergedGraphs = [];
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('last_book_id');
        notifyListeners();
      }
    }
  }

  /// 防抖持久化：状态变更后延迟 _persistDebounceMs 写入 Hive
  void _schedulePersist() {
    _persistTimer?.cancel();
    _persistTimer = Timer(
      const Duration(milliseconds: _persistDebounceMs),
      _doPersist,
    );
  }

  /// 实际执行 Hive 写入（保存当前书籍数据）
  Future<void> _doPersist() async {
    try {
      await _saveCurrentBookData();
    } catch (e) {
      debugPrint('Hive 持久化失败: $e');
    }
  }

  Map<String, dynamic> _precheckResultToJson(PrecheckResult r) => {
    'isPass': r.isPass,
    'preMergedGraph': r.preMergedGraph,
    '人设红线清单': r.redLines,
    '设定禁区清单': r.forbiddenRules,
    '可呼应伏笔清单': r.foreshadowList,
    '潜在矛盾预警': r.conflictWarning,
    '可推进剧情方向': r.possiblePlotDirections,
    '合规性报告': r.complianceReport,
  };

  Map<String, dynamic> _qualityResultToJson(QualityResult r) => {
    '总分': r.totalScore,
    '人设一致性得分': r.characterConsistencyScore,
    '设定合规性得分': r.settingComplianceScore,
    '剧情衔接度得分': r.plotCohesionScore,
    '文风匹配度得分': r.styleMatchScore,
    '内容质量得分': r.contentQualityScore,
    '评估报告': r.report,
    '是否合格': r.isPassed,
  };
}
