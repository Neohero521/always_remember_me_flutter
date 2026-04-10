import 'dart:convert';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/chapter.dart';
import '../models/novel_book.dart';

/// 小说核心数据的持久化存储服务
/// 基于 Hive 实现，支持大对象压缩存储
///
/// 存储结构：
///   novelBox (name: 'novel_data')
///     - {bookId}_chapters: List<Chapter>
///     - {bookId}_chapterGraphMap: Map<String, String>
///     - {bookId}_continueChain: List<ContinueChapter>
///     - {bookId}_continueIdCounter: int
///     - {bookId}_mergedGraph: String?
///     - {bookId}_batchMergedGraphs: List<String>
///     - {bookId}_lastParsedText: String
///     - {bookId}_currentRegexIndex: int
///     - {bookId}_customRegex: String
///     - {bookId}_selectedBaseChapterId: String
///     - {bookId}_writePreview: String
///     - {bookId}_precheckResult: String?
///     - {bookId}_qualityResult: String?
///     - {bookId}_qualityResultShow: bool
///     - {bookId}_graphCompliance: String?
///
class StorageService {
  static const String _boxName = 'novel_data';
  static const int _currentVersion = 1;

  Box? _box;

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(ChapterAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(ContinueChapterAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(NovelBookAdapter());
    }
    _box = await Hive.openBox(_boxName);
  }

  Box get box {
    if (_box == null || !_box!.isOpen) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return _box!;
  }

  // ─── 书架元数据 ────────────────────────────────────────────────

  static const String _bookshelfBoxName = 'bookshelf';

  Future<Box> get _bookshelfBox async => await Hive.openBox(_bookshelfBoxName);

  Future<void> saveBookshelf(List<NovelBook> books) async {
    final b = await _bookshelfBox;
    await b.put('books', books);
  }

  Future<List<NovelBook>> loadBookshelf() async {
    try {
      final b = await _bookshelfBox;
      final data = b.get('books');
      if (data == null) return [];
      return (data as List).cast<NovelBook>();
    } catch (e) {
      return [];
    }
  }

  // ─── 每本书的内容数据（key 加 bookId_ 前缀隔离）─────────────────────

  Future<void> saveNovelDataForBook(String bookId, NovelPersistData data) async {
    final b = box;
    final p = '${bookId}_';

    if (data.chapters != null) await b.put('${p}chapters', data.chapters!);

    if (data.chapterGraphMap != null) {
      final serialized = <String, String>{};
      for (final e in data.chapterGraphMap!.entries) {
        serialized[e.key.toString()] = json.encode(e.value);
      }
      await b.put('${p}chapterGraphMap', serialized);
    }

    if (data.continueChain != null) await b.put('${p}continueChain', data.continueChain!);

    await b.put('${p}continueIdCounter', data.continueIdCounter ?? 1);
    await b.put('${p}mergedGraph', data.mergedGraph);
    await b.put('${p}batchMergedGraphs', data.batchMergedGraphs ?? []);
    await b.put('${p}lastParsedText', data.lastParsedText ?? '');
    await b.put('${p}currentRegexIndex', data.currentRegexIndex ?? 0);
    await b.put('${p}customRegex', data.customRegex ?? '');
    await b.put('${p}selectedBaseChapterId', data.selectedBaseChapterId ?? '');
    await b.put('${p}writePreview', data.writePreview ?? '');

    if (data.precheckResult != null) {
      await b.put('${p}precheckResult', json.encode(data.precheckResult!));
    } else {
      await b.delete('${p}precheckResult');
    }
    if (data.qualityResult != null) {
      await b.put('${p}qualityResult', json.encode(data.qualityResult!));
    } else {
      await b.delete('${p}qualityResult');
    }
    await b.put('${p}qualityResultShow', data.qualityResultShow ?? false);

    if (data.graphCompliance != null) {
      await b.put('${p}graphCompliance', json.encode(data.graphCompliance!));
    } else {
      await b.delete('${p}graphCompliance');
    }
  }

