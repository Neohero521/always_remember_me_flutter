// Package: chapter_management data repositories
// ChapterRepositoryImpl: concrete implementation of IChapterRepository.

import '../../domain/models/chapter.dart';
import '../../domain/repositories/i_chapter_repository.dart';
import '../datasources/local_chapter_datasource.dart';

/// Concrete implementation of IChapterRepository.
class ChapterRepositoryImpl implements IChapterRepository {
  final LocalChapterDatasource _datasource;

  ChapterRepositoryImpl({required LocalChapterDatasource datasource})
      : _datasource = datasource;

  @override
  List<Chapter> getChapters() {
    return _datasource.getChapters();
  }

  @override
  Chapter? getChapterById(int id) {
    return _datasource.getChapterById(id);
  }

  @override
  Future<void> deleteChapter(int id) async {
    await _datasource.deleteChapters([id]);
  }

  @override
  Future<void> deleteChapters(List<int> ids) async {
    await _datasource.deleteChapters(ids);
  }

  @override
  Future<void> updateChapter(Chapter chapter) async {
    // Stub - actual implementation depends on NovelProvider's design
  }

  @override
  Future<List<Chapter>> importFromText(String text) async {
    return await _datasource.importFromText(text);
  }

  @override
  Future<void> generateGraph(int chapterId) async {
    // Delegate to NovelProvider's graph generation
    // This is a stub
  }
}
