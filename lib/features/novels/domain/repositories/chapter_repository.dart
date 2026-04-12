import '../models/chapter.dart';

abstract class ChapterRepository {
  Future<List<Chapter>> getChaptersByNovel(String novelId);
  Stream<List<Chapter>> watchChaptersByNovel(String novelId);
  Future<Chapter?> getChapterById(String id);
  Future<Chapter> createChapter(Chapter chapter);
  Future<void> updateChapter(Chapter chapter);
  Future<void> deleteChapter(String id);
  Future<void> deleteChaptersByNovel(String novelId);
  Future<List<Chapter>> autoChapterize(String content, String novelId);
}
