// Package: chapter_management domain repositories
// IChapterRepository: abstract interface for chapter operations.

import '../models/chapter.dart';

/// Abstract repository interface for chapter management.
/// Defines the contract for chapter-related operations.
abstract class IChapterRepository {
  /// Get all chapters for the current novel.
  List<Chapter> getChapters();

  /// Get a chapter by ID.
  Chapter? getChapterById(int id);

  /// Delete a chapter by ID.
  Future<void> deleteChapter(int id);

  /// Delete multiple chapters by IDs.
  Future<void> deleteChapters(List<int> ids);

  /// Update chapter content.
  Future<void> updateChapter(Chapter chapter);

  /// Import chapters from text.
  Future<List<Chapter>> importFromText(String text);

  /// Generate graph for a chapter.
  Future<void> generateGraph(int chapterId);
}