  Future<NovelPersistData?> loadNovelDataForBook(String bookId) async {
    try {
      final b = box;
      final p = '${bookId}_';
      if (!b.isOpen) return null;
      if (b.get('${p}chapters') == null && b.get('${p}lastParsedText') == null) return null;

      final chapters = b.get('${p}chapters') as List<Chapter>?;

      Map<int, Map<String, dynamic>>? chapterGraphMap;
      final rawGraphMap = b.get('${p}chapterGraphMap') as Map?;
      if (rawGraphMap != null) {
        chapterGraphMap = {};
        for (final entry in rawGraphMap.entries) {
          final key = int.tryParse(entry.key.toString());
          if (key != null) {
            chapterGraphMap[key] = entry.value is String
                ? json.decode(entry.value as String) as Map<String, dynamic>
                : entry.value as Map<String, dynamic>;
          }
        }
      }

      final continueChain = b.get('${p}continueChain') as List<ContinueChapter>?;

      String? mergedGraph;
      final rawMerged = b.get('${p}mergedGraph');
      if (rawMerged is String && rawMerged.isNotEmpty) mergedGraph = rawMerged;

      List<String>? batchMergedGraphs;
      final rawBatch = b.get('${p}batchMergedGraphs');
      if (rawBatch is List) batchMergedGraphs = rawBatch.whereType<String>().toList();

      Map<String, dynamic>? precheckResult;
      final rawPrecheck = b.get('${p}precheckResult');
      if (rawPrecheck is String && rawPrecheck.isNotEmpty) {
        precheckResult = json.decode(rawPrecheck) as Map<String, dynamic>;
      }

      Map<String, dynamic>? qualityResult;
      final rawQuality = b.get('${p}qualityResult');
      if (rawQuality is String && rawQuality.isNotEmpty) {
        qualityResult = json.decode(rawQuality) as Map<String, dynamic>;
      }

      Map<String, dynamic>? graphCompliance;
      final rawCompliance = b.get('${p}graphCompliance');
      if (rawCompliance is String && rawCompliance.isNotEmpty) {
        graphCompliance = json.decode(rawCompliance) as Map<String, dynamic>;
      }

      return NovelPersistData(
        chapters: chapters,
        chapterGraphMap: chapterGraphMap,
        continueChain: continueChain,
        continueIdCounter: b.get('${p}continueIdCounter', defaultValue: 1) as int,
        mergedGraph: mergedGraph,
        batchMergedGraphs: batchMergedGraphs,
        lastParsedText: b.get('${p}lastParsedText', defaultValue: '') as String,
        currentRegexIndex: b.get('${p}currentRegexIndex', defaultValue: 0) as int,
        customRegex: b.get('${p}customRegex', defaultValue: '') as String,
        selectedBaseChapterId: b.get('${p}selectedBaseChapterId', defaultValue: '') as String,
        writePreview: b.get('${p}writePreview', defaultValue: '') as String,
        precheckResult: precheckResult,
        qualityResult: qualityResult,
        qualityResultShow: b.get('${p}qualityResultShow', defaultValue: false) as bool,
        graphCompliance: graphCompliance,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteBookData(String bookId) async {
    final b = box;
    final p = '${bookId}_';
    final keysToDelete = [
      '${p}chapters','${p}chapterGraphMap','${p}continueChain',
      '${p}continueIdCounter','${p}mergedGraph','${p}batchMergedGraphs',
      '${p}lastParsedText','${p}currentRegexIndex','${p}customRegex',
      '${p}selectedBaseChapterId','${p}writePreview',
      '${p}precheckResult','${p}qualityResult','${p}qualityResultShow',
      '${p}graphCompliance',
    ];
    for (final k in keysToDelete) {
      await b.delete(k);
    }
  }

  Future<void> clearNovelData() async {
    await box.clear();
  }
}

// ─── 持久化数据结构 ────────────────────────────────────────────────

class NovelPersistData {
  final List<Chapter>? chapters;
  final Map<int, Map<String, dynamic>>? chapterGraphMap;
  final List<ContinueChapter>? continueChain;
  final int? continueIdCounter;
  final String? mergedGraph;
  final List<String>? batchMergedGraphs;
  final String? lastParsedText;
  final int? currentRegexIndex;
  final String? customRegex;
  final String? selectedBaseChapterId;
  final String? writePreview;
  final Map<String, dynamic>? precheckResult;
  final Map<String, dynamic>? qualityResult;
  final bool? qualityResultShow;
  final Map<String, dynamic>? graphCompliance;

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
