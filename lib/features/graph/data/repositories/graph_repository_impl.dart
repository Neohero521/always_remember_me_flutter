// Package: graph data repositories
// GraphRepositoryImpl: concrete implementation of IGraphRepository.
// Uses NovelProvider (injected) for all in-memory state mutations.

import '../../../../providers/novel_provider.dart';
import '../../domain/models/chapter_graph.dart';
import '../../domain/repositories/i_graph_repository.dart';

/// Concrete implementation of [IGraphRepository].
///
/// This repository bridges the domain layer with the data layer:
/// - Delegates all state mutations to the provided [NovelProvider] instance,
///   which is the single source of truth for the application's novel state.
/// - Provides a Clean Architecture-aligned interface on top of it.
///
/// IMPORTANT: This repository does NOT manage its own state.
/// It delegates all operations to [NovelProvider].
class GraphRepositoryImpl implements IGraphRepository {
  final NovelProvider _novelProvider;

  GraphRepositoryImpl({required NovelProvider novelProvider})
      : _novelProvider = novelProvider;

  @override
  Map<String, dynamic>? getMergedGraph() {
    return _novelProvider.mergedGraph;
  }

  @override
  Map<String, dynamic>? getChapterGraph(int chapterId) {
    return _novelProvider.chapterGraphMap[chapterId];
  }

  @override
  Map<int, Map<String, dynamic>> getAllChapterGraphs() {
    return _novelProvider.chapterGraphMap;
  }

  @override
  Future<void> generateGraphForChapter(int chapterId) async {
    await _novelProvider.generateGraphForChapter(chapterId);
  }

  @override
  Future<void> generateGraphsForAllChapters() async {
    await _novelProvider.generateGraphsForAllChapters();
  }

  @override
  void stopGraphGeneration() {
    _novelProvider.stopGraphGeneration();
  }

  @override
  Future<void> batchMergeGraphs({int batchSize = 50}) async {
    await _novelProvider.batchMergeGraphs(batchSize: batchSize);
  }

  @override
  Future<void> mergeAllGraphs() async {
    await _novelProvider.mergeAllGraphs();
  }

  @override
  GraphComplianceResult? validateGraphCompliance() {
    _novelProvider.validateGraphCompliance();
    final pass = _novelProvider.graphCompliancePass;
    final result = _novelProvider.graphComplianceResult;
    if (pass == null) {
      return const GraphComplianceResult(
        passed: false,
        message: '尚未生成合并图谱',
      );
    }
    return GraphComplianceResult(
      passed: pass,
      message: result ?? '',
    );
  }

  @override
  ChapterGraphStatus getChapterGraphStatus() {
    final status = _novelProvider.getChapterGraphStatus();
    return ChapterGraphStatus(
      totalCount: status['totalCount'] as int,
      hasGraphCount: status['hasGraphCount'] as int,
      noGraphCount: status['noGraphCount'] as int,
      noGraphTitles: (status['noGraphTitles'] as List<String>),
    );
  }

  @override
  String exportChapterGraphsJson() {
    return _novelProvider.exportChapterGraphsJson();
  }

  @override
  void importChapterGraphsJson(String jsonString) {
    _novelProvider.importChapterGraphsJson(jsonString);
  }

  @override
  bool get isGeneratingGraph => _novelProvider.isGeneratingGraph;

  @override
  String get graphProgressText => _novelProvider.graphProgressText;
}
