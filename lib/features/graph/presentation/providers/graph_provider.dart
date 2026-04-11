// Package: graph presentation providers
// GraphProvider: presentation-layer state holder that COMPOSES NovelProvider.
// This provider does NOT replace NovelProvider — it wraps and delegates to it,
// following the composition-over-inheritance principle.
//
// Existing code using NovelProvider directly (e.g. GraphViewerScreen) continues
// to work unchanged. This provider provides a Clean-Architecture-aligned
// interface on top of it.

import 'package:flutter/foundation.dart';

import '../../../../providers/novel_provider.dart';
import '../../domain/models/chapter_graph.dart';
import '../../domain/repositories/i_graph_repository.dart';
import '../../domain/usecases/generate_single_graph_usecase.dart';
import '../../data/datasources/local_graph_datasource.dart';
import '../../data/repositories/graph_repository_impl.dart';

/// Graph presentation provider.
///
/// This provider composes the existing [NovelProvider] (the single source of truth)
/// with Clean Architecture use cases for the Graph feature.
///
/// [NovelProvider] is NOT modified — this class wraps and delegates to it,
/// following the composition-over-inheritance principle.
///
/// Usage example:
/// ```dart
/// // In a widget that needs graph operations:
/// final graph = context.read<GraphProvider>();
/// await graph.generateGraphForChapter(1);
/// ```
class GraphProvider extends ChangeNotifier {
  late final IGraphRepository _repository;
  late final GenerateSingleGraphUseCase _generateSingleGraphUseCase;

  GraphProvider({
    required NovelProvider novelProvider,
    LocalGraphDatasource? datasource,
  }) {
    final ds = datasource ?? LocalGraphDatasource();
    _repository = GraphRepositoryImpl(
      novelProvider: novelProvider,
    );
    _generateSingleGraphUseCase = GenerateSingleGraphUseCase(_repository);
  }

  // ─── Proxy getters from NovelProvider (read-through) ──────────

  /// The merged global knowledge graph, if available.
  Map<String, dynamic>? get mergedGraph => _repository.getMergedGraph();

  /// All chapter graphs map.
  Map<int, Map<String, dynamic>> get allChapterGraphs =>
      _repository.getAllChapterGraphs();

  /// Whether graph generation is currently in progress.
  bool get isGeneratingGraph => _repository.isGeneratingGraph;

  /// Current progress text during graph operations.
  String get graphProgressText => _repository.graphProgressText;

  // ─── Use case methods ──────────────────────────────────────────

  /// Generate a knowledge graph for a specific chapter.
  Future<void> generateGraphForChapter(int chapterId) {
    return _generateSingleGraphUseCase(chapterId);
  }

  /// Generate knowledge graphs for all chapters.
  Future<void> generateGraphsForAllChapters() {
    return _repository.generateGraphsForAllChapters();
  }

  /// Stop ongoing graph generation.
  void stopGraphGeneration() {
    _repository.stopGraphGeneration();
  }

  /// Batch merge graphs in groups.
  Future<void> batchMergeGraphs({int batchSize = 50}) {
    return _repository.batchMergeGraphs(batchSize: batchSize);
  }

  /// Merge all chapter graphs into one global graph.
  Future<void> mergeAllGraphs() {
    return _repository.mergeAllGraphs();
  }

  /// Validate graph compliance and return the result.
  GraphComplianceResult? validateGraphCompliance() {
    return _repository.validateGraphCompliance();
  }

  /// Get status summary of all chapter graphs.
  ChapterGraphStatus getChapterGraphStatus() {
    return _repository.getChapterGraphStatus();
  }

  /// Get a chapter graph by chapter ID.
  Map<String, dynamic>? getChapterGraph(int chapterId) {
    return _repository.getChapterGraph(chapterId);
  }

  /// Export chapter graphs as JSON string.
  String exportChapterGraphsJson() {
    return _repository.exportChapterGraphsJson();
  }

  /// Import chapter graphs from JSON string.
  void importChapterGraphsJson(String jsonString) {
    _repository.importChapterGraphsJson(jsonString);
  }
}
