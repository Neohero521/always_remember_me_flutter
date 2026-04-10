# 实施指南：NovelProvider Hive 改造

> 以下为改造 `novel_provider.dart` 的关键代码片段。完整改造需按顺序执行。

---

## Step 1: 修改 import 和字段

```dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chapter.dart';
import '../models/knowledge_graph.dart';
import '../services/chapter_service.dart';
import '../services/novel_api_service.dart';
import '../services/storage_service.dart';  // ← 新增

/// 全局状态管理
class NovelProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  // 防抖写入定时器（避免每次状态变更都触发 Hive IO）
  Timer? _persistTimer;
  static const _persistDebounceMs = 300;

  // ... 现有字段保持不变 ...
```

---

## Step 2: 添加 debounced 持久化触发器

```dart
/// 防抖持久化：状态变更后延迟 _persistDebounceMs 写入 Hive
void _schedulePersist() {
  _persistTimer?.cancel();
  _persistTimer = Timer(
    const Duration(milliseconds: _persistDebounceMs),
    _doPersist,
  );
}

/// 实际执行 Hive 写入
Future<void> _doPersist() async {
  try {
    await _storage.saveNovelData(NovelPersistData(
      chapters: _chapters,
      chapterGraphMap: _chapterGraphMap,
      continueChain: _continueChain,
      continueIdCounter: _continueIdCounter,
      mergedGraph: _mergedGraph != null
          ? const JsonEncoder.withIndent('  ').convert(_mergedGraph)
          : null,
      batchMergedGraphs: _batchMergedGraphs
          .map((g) => const JsonEncoder.withIndent('  ').convert(g))
          .toList(),
      lastParsedText: _lastParsedText,
      currentRegexIndex: _currentRegexIndex,
      customRegex: _customRegex,
      selectedBaseChapterId: _selectedBaseChapterId,
      writePreview: _writePreview,
      precheckResult: _precheckResult != null
          ? _precheckResultToJson(_precheckResult!)
          : null,
      qualityResult: _qualityResult != null
          ? _qualityResultToJson(_qualityResult!)
          : null,
      qualityResultShow: _qualityResultShow,
      graphCompliance: (_graphComplianceResult != null || _graphCompliancePass != null)
          ? {
              'result': _graphComplianceResult,
              'pass': _graphCompliancePass,
            }
          : null,
    ));
  } catch (e) {
    debugPrint('Hive 持久化失败: $e');
  }
}
```

---

## Step 3: 改造 `loadSettings()` — 从 Hive 加载

```dart
Future<void> loadSettings() async {
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

  // 2. 从 Hive 加载核心小说数据（P0 阻断问题修复）
  try {
    final novelData = await _storage.loadNovelData();
    if (novelData != null) {
      _chapters = novelData.chapters ?? [];
      _chapterGraphMap = novelData.chapterGraphMap ?? {};
      _continueChain = novelData.continueChain ?? [];
      _continueIdCounter = novelData.continueIdCounter ?? 1;

      // mergedGraph: JSON string → Map
      if (novelData.mergedGraph != null && novelData.mergedGraph!.isNotEmpty) {
        _mergedGraph = json.decode(novelData.mergedGraph!) as Map<String, dynamic>;
      }

      // batchMergedGraphs: List<String> → List<Map>
      _batchMergedGraphs = (novelData.batchMergedGraphs ?? [])
          .map((s) => json.decode(s) as Map<String, dynamic>)
          .toList();

      _lastParsedText = novelData.lastParsedText ?? '';
      _currentRegexIndex = novelData.currentRegexIndex ?? 0;
      _customRegex = novelData.customRegex ?? '';
      _selectedBaseChapterId = novelData.selectedBaseChapterId ?? '';
      _writePreview = novelData.writePreview ?? '';

      if (novelData.precheckResult != null) {
        _precheckResult = PrecheckResult.fromJson(novelData.precheckResult!);
      }
      if (novelData.qualityResult != null) {
        _qualityResult = QualityResult.fromJson(novelData.qualityResult!);
      }
      _qualityResultShow = novelData.qualityResultShow ?? false;

      if (novelData.graphCompliance != null) {
        _graphComplianceResult = novelData.graphCompliance!['result'] as String?;
        _graphCompliancePass = novelData.graphCompliance!['pass'] as bool?;
      }
    }
  } catch (e) {
    debugPrint('Hive 数据加载失败: $e');
    // 损坏时走兜底，不崩溃
  }

  notifyListeners();
}
```

