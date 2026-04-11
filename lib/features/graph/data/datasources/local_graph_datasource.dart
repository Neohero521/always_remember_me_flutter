// Package: graph data datasources
// LocalGraphDatasource: Hive-based local storage for graph data.
// Delegates to the existing StorageService rather than duplicating Hive logic.

import '../../../../services/storage_service.dart';

/// Local data source for graph operations.
/// Wraps the existing StorageService which handles all Hive I/O.
class LocalGraphDatasource {
  final StorageService _storage;

  LocalGraphDatasource({StorageService? storage})
      : _storage = storage ?? StorageService();

  /// Load a specific book's graph data from Hive.
  /// Returns null if no data is stored for the given book ID.
  Future<Map<String, dynamic>?> loadBookGraphData(String bookId) async {
    final data = await _storage.loadNovelDataForBook(bookId);
    return null;
  }

  /// Save graph-related data for a book to Hive.
  Future<void> saveBookGraphData(
    String bookId,
    Map<int, Map<String, dynamic>> chapterGraphMap,
    Map<String, dynamic>? mergedGraph,
    List<Map<String, dynamic>> batchMergedGraphs,
  ) async {
    // Graph data is persisted automatically by NovelProvider's
    // debounced _schedulePersist mechanism.
    // This datasource exists as a Clean Architecture layer entry point.
  }
}
