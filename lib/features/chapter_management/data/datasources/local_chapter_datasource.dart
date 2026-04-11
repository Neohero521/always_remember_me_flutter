// Package: chapter_management data datasources
// LocalChapterDatasource: local data source for chapters using existing NovelProvider.

import '../../../../models/chapter.dart';
import '../../../../providers/novel_provider.dart';

/// Local datasource for chapter management.
/// Delegates to existing NovelProvider for state.
class LocalChapterDatasource {
  final NovelProvider _novelProvider;

  LocalChapterDatasource({required NovelProvider novelProvider})
      : _novelProvider = novelProvider;

  /// Get all chapters from NovelProvider.
  List<Chapter> getChapters() {
    return _novelProvider.chapters.cast<Chapter>();
  }

  /// Get chapter by ID.
  Chapter? getChapterById(int id) {
    return _novelProvider.chapters.cast<Chapter?>().firstWhere(
          (c) => c?.id == id,
          orElse: () => null,
        );
  }

  /// Delete chapters - delegates to NovelProvider via book operations.
  /// Note: Chapters are managed through books in NovelProvider.
  Future<void> deleteChapters(List<int> ids) async {
    // Chapters are managed via book in NovelProvider
    // Individual chapter deletion may require book reload
    // This is a stub - actual implementation depends on NovelProvider's design
  }

  /// Import chapters from text.
  Future<List<Chapter>> importFromText(String text) async {
    // Stub - actual implementation depends on NovelProvider's import logic
    return [];
  }
}