---

## Step 4: 在关键方法末尾添加 `_schedulePersist()`

对以下方法，在 `notifyListeners()` 之后追加 `_schedulePersist()`：

```dart
// 解析章节 → 重置图谱状态
void parseChapters(...) {
  // ... 现有逻辑 ...
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
  _schedulePersist();  // ← 新增
}

// 生成单章节图谱后
Future<void> generateGraphForChapter(int chapterId) async {
  // ... 现有逻辑 ...
  _chapterGraphMap[chapterId] = graph;
  // ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 批量合并图谱后
Future<void> batchMergeGraphs({int batchSize = 50}) async {
  // ... 现有逻辑 ...
  _batchMergedGraphs.add(merged);
  // ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 全量合并图谱后
Future<void> mergeAllGraphs() async {
  // ... 现有逻辑 ...
  _mergedGraph = merged;
  // ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 续写生成后
Future<String?> generateWrite({String? modifiedContent}) async {
  // ... 现有逻辑 ...
  _continueChain.add(newChapter);
  // ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 链条续写后
Future<String?> continueFromChain(int targetChainId) async {
  // ... 现有逻辑 ...
  _continueChain.add(newChapter);
  // ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 图谱导入后
void importChapterGraphsJson(String jsonString) {
  // ... 现有逻辑 ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 魔改章节图谱更新后
Future<Map<String, dynamic>?> updateModifiedChapterGraph(...) async {
  // ... 现有逻辑 ...
  _chapterGraphMap[chapterId] = graph;
  // ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 续写章节图谱更新后
Future<Map<String, dynamic>?> updateGraphWithContinueContent(...) async {
  // ... 现有逻辑 ...
  _chapterGraphMap[-continueId] = graph;
  // ...
  notifyListeners();
  _schedulePersist();  // ← 新增
}

// 续写链条变更后
void removeContinueChapter(int chainId) {
  _continueChain.removeWhere((c) => c.id == chainId);
  notifyListeners();
  _schedulePersist();  // ← 新增
}

void clearContinueChain() {
  _continueChain = [];
  _continueIdCounter = 1;
  notifyListeners();
  _schedulePersist();  // ← 新增
}

void clearBatchMergedGraphs() {
  _batchMergedGraphs = [];
  notifyListeners();
  _schedulePersist();  // ← 新增
}

void clearMergedGraph() {
  _mergedGraph = null;
  notifyListeners();
  _schedulePersist();  // ← 新增
}
```

---

## Step 5: `main.dart` 初始化顺序

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Hive 初始化（必须 first）
  await StorageService().init();

  runApp(const MyApp());
}
```

---

## Step 6: 注册 Hive TypeAdapter（生成命令）

```bash
cd /home/kaku5/.openclaw/workspace/always_remember_me_flutter
dart run build_runner build
```

这会生成 `lib/models/chapter.g.dart`，包含 `ChapterAdapter()` 和 `ContinueChapterAdapter()`。

---

## Step 7: Provider 注入改造（`main.dart`）

```dart
import 'package:provider/provider.dart';
import 'providers/novel_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => NovelProvider()..loadSettings(),
      child: const MyApp(),
    ),
  );
}
```

注意：`NovelProvider()` 构造和 `loadSettings()` 之间有异步 IO，`loadSettings` 是懒加载调用的，不需要 await，UI 会先渲染，数据加载完成后 `notifyListeners()` 更新 UI。

---

## 附录：辅助方法

```dart
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
```

---

## 不需要持久化的字段（临时状态）

以下字段为 UI 临时状态，不需要写入 Hive：

| 字段 | 原因 |
|------|------|
| `_isGeneratingGraph` | 内存标志，进程重启后自然归零 |
| `_isGeneratingWrite` | 同上 |
| `_stopFlag` | 同上 |
| `_graphProgressText` | 内存字符串，进程重启后自然归零 |
| `_writeProgressText` | 同上 |
| `_sortedRegexList` | 解析中间状态，由 `lastParsedText` + `currentRegexIndex` 恢复 |
| `_apiService` | 内存对象，重启后重新创建即可 |
