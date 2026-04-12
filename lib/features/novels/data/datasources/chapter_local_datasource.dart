import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

class ChapterLocalDatasource {
  final AppDatabase _db;
  ChapterLocalDatasource(this._db);

  Future<List<ChapterEntity>> getByNovel(String novelId) =>
      _db.getChaptersByNovel(novelId);

  Stream<List<ChapterEntity>> watch(String novelId) =>
      _db.watchChaptersByNovel(novelId);

  Future<ChapterEntity?> getById(String id) => _db.getChapterById(id);

  Future<void> insert(ChapterEntity chapter) => _db.insertChapter(ChaptersCompanion(
        id: Value(chapter.id),
        novelId: Value(chapter.novelId),
        number: Value(chapter.number),
        title: Value(chapter.title),
        content: Value(chapter.content),
        graphId: Value(chapter.graphId),
        wordCount: Value(chapter.wordCount),
        createdAt: Value(chapter.createdAt),
      ));

  Future<void> update(ChapterEntity chapter) => _db.updateChapter(ChaptersCompanion(
        id: Value(chapter.id),
        novelId: Value(chapter.novelId),
        number: Value(chapter.number),
        title: Value(chapter.title),
        content: Value(chapter.content),
        graphId: Value(chapter.graphId),
        wordCount: Value(chapter.wordCount),
        createdAt: Value(chapter.createdAt),
      ));

  Future<void> delete(String id) => _db.deleteChapter(id);
  Future<void> deleteByNovel(String novelId) => _db.deleteChaptersByNovel(novelId);
}
