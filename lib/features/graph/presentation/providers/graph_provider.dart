import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/chapter.dart';
import '../../../../services/novel_api_service.dart';

/// v5.0 Graph State
class GraphState {
  final Map<int, Map<String, dynamic>> chapterGraphMap;
  final Map<String, dynamic>? mergedGraph;
  final List<Map<String, dynamic>> batchMergedGraphs;
  final bool isGenerating;
  final bool isMerging;
  final bool stopFlag;
  final String progressText;
  final List<String> failedChapterIds;
  final String? graphComplianceResult;
  final bool? graphCompliancePass;
  final String? error;

  const GraphState({
    this.chapterGraphMap = const {},
    this.mergedGraph,
    this.batchMergedGraphs = const [],
    this.isGenerating = false,
    this.isMerging = false,
    this.stopFlag = false,
    this.progressText = '',
    this.failedChapterIds = const [],
    this.graphComplianceResult,
    this.graphCompliancePass,
    this.error,
  });

  GraphState copyWith({
    Map<int, Map<String, dynamic>>? chapterGraphMap,
    Map<String, dynamic>? mergedGraph,
    List<Map<String, dynamic>>? batchMergedGraphs,
    bool? isGenerating,
    bool? isMerging,
    bool? stopFlag,
    String? progressText,
    List<String>? failedChapterIds,
    String? graphComplianceResult,
    bool? graphCompliancePass,
    String? error,
  }) {
    return GraphState(
      chapterGraphMap: chapterGraphMap ?? this.chapterGraphMap,
      mergedGraph: mergedGraph ?? this.mergedGraph,
      batchMergedGraphs: batchMergedGraphs ?? this.batchMergedGraphs,
      isGenerating: isGenerating ?? this.isGenerating,
      isMerging: isMerging ?? this.isMerging,
      stopFlag: stopFlag ?? this.stopFlag,
      progressText: progressText ?? this.progressText,
      failedChapterIds: failedChapterIds ?? this.failedChapterIds,
      graphComplianceResult: graphComplianceResult ?? this.graphComplianceResult,
      graphCompliancePass: graphCompliancePass ?? this.graphCompliancePass,
      error: error,
    );
  }
}

/// v5.0 Graph Notifier
class GraphNotifier extends StateNotifier<GraphState> {
  final NovelApiService? apiService;

  GraphNotifier({required this.apiService}) : super(const GraphState());

  void loadGraphs(Map<int, Map<String, dynamic>> graphs) {
    state = state.copyWith(chapterGraphMap: graphs);
  }

  Future<void> generateGraphForChapter(Chapter chapter) async {
    if (apiService == null) return;

    state = state.copyWith(isGenerating: true, stopFlag: false, progressText: '正在生成图谱...', error: null);

    try {
      final graph = await apiService!.generateSingleChapterGraph(
        chapterId: chapter.id,
        chapterTitle: chapter.title,
        chapterContent: chapter.content,
      );
      state = state.copyWith(
        isGenerating: false,
        progressText: '',
        chapterGraphMap: {...state.chapterGraphMap, chapter.id: graph},
      );
    } catch (e) {
      state = state.copyWith(isGenerating: false, progressText: '', error: '图谱生成失败: $e');
    }
  }

