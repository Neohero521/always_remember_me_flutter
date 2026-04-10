import 'dart:convert';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/chapter.dart';

/// 小说核心数据的持久化存储服务
/// 基于 Hive 实现，支持大对象压缩存储
///
/// 存储结构：
///   novelBox (name: 'novel_data')
///     - chapters: List<Chapter>
///     - chapterGraphMap: Map<String, String>  (key: chapterId, value: graph JSON string)
///     - continueChain: List<ContinueChapter>
///     - continueIdCounter: int
///     - mergedGraph: String? (JSON string)
///     - batchMergedGraphs: List<String> (JSON string list)
///     - lastParsedText: String
///     - currentRegexIndex: int
///     - customRegex: String
///     - selectedBaseChapterId: String
///     - writePreview: String
///     - precheckResult: String? (JSON string)
///     - qualityResult: String? (JSON string)
///     - qualityResultShow: bool
///     - graphCompliance: String? (JSON string)
///     - _persistVersion: int
///
class StorageService {
  static const String _boxName = 'novel_data';
  static const int _currentVersion = 1;

  Box? _box;

  /// 单例
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// 初始化（必须在 runApp 之前调用）
  Future<void> init() async {
    await Hive.initFlutter();
    // 注册 TypeAdapter（需在 openBox 之前）
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(ChapterAdapter()); // lib/models/chapter.dart
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(ContinueChapterAdapter());
    }
    _box = await Hive.openBox(
      _boxName,
      // Hive 加密选项（可选，默认无加密）
      // encryptionCipher: HiveAesCipher(key: keyBytes),
    );
  }

  Box get box {
    if (_box == null || !_box!.isOpen) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return _box!;
  }

  // ─── 小说核心数据 ────────────────────────────────────────────────

  /// 保存全部小说数据（完整快照）
  Future<void> saveNovelData(NovelPersistData data) async {
    final b = box;

    // chapters
    if (data.chapters != null) {
      await b.put('chapters', data.chapters!);
    }

    // chapterGraphMap: Map<int, Map<String,dynamic>> → Map<String, String>
    if (data.chapterGraphMap != null) {
      final serialized = <String, String>{};
      for (final entry in data.chapterGraphMap!.entries) {
        serialized[entry.key.toString()] = json.encode(entry.value);
      }
      await b.put('chapterGraphMap', serialized);
    }

    // continueChain
    if (data.continueChain != null) {
      await b.put('continueChain', data.continueChain!);
    }

    await b.put('continueIdCounter', data.continueIdCounter ?? 1);
    await b.put('mergedGraph', data.mergedGraph);
    await b.put('batchMergedGraphs', data.batchMergedGraphs ?? []);

    // 解析状态
    await b.put('lastParsedText', data.lastParsedText ?? '');
    await b.put('currentRegexIndex', data.currentRegexIndex ?? 0);
    await b.put('customRegex', data.customRegex ?? '');

    // 续写 UI 状态
    await b.put('selectedBaseChapterId', data.selectedBaseChapterId ?? '');
    await b.put('writePreview', data.writePreview ?? '');

    // PrecheckResult → JSON string
    if (data.precheckResult != null) {
      await b.put('precheckResult', json.encode(data.precheckResult!));
    } else {
      await b.delete('precheckResult');
    }

    // QualityResult → JSON string
    if (data.qualityResult != null) {
      await b.put('qualityResult', json.encode(data.qualityResult!));
    } else {
      await b.delete('qualityResult');
    }

    await b.put('qualityResultShow', data.qualityResultShow ?? false);

    // 图谱合规状态 → JSON string
    if (data.graphCompliance != null) {
      await b.put('graphCompliance', json.encode(data.graphCompliance!));
    } else {
      await b.delete('graphCompliance');
    }

    await b.put('_persistVersion', _currentVersion);
  }

  /// 加载全部小说数据
  Future<NovelPersistData?> loadNovelData() async {
    try {
      final b = box;
      if (!b.isOpen) return null;

      // 无任何数据时返回 null
      if (b.isEmpty) return null;

      // chapters
      final chapters = b.get('chapters') as List<Chapter>?;

      // chapterGraphMap: Map<String, String> → Map<int, Map<String,dynamic>>
      Map<int, Map<String, dynamic>>? chapterGraphMap;
      final rawGraphMap = b.get('chapterGraphMap') as Map?;
      if (rawGraphMap != null) {
        chapterGraphMap = {};
        for (final entry in rawGraphMap.entries) {
          final key = int.tryParse(entry.key.toString());
          if (key != null) {
            final value = entry.value is String
                ? json.decode(entry.value as String) as Map<String, dynamic>
                : entry.value as Map<String, dynamic>;
            chapterGraphMap[key] = value;
          }
        }
      }

      // continueChain
      final continueChain = b.get('continueChain') as List<ContinueChapter>?;

      // mergedGraph
      String? mergedGraph;
      final rawMerged = b.get('mergedGraph');
      if (rawMerged is String && rawMerged.isNotEmpty) {
        mergedGraph = rawMerged;
      }

      // batchMergedGraphs: List<dynamic> → List<String>
      List<String>? batchMergedGraphs;
      final rawBatch = b.get('batchMergedGraphs');
      if (rawBatch is List) {
        batchMergedGraphs = rawBatch
            .whereType<String>()
            .toList();
      }

      // PrecheckResult
      Map<String, dynamic>? precheckResult;
      final rawPrecheck = b.get('precheckResult');
      if (rawPrecheck is String && rawPrecheck.isNotEmpty) {
        precheckResult = json.decode(rawPrecheck) as Map<String, dynamic>;
      }

      // QualityResult
      Map<String, dynamic>? qualityResult;
      final rawQuality = b.get('qualityResult');
      if (rawQuality is String && rawQuality.isNotEmpty) {
        qualityResult = json.decode(rawQuality) as Map<String, dynamic>;
      }

      // GraphCompliance
      Map<String, dynamic>? graphCompliance;
      final rawCompliance = b.get('graphCompliance');
      if (rawCompliance is String && rawCompliance.isNotEmpty) {
        graphCompliance = json.decode(rawCompliance) as Map<String, dynamic>;
      }

      return NovelPersistData(
        chapters: chapters,
        chapterGraphMap: chapterGraphMap,
        continueChain: continueChain,
        continueIdCounter: b.get('continueIdCounter', defaultValue: 1) as int,
        mergedGraph: mergedGraph,
        batchMergedGraphs: batchMergedGraphs,
        lastParsedText: b.get('lastParsedText', defaultValue: '') as String,
        currentRegexIndex: b.get('currentRegexIndex', defaultValue: 0) as int,
        customRegex: b.get('customRegex', defaultValue: '') as String,
        selectedBaseChapterId: b.get('selectedBaseChapterId', defaultValue: '') as String,
        writePreview: b.get('writePreview', defaultValue: '') as String,
        precheckResult: precheckResult,
        qualityResult: qualityResult,
        qualityResultShow: b.get('qualityResultShow', defaultValue: false) as bool,
        graphCompliance: graphCompliance,
      );
    } catch (e) {
      // 数据损坏时返回 null，让上层走兜底逻辑
      return null;
    }
  }

  /// 清除所有小说数据（用户主动重置时调用）
  Future<void> clearNovelData() async {
    await box.clear();
  }

  /// 增量保存单个字段（避免全量写入）
  Future<void> saveChapters(List<Chapter> chapters) async {
    await box.put('chapters', chapters);
  }

  Future<void> saveChapterGraph(int chapterId, Map<String, dynamic> graph) async {
    final rawMap = box.get('chapterGraphMap') as Map<String, String>? ?? {};
    rawMap[chapterId.toString()] = json.encode(graph);
    await box.put('chapterGraphMap', Map<String, String>.from(rawMap));
  }

  Future<void> saveContinueChain(List<ContinueChapter> chain) async {
    await box.put('continueChain', chain);
  }

  Future<void> saveContinueIdCounter(int counter) async {
    await box.put('continueIdCounter', counter);
  }

  Future<void> saveMergedGraph(String? jsonString) async {
    if (jsonString != null) {
      await box.put('mergedGraph', jsonString);
    } else {
      await box.delete('mergedGraph');
    }
  }

  Future<void> saveBatchMergedGraphs(List<String> graphs) async {
    await box.put('batchMergedGraphs', graphs);
  }
}

