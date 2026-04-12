import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

class NovelLocalDatasource {
  final AppDatabase _db;
  NovelLocalDatasource(this._db);

  Future<List<NovelEntity>> getNovels() => _db.getAllNovels();
  Stream<List<NovelEntity>> watchNovels() => _db.watchAllNovels();
  Future<NovelEntity?> getById(String id) => _db.getNovelById(id);

  Future<void> insert(NovelEntity novel) => _db.insertNovel(NovelsCompanion(
        id: Value(novel.id),
        title: Value(novel.title),
        author: Value(novel.author),
        cover: Value(novel.cover),
        introduction: Value(novel.introduction),
        createdAt: Value(novel.createdAt),
        updatedAt: Value(novel.updatedAt),
      ));

  Future<void> update(NovelEntity novel) => _db.updateNovel(NovelsCompanion(
        id: Value(novel.id),
        title: Value(novel.title),
        author: Value(novel.author),
        cover: Value(novel.cover),
        introduction: Value(novel.introduction),
        createdAt: Value(novel.createdAt),
        updatedAt: Value(novel.updatedAt),
      ));

  Future<void> delete(String id) => _db.deleteNovelWithRelated(id);
}
