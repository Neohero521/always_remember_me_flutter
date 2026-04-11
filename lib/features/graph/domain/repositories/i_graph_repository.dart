// Package: graph domain repositories
// IGraphRepository: abstract interface for graph operations.

import '../models/chapter_graph.dart';

/// Abstract repository interface for graph management.
/// Defines the contract for graph-related operations.
abstract class IGraphRepository {
  /// Get the merged global knowledge graph.
  Map<String, dynamic>? getMergedGraph();

  /// Get a chapter graph by chapter ID.
  Map<String, dynamic>? getChapterGraph(int chapterId);

  /// Get all chapter graphs map.
  Map<int, Map<String, dynamic>> getAllChapterGraphs();

  /// Generate a graph for a specific chapter.
  Future<void> generateGraphForChapter(int chapterId);

  /// Generate graphs for all chapters.
  Future<void> generateGraphsForAllChapters();

  /// Stop ongoing graph generation.
  void stopGraphGeneration();

  /// Batch merge graphs in groups.
  Future<void> batchMergeGraphs({int batchSize = 50});

  /// Merge all chapter graphs into one global graph.
  Future<void> mergeAllGraphs();

  /// Validate graph compliance and return the result.
  GraphComplianceResult? validateGraphCompliance();

  /// Get status summary of all chapter graphs.
  ChapterGraphStatus getChapterGraphStatus();

  /// Export chapter graphs as JSON string.
  String exportChapterGraphsJson();

  /// Import chapter graphs from JSON string.
  void importChapterGraphsJson(String jsonString);

  /// Check if graph generation is currently in progress.
  bool get isGeneratingGraph;

  /// Get current graph progress text.
  String get graphProgressText;
}