// ─── 持久化数据结构 ────────────────────────────────────────────────

/// 小说核心数据的完整快照
/// 用于从 Hive 加载 / 保存到 Hive
class NovelPersistData {
  final List<Chapter>? chapters;
  final Map<int, Map<String, dynamic>>? chapterGraphMap;
  final List<ContinueChapter>? continueChain;
  final int? continueIdCounter;
  final String? mergedGraph;           // JSON string
  final List<String>? batchMergedGraphs; // JSON string list
  final String? lastParsedText;
  final int? currentRegexIndex;
  final String? customRegex;
  final String? selectedBaseChapterId;
  final String? writePreview;
  final Map<String, dynamic>? precheckResult;   // PrecheckResult.toJson()
  final Map<String, dynamic>? qualityResult;    // QualityResult.toJson()
  final bool? qualityResultShow;
  final Map<String, dynamic>? graphCompliance;   // {result, pass} toJson()

  NovelPersistData({
    this.chapters,
    this.chapterGraphMap,
    this.continueChain,
    this.continueIdCounter,
    this.mergedGraph,
    this.batchMergedGraphs,
    this.lastParsedText,
    this.currentRegexIndex,
    this.customRegex,
    this.selectedBaseChapterId,
    this.writePreview,
    this.precheckResult,
    this.qualityResult,
    this.qualityResultShow,
    this.graphCompliance,
  });
}