  Future<void> generateAllGraphs(List<Chapter> chapters) async {
    if (apiService == null) return;

    state = state.copyWith(isGenerating: true, stopFlag: false, error: null);
    int successCount = 0;
    int failCount = 0;
    final List<String> failed = [];

    for (int i = 0; i < chapters.length; i++) {
      if (state.stopFlag) break;

      final chapter = chapters[i];
      state = state.copyWith(
        progressText: '图谱生成进度: ${i + 1}/${chapters.length}（成功$successCount / 失败$failCount）',
      );

      if (!state.chapterGraphMap.containsKey(chapter.id)) {
        try {
          final graph = await apiService!.generateSingleChapterGraph(
            chapterId: chapter.id,
            chapterTitle: chapter.title,
            chapterContent: chapter.content,
          );
          state = state.copyWith(
            chapterGraphMap: {...state.chapterGraphMap, chapter.id: graph},
          );
          successCount++;
        } catch (e) {
          failCount++;
          failed.add(chapter.title);
        }
      } else {
        successCount++;
      }

      if (i < chapters.length - 1 && !state.stopFlag) {
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    state = state.copyWith(
      isGenerating: false,
      stopFlag: false,
      progressText: failCount > 0
          ? '图谱生成完成：成功 $successCount 个，失败 $failCount 个'
          : '图谱生成完成：成功 $successCount 个',
      failedChapterIds: failed,
    );
  }

  Future<void> batchMergeGraphs({int batchSize = 50}) async {
    if (apiService == null) return;

    final sortedIds = state.chapterGraphMap.keys.toList()..sort();
    final graphList = sortedIds.map((id) => state.chapterGraphMap[id]!).toList();

    if (graphList.isEmpty) return;

    state = state.copyWith(isMerging: true, stopFlag: false, batchMergedGraphs: []);

    final batches = <List<Map<String, dynamic>>>[];
    for (int i = 0; i < graphList.length; i += batchSize) {
      batches.add(graphList.sublist(i, (i + batchSize).clamp(0, graphList.length)));
    }

    try {
      for (int i = 0; i < batches.length; i++) {
        if (state.stopFlag) break;
        state = state.copyWith(progressText: '分批合并进度: ${i + 1}/${batches.length}');

        final merged = await apiService!.batchMergeGraphs(
          graphList: batches[i],
          batchNumber: i + 1,
          totalBatches: batches.length,
        );
        state = state.copyWith(
          batchMergedGraphs: [...state.batchMergedGraphs, merged],
        );

        if (i < batches.length - 1 && !state.stopFlag) {
          await Future.delayed(const Duration(milliseconds: 1500));
        }
      }
    } catch (e) {
      state = state.copyWith(isMerging: false, error: '分批合并失败: $e');
    } finally {
      state = state.copyWith(isMerging: false, stopFlag: false, progressText: '');
    }
  }

  Future<void> mergeAllGraphs() async {
    if (apiService == null) return;

    List<Map<String, dynamic>> graphList;
    if (state.batchMergedGraphs.isNotEmpty) {
      graphList = state.batchMergedGraphs;
    } else {
      graphList = state.chapterGraphMap.values.toList();
    }

    if (graphList.isEmpty) return;

    state = state.copyWith(isMerging: true, progressText: '正在合并全量图谱...', stopFlag: false);

    try {
      final merged = await apiService!.mergeAllGraphs(graphList: graphList);
      state = state.copyWith(mergedGraph: merged, isMerging: false, progressText: '');
    } catch (e) {
      state = state.copyWith(isMerging: false, progressText: '', error: '全量图谱合并失败: $e');
    }
  }

  void validateCompliance() {
    final graph = state.mergedGraph;
    if (graph == null) {
      state = state.copyWith(
        graphCompliancePass: false,
        graphComplianceResult: '图谱尚未合并，请先生成合并图谱',
      );
      return;
    }

    const requiredFields = [
      '全局基础信息', '人物信息库', '世界观设定库', '全剧情时间线',
      '全局文风标准', '全量实体关系网络', '反向依赖图谱', '逆向分析与质量评估',
    ];
    final missing = requiredFields.where((f) => !graph.containsKey(f)).toList();
    final jsonStr = graph.toString();
    final wordCount = jsonStr.length;

    if (missing.isNotEmpty) {
      state = state.copyWith(
        graphCompliancePass: false,
        graphComplianceResult: '图谱合规性校验不通过，缺少必填字段：${missing.join("、")}',
      );
    } else if (wordCount < 1200) {
      state = state.copyWith(
        graphCompliancePass: false,
        graphComplianceResult: '图谱合规性校验不通过，内容字数不足（$wordCount < 1200）',
      );
    } else {
      state = state.copyWith(
        graphCompliancePass: true,
        graphComplianceResult: '图谱合规性校验通过，内容字数：$wordCount字',
      );
    }
  }

  void stop() {
    state = state.copyWith(stopFlag: true, isGenerating: false, isMerging: false, progressText: '');
  }

  void clearMerged() {
    state = state.copyWith(mergedGraph: null, batchMergedGraphs: []);
  }

  void importGraphs(Map<String, dynamic> data) {
    final importedMap = data['chapterGraphMap'] as Map<String, dynamic>? ?? {};
    final newMap = Map<int, Map<String, dynamic>>.from(state.chapterGraphMap);
    for (final entry in importedMap.entries) {
      final key = int.tryParse(entry.key);
      if (key != null) {
        newMap[key] = entry.value as Map<String, dynamic>;
      }
    }
    state = state.copyWith(chapterGraphMap: newMap);
  }

  String exportJson() {
    final exportData = {
      'exportTime': DateTime.now().toIso8601String(),
      'chapterGraphMap': state.chapterGraphMap.map((k, v) => MapEntry(k.toString(), v)),
    };
    return exportData.toString();
  }
}

final graphProvider = StateNotifierProvider<GraphNotifier, GraphState>((ref) {
  return GraphNotifier(apiService: null);
});
